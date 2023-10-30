% labelDir = fullfile(outputFolder, 'val', 'Images');
labelDir = 'D:\Vuong\RemoteSensing\Vaihingen\train\Labels';

% Lấy danh sách tất cả các tệp ảnh PNG trong thư mục
pngFiles = dir(fullfile(labelDir, '*.png'));

for i = 1:length(pngFiles)
    currentFileName = pngFiles(i).name;
    [~,baseFileName,~] = fileparts(currentFileName); % Lấy tên tệp không có phần mở rộng
    newFileName = strrep(baseFileName, '_noBoundary', ''); % Loại bỏ "_label_noBoundary"
    
    % Đổi tên tệp
    oldFilePath = fullfile(labelDir, currentFileName);
    newFilePath = fullfile(labelDir, [newFileName, '.png']);
    movefile(oldFilePath, newFilePath);
end
