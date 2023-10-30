% Đường dẫn đến thư mục chứa các thư mục sq
parentDir = 'D:\Segmentation\uavid_v1.5_official_release_image\uavid_test';

% Đường dẫn đến thư mục lưu trữ ảnh và nhãn mới
outputDir = 'D:\Segmentation\uavid_v1.5_official_release_image\test_data\Images';

% Tạo thư mục mới để lưu ảnh và nhãn đã gom
mkdir(outputDir);


% Đường dẫn đến thư mục lưu trữ ảnh và nhãn mới
outputDir = 'D:\Segmentation\uavid_v1.5_official_release_image\test_data\Labels';

% Tạo thư mục mới để lưu ảnh và nhãn đã gom
mkdir(outputDir);

% Đường dẫn đến thư mục lưu trữ ảnh và nhãn mới
outputDir = 'D:\Segmentation\uavid_v1.5_official_release_image\test_data';


% Lấy danh sách tất cả các thư mục "seq" trong thư mục gốc
seqFolders = dir(fullfile(parentDir, 'seq*'));

% Lặp qua danh sách các thư mục "sq"
for sqIndex = 1:length(seqFolders)
    sqFolderName = seqFolders(sqIndex).name; % Tên thư mục sq
    
    % Đường dẫn đến thư mục ảnh và labels trong thư mục sq hiện tại
    imagesDir = fullfile(parentDir, sqFolderName, 'Images');
    labelsDir = fullfile(parentDir, sqFolderName, 'Labels');
    
    % Đọc danh sách tất cả các tệp ảnh trong thư mục images
    imageFiles = dir(fullfile(imagesDir, '*.png')); % hoặc định dạng tệp ảnh khác
    
    % Lặp qua từng tệp ảnh và sao chép, resize vào thư mục output/Images
    for imgIndex = 1:length(imageFiles)
        imgFileName = imageFiles(imgIndex).name;
        
        % Đọc và resize ảnh
        originalImage = imread(fullfile(imagesDir, imgFileName));
        resizedImage = imresize(originalImage, 0.25);
        
        % Lưu ảnh đã resize vào thư mục output/Images với tên mới
        newImgName = sprintf('%s_%s', sqFolderName, imgFileName);
        outputImgPath = fullfile(outputDir, 'Images', newImgName);
        imwrite(resizedImage, outputImgPath);
        
        % Đường dẫn đến tệp nhãn
        labelFilePath = fullfile(labelsDir, imgFileName);
        
        % Nếu tồn tại tệp nhãn, đọc và resize nhãn
        if exist(labelFilePath, 'file')
            originalLabel = imread(labelFilePath);
            resizedLabel = imresize(originalLabel, 0.25, 'nearest'); % Sử dụng 'nearest' để giữ nguyên giá trị nhãn
            
            % Lưu nhãn đã resize vào thư mục output/Labels với tên mới
            newLabelName = sprintf('%s_%s', sqFolderName, imgFileName);
            outputLabelPath = fullfile(outputDir, 'Labels', newLabelName);
            imwrite(resizedLabel, outputLabelPath);
        end
    end
end
