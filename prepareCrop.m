% Đường dẫn đến thư mục chứa ảnh gốc (thư mục X)
inputFolder = 'D:\Vuong\RemoteSensing\Potsdam\val\Labels';

% Đường dẫn đến thư mục chứa tấm ảnh con sau khi chia (thư mục Y)
outputFolder = 'D:\Vuong\RemoteSensing\Potsdam\temp\Labels';

% Kiểm tra xem thư mục đầu ra đã tồn tại chưa
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Đọc danh sách tất cả các tệp hình ảnh trong thư mục đầu vào
imageFiles = dir(fullfile(inputFolder, '*.png'));

% Kích thước của tấm ảnh con
subimageWidth = 2000;
subimageHeight = 2000;

% Lặp qua từng tệp hình ảnh trong thư mục đầu vào
for i = 1:length(imageFiles)
    % Đường dẫn đầy đủ đến tệp hình ảnh gốc
    imagePath = fullfile(inputFolder, imageFiles(i).name);
    
    % Đọc tấm ảnh gốc
    originalImage = imread(imagePath);
    
    % Kích thước của tấm ảnh gốc
    [originalHeight, originalWidth, ~] = size(originalImage);
    
    % Số hàng và cột tấm ảnh con
    numRows = originalHeight / subimageHeight;
    numCols = originalWidth / subimageWidth;
    
    % Chia tấm ảnh gốc thành tấm ảnh con và lưu chúng
    for j = 1:numRows
        for k = 1:numCols
            % Tạo tấm ảnh con từ tấm ảnh gốc
            subimage = originalImage(1 + (j - 1) * subimageHeight:j * subimageHeight, ...
                                     1 + (k - 1) * subimageWidth:k * subimageWidth, :);
            
            % Lưu tấm ảnh con vào thư mục đầu ra với tên tương ứng
            subimageFilename = fullfile(outputFolder, sprintf('%s_subimage_%d_%d.png', imageFiles(i).name, j, k));
            imwrite(subimage, subimageFilename);
        end
    end
end

