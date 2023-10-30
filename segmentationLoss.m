function loss = segmentationLoss(predict, target)

% Generate the one-hot encodings of the ground truth.
oneHotTarget = onehotencode(categorical(extractdata(target)),4);

% Convert the one-hot encoded data to dlarray.
oneHotTarget = dlarray(oneHotTarget,'SSBC');

% Compute the softmax output of the predictions.
predictSoftmax = softmax(predict);

% Compute the cross-entropy loss.
loss =  crossentropy(predictSoftmax,oneHotTarget,'ClassificationMode','single-label')/(numel(oneHotTarget)/2);
end