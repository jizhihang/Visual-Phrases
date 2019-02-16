cd G:\Documents\Visual_Phrases_Project
files = dir('CroppedImages');

% Change to directory containing matconvnet.
cd G:\Documents\Visual_Phrases_Project\matconvnet-1.0-beta25;

% Setup MatConvNet.
run matlab/vl_setupnn;

% Load a model and upgrade it to MatConvNet current version.
net = dagnn.DagNN.loadobj(load('imagenet-resnet-50-dag.mat'));
net.mode = 'normal';
net.vars(net.getVarIndex('pool5')).precious = 1;

    tF = numel(files);
    for f = 1:tF
        try           
        file = files(f);
        
        % Change to directory containing matconvnet
        cd G:\Documents\Visual_Phrases_Project\matconvnet-1.0-beta25;
        
        % Don't want to work on generated error mats or directories.
        if ~strcmp(file.name, 'ErrorImgs.mat') && file.isdir == 0
            load(file.name);
            numImgs = length(CroppedImages);
            Features = cell(1,numImgs);
            
            % For each cropped image, pass cropped image through net and
            % get value.
            for n = 1:numImgs
                
                im = CroppedImages{n};
                im_ = single(im);
                im_ = imresize(im_, net.meta.normalization.imageSize(1:2));
                im_ = bsxfun(@minus, im_, ...
                    net.meta.normalization.averageImage);
                
                net.eval({'data', im_});                
                Features{n} = squeeze(...
                net.vars(net.getVarIndex('pool5')).value);                
            end
            % overwrite files in CroppedImages directory.
            cd G:\Documents\Visual_Phrases_Project\CroppedImages
            save(file.name, 'CroppedImages', 'BoundingBox', 'Tags', ...
                'Features');
        end
        
        catch ME
            
        err = length(ErrorImgs);        
        msgText = getReport(ME);
        ErrorImgs{err+1,1} = imString;
        ErrorImgs{err+1,2} = msgText;
            
        end
    end
    save('ErrorImgsFeatureExtract.mat', 'ErrorImgs');
