function [out] = bboxComp(bbo, bbi)
%BBOXCOMP Test whether a bounding box bbi is within bounding box bbo.
%   If the 'inner' bounding box is within the bounds of the 'outer'
%   bounding box, the function will return 1, else 0.
%   Bounding boxes should be an array in the format of 
%   [xmin, ymin, xmax, ymax]
%   Due to possible cropping differences, this function increases the
%   bounds of the outer by 10%. 
%% 
    if .9*bbo(1) < bbi(1) && .9*bbo(2) < bbi(2) && 1.1*bbo(3) > bbi(3) ...
       && 1.1*bbo(4) > bbi(4)
        
        out = 1;
    else
        out = 0;
    end
end

