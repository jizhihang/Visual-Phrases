function [area] = bbox_interaction(inp)
%BBOX_INTERACTION Tests overlap between bounding boxes of different classes
%   Tests if bounding boxes between two different classes overlap,
%   indicating a potential subject/object interaction. 
%   Example: If the bounding box of a person and the bounding box of a
%   horse overlap, this indicates that there may be an interaction between
%   the two. This function will then return a bounding box that contains
%   both subjects.
%   Function input should be a cell a c x 2 cell array.
%   The first column should contain a string pertaining to the class name.
%   The second column should be a cell containing an array of bounding
%   boxes for the given class. 
%   The function will return a similar data structure in which:
%   The first column contains a cell containing the string pairing of the
%   classes.
%   The second column contains a cell of the bounding boxes for each
%   pairing. 
%   
%   Usage: 
%   pairBBox = bbox_interaction(inp)
%   Example of input:
%   inp = {'person', [rect coordinates]; 'horse', [rect coordinates]}
%   The output is a cell array in which the 1st column contains the class
%   pairing and the second column contains a c1 x c2 logical array where
%   the (c1, c2) index is true if there is a bbox overlap (indicating
%   potential interaction) and a 0 if there is no overlap (subjects are not
%   in proximity)
    if numel(unique(inp(:,1))) > 1
        
        % number of possible pairings is (numClass Choose 2)
        area = cell(nchoosek(size(inp, 1), 2), 2);
        inc = 1; 
        for cur = 1:length(inp)-1
            c_bb = cell2mat(inp(cur, 2));

            for nex = 2:size(inp, 1)
               if nex <= cur
                   continue
               end
                  n_bb = cell2mat(inp(nex, 2));
                  area{inc, 1} = {inp{cur, 1}, inp{nex, 1}};

                  a = rectint(c_bb, n_bb);
                  % if overlap exists, give pairing a logic 1.
                  a = a ~= 0;
                  area{inc, 2} = a;
                  inc = inc + 1;                  
            end
        end
    else
        area = 0;
    end
    
        
end

