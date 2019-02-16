
cd G:\Documents\Visual_Phrases_Project\
files = dir('CroppedImages');
cd G:\Documents\Visual_Phrases_Project\CroppedImages
f = numel(files);

for imgs = 1:f
    try
        file = files(imgs);
        filename = file.name;
        
        if (~strcmp(filename, 'ErrorImgs.mat') && file.isdir == 0)
            load(filename);
            load Phrases.mat;

            NumTags = length(Tags);
            if NumTags == 1
               words = strsplit(Tags{1}, '_'); 
              if any(strcmp(words(1), phrases))
                    Tags{2} = words(1);
                    CroppedImages{2} = CroppedImages{1};
                    BoundingBox{2} = BoundingBox{1};
                    save(filename, 'Tags', 'CroppedImages', 'BoundingBox');
              end
            end
        end
    catch
        % Whoops.. error...
    end
end