% Đường dẫn đến thư mục chứa ảnh
imageDirectory = 'D:\Vuong\RemoteSensing\Postdam\train\Labels';

% Kích thước mục tiêu
targetWidth = 3000;
targetHeight = 3000;

% Lấy danh sách tập tin ảnh trong thư mục
fileList = dir(fullfile(imageDirectory, '*.png')); % Thay đổi định dạng ảnh nếu cần

for i = 1:length(fileList)
    % Đường dẫn đầy đủ đến tập tin ảnh
    imagePath = fullfile(imageDirectory, fileList(i).name);
    
    % Đọc ảnh từ đường dẫn
    image = imread(imagePath);
    
    % Resize ảnh về kích thước mục tiêu
    resizedImage = imresize(image, [targetHeight, targetWidth]);
    
    % Ghi ảnh đã resize lên đè lên tập tin ảnh gốc
    imwrite(resizedImage, imagePath);
end

disp('Hoàn thành việc resize và thay thế ảnh cũ.');
