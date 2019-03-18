function [crop_bounds] = get_bounds(intersections, bb_f, bx, classes)
%GET_BOUNDS Get bounding boxes for inputs samples.
%   Get bounding box candidates and format into an n x 2 cell array.
%   First column is a cell array containing the class tag pairings. If the
%   sample is a single subject, the second tag will be a 0. In the case of
%   pairings, the subject/object relationship is not identified, ie, the
%   class in the first position is not necessarily the subject of the
%   relationship, nor is the class in the second position necessarily the object
%   of the relationship.
bbx = bb_f;
crop_bounds = {};
singles = cell(size(bx,1), 2);
% Get bounding boxes for all individual candidates
for i = 1:size(bx,1)
    singles{i, 1} = {classes(bx(i,1)), 0};
    singles{i, 2} = {bx(i,(2:5)), 0};
end
if iscell(intersections) 
    % for all pairings, if it exists..
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
        % get bounding boxes for each pair.
        for j = 1:length(r)
           temp{j, 1} = intersections{i,1};
           bb_c1 = bbx{p1, 2}(r(j),:);
           bb_c2 = bbx{p2, 2}(c(j),:); 
           temp{j, 2} = {bb_c1, bb_c2};
        end
        crop_bounds = [crop_bounds; temp];   
    end
end
crop_bounds = [crop_bounds; singles];

end

