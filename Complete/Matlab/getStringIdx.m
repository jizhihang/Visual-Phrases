function [idx] = getStringIdx(list, str, dir)
%GETSTRINGIDX Returns index of string in a cell array.
    %Inputs:
    % list = cell array to search
    % str = string to look for.
    % dir = 0 for horizontal array, 1 for vertical array. 
    % only works for a single col or row cell array. 

    for i = 1:length(list)
        if strcmp(class(list{i}), 'char') == 0      
            try
                list{i} = char(list{i});
            catch
            end
        else
            list{i} = list{i};
        end 
    end
    
    pos = strfind(list, str);
    [i, j] = find(~cellfun(@isempty,pos));

    switch dir
        case 0
            idx = j;
        case 1
            idx = i;
    end
end

