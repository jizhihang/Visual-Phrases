function [crop_bounds] = predict_crops(intersections, bbx)
%PREDICT_CROPS Returns candidate cropped image boundary rectangle.
%   Based on intersection candidates and bounds, the function returns the
%   cropped image boundaries for each pair.
%   Return is a 2 column matrix in the format of:
%   subject pair , bounding rectangle 
%   Bounding rectangle: [xmin ymin width height]
% If no intersections exit.
if isnumeric(intersections)
    crop_bounds = 0;
   return 
end

crop_bounds = {};
% for all pairings,
for i = 1:size(intersections, 1)
    % current classes in pairing.
    c1 = intersections{i,1}{1,1};
    c2 = intersections{i,1}{1,2};

    % index of class 
    p1 = find(strcmp(bbx, c1));
    p2 = find(strcmp(bbx, c2));
    % preallocate matrix for cropped images for the pairing.
    num_inters = nnz(intersections{i,2});    
    temp = cell(num_inters, 2);

    [r,c] = find(intersections{1,2});

    for j = 1:length(r)
       temp{j, 1} = intersections{i,1};
       xmin = min(bbx{p1, 2}(r(j), 1), bbx{p2, 2}(c(j), 1));
       ymin = min(bbx{p1, 2}(r(j), 2), bbx{p2, 2}(c(j), 2));
       xmax = max(bbx{p1, 2}(r(j), 3), bbx{p2, 2}(c(j), 3));        
       ymax = max(bbx{p1, 2}(r(j), 4), bbx{p2, 2}(c(j), 4));
       w = xmax - xmin;
       h = ymax - ymin;
       temp{j, 2} = [xmin ymin w h];
    end
    crop_bounds = [crop_bounds; temp];   
end
end

