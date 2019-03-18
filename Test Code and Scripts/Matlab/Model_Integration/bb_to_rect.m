function [rects] = bb_to_rect(C)
%BB_TO_RECT Turns bbox coordinates to rectangle coordinates.
%   Turns coordinates: xmin, ymin, xmax, ymax 
%   into xmin, ymin, width, height
%   Input should be a row-wise cell array in the format of:
%   class, {[array of bounding boxes]}
%   Output is a cell array of: string double array
%   where the string is the class and the double array contains the rect
%   coordinates.
    Classes = C;
    rects = C;
    for bb = 1:size(Classes, 1)
        c_bbs = Classes{bb, 2};
        mins = [c_bbs(:,1) c_bbs(:,2)];
        maxs = [c_bbs(:,3) c_bbs(:,4)];
        diff = maxs - mins;
        bb_n = [mins diff];

        rects{bb,2} = bb_n;
    end
end

