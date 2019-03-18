function [CropImgs] = crop_image(crops, image)
%CROP_IMAGE Get cropped images from the given crop bounds.
%   Return row-wise cell array in the following format:
% {{class pair}, [xmin ymin width height]}

sz = size(crops, 1);

CropImgs = cell(sz, 2);

for i = 1:sz
   CropImgs{i, 1} = crops{i, 1};
   CropImgs{i, 2} = imcrop(image, crops{i,2});    
end

end

