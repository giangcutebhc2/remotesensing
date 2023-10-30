clear all
%% Download CamVid Dataset
outputFolder = fullfile(pwd,'Potsdam'); 
% labelsZip = fullfile(outputFolder,'labels.zip');
% imagesZip = fullfile(outputFolder,'images.zip');

% if ~exist(labelsZip, 'file') || ~exist(imagesZip,'file')   
%     mkdir(outputFolder)
%        
%     disp('Downloading 16 MB CamVid dataset labels...'); 
%     websave(labelsZip, labelURL);
%     unzip(labelsZip, fullfile(outputFolder,'labels'));
%     
%     disp('Downloading 557 MB CamVid dataset images...');  
%     websave(imagesZip, imageURL);       
%     unzip(imagesZip, fullfile(outputFolder,'images'));    
% end

rng(0)
%% Load CamVid Images
imgDir = fullfile(outputFolder,'train','Images');
imdsTrain = imageDatastore(imgDir);

I = readimage(imdsTrain,1);
I = histeq(I);
imshow(I)

%% Load CamVid Pixel-Labeled Images
classes = [
    "ImperviousSurfaces"
    "Building"
    "LowVegetation"
    "Tree"
    "Car"
    "BackgroundClutter"
    ];

labelIDs = potsdamPixelLabelIDs();

labelDir = fullfile(outputFolder,'train','Labels');
pxdsTrain = pixelLabelDatastore(labelDir,classes,labelIDs);


C = readimage(pxdsTrain,1);
cmap = potsdamColorMap;
B = labeloverlay(I,C,'ColorMap',cmap);
imshow(B)
pixelLabelColorbar(cmap,classes);

% Prepare dataloader for val and test
imgDir = fullfile(outputFolder,'val','Images');
imdsVal = imageDatastore(imgDir);
labelDir = fullfile(outputFolder,'val','Labels');
pxdsVal = pixelLabelDatastore(labelDir,classes,labelIDs);


%% Analyze Dataset Statistics
tbl = countEachLabel(pxdsTrain);
frequency = tbl.PixelCount/sum(tbl.PixelCount);

bar(1:numel(classes),frequency)
xticks(1:numel(classes)) 
xticklabels(tbl.Name)
xtickangle(45)
ylabel('Frequency')

%% Prepare Training, Validation, and Test Sets
numTrainingImages = numel(imdsTrain.Files);
numValImages = numel(imdsVal.Files);

%% Create the Network
% Specify the network image size. This is typically the same as the traing image sizes.
imageSize = [2000 2000 3];

% Specify the number of classes.
numClasses = numel(classes);

% Create DeepLab v3+ with resnet18, resnet50, mobilenetv2, xception.

encoderDepth = 3;
lgraph = unetLayers(imageSize,numClasses,'EncoderDepth',encoderDepth);


%% Balance Classes Using Class Weighting
imageFreq = tbl.PixelCount ./ tbl.ImagePixelCount;
classWeights = median(imageFreq) ./ imageFreq;

pxLayer = pixelClassificationLayer('Name','labels','Classes',tbl.Name,'ClassWeights',classWeights);
lgraph = replaceLayer(lgraph,"Segmentation-Layer",pxLayer);
analyzeNetwork(lgraph)

%% Select Training Options

% Define validation data.
dsVal = combine(imdsVal,pxdsVal);

% Define training options. 
options = trainingOptions('sgdm', ...
    'LearnRateSchedule','piecewise',...
    'LearnRateDropPeriod',10,...
    'LearnRateDropFactor',0.3,...
    'Momentum',0.9, ...
    'InitialLearnRate',1e-3, ...
    'L2Regularization',0.005, ...
    'ValidationData',dsVal,...
    'ValidationFrequency', 117,...
    'MaxEpochs',30, ...  
    'MiniBatchSize',2, ...
    'Shuffle','every-epoch', ...
    'CheckpointPath', tempdir, ...
    'VerboseFrequency',10,...
    'Plots','training-progress',...
    'OutputNetwork', 'best-validation-loss');

%% Data Augmentation
dsTrain = combine(imdsTrain, pxdsTrain);

xTrans = [-10 10];
yTrans = [-10 10];
dsTrain = transform(dsTrain, @(data)augmentImageAndLabel(data,xTrans,yTrans));

%% Start Training
doTraining = true;
if doTraining    
    [net, info] = trainNetwork(dsTrain,lgraph,options);
else
    pretrainedNetwork = fullfile(pretrainedFolder,'deeplabv3plusResnet18CamVid.mat');  
    data = load(pretrainedNetwork);
    net = data.net;
end

%% Test Network on One Image
I = readimage(imdsVal,1);
C = semanticseg(I, net);
B = labeloverlay(I,C,'Colormap',cmap,'Transparency',0.4);
imshow(B)
pixelLabelColorbar(cmap, classes);


% expectedResult = readimage(pxdsVal,1);
% actual = uint8(C);
% expected = uint8(expectedResult);
% imshowpair(actual, expected)

% iou = jaccard(C,expectedResult);
% table(classes,iou)

%% Evaluate Trained Network
pxdsResults = semanticseg(imdsVal,net, ...
    'MiniBatchSize',2, ...
    'WriteLocation',tempdir, ...
    'Verbose',false);

metrics = evaluateSemanticSegmentation(pxdsResults,pxdsVal,'Verbose',false);

metrics.DataSetMetrics

metrics.ClassMetrics

% %% Save in file
trainednetInfo = {};
trainednetInfo{1,1} = net;
trainednetInfo{1,2} = metrics;
trainednetInfo{1,3} = options;
save('potsdam_unet.mat','trainednetInfo')
