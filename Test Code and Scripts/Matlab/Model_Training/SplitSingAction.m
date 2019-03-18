%{ 
    If the file contains a single tag with a target+predicate combination,
this script will create a new entry within the file to include the target.
IE:
File contains tag that is only: person_jumping
create a new tag + croppedImage + boundingbox combination that is:
person with the same bounds.
%}
cd G:\Documents\Visual_Phrases_Project\
files = dir('CroppedImages');
load Phrases.mat;
cd G:\Documents\Visual_Phrases_Project\Copy_of_CroppedImages\
% number of tags in sample. 
tagSize = 0;

  tF = numel(files);
    for f = 1:tF
        try
        file = files(f);
        % Don't want to work on generated error mats or directories.
        if ~any(strcmp(file.name, 'ErrorImgs.mat')) && file.isdir == 0
            load(file.name);
            tagSize = length(Tags);
            if tagSize == 1
                words = strsplit(Tags{1}, '_');
                if words > 1
                    for word = words'
                        if any(strcmp(word, phrases))
                            Tags{2} = Tags{1}; 
                            BoundingBox{2} = Tags{1};
                            CroppedImages{2} = CroppedImages{1};
                            
                            save(file.name, 'Tags', 'BoundingBox', 'CroppedImages');
                        end
                    end
                end
            end                       
        end
        
        catch
            
        end
    end