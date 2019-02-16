load groundtruth.mat;
imageIDs  =unique(groundtruth(:,1));

ErrorImgs = {};

for imgs = 1:length(imageIDs)
    try
        imName = imageIDs{imgs};
        bbox = selectbbox(groundtruth,'imageID',imName);
        image = imread(imName,'jpg');
        numBox = size(bbox,1);

        CroppedImages = cell(1, numBox); 
        Tags = cell(1, numBox);
        BoundingBox = cell(1, numBox);
        
        for i = 1:numBox
           bounds = bbox{i, 3};
           x = bounds(1);        
           y = bounds(2);
           w = bounds(3) - bounds(1);
           h = bounds(4) - bounds(2);
           r = [x y w h];
           tempImg = imcrop(image, r);

           CroppedImages{i} = tempImg;
           Tags{i} = bbox{i,2};
           BoundingBox{i} = r;
        end

        imString = strcat(imName, '.mat');
        save(imString, 'CroppedImages', 'Tags', 'BoundingBox')
        
    catch ME
        err = length(ErrorImgs);        
        msgText = getReport(ME);
        ErrorImgs{err+1,1} = imString;
        ErrorImgs{err+1,2} = msgText;
    end
end
save('ErrorImgs.mat', 'ErrorImgs');
