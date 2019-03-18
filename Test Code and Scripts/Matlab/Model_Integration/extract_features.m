function [Features,Tags] = extract_features(net, image, crop_bounds)
%EXTRACT_FEATURES Extract Features and format for lightgbm model.
%   Returns tags list and features. Features are 1x4096 vectors. 
nn = net;
im = image;
cr_b = crop_bounds;


sz = size(cr_b,1);
Features = cell(2*sz, 1);
Tags = cell(2*sz, 1);
for i = 1:sz
    % Resize image, reformat to work with NN.
    if isempty(cr_b{i,1})
        continue
    end
        
    temp_b1 = cell2mat(cr_b{i,2}(1));
    temp_b2 = cell2mat(cr_b{i,2}(2));

    if temp_b1 == 0
        f1 = zeros(1, 2048);
    else
        temp_im1 = single(imcrop(im, temp_b1));
        temp_im1 = imresize(temp_im1, nn.meta.normalization.imageSize(1:2));
        temp_im1 = bsxfun(@minus, temp_im1, ...
            nn.meta.normalization.averageImage);
        nn.eval({'data', temp_im1});
        f1 = squeeze(...
        nn.vars(nn.getVarIndex('pool5')).value);
        f1 = f1';
    end

    if temp_b2 == 0
        f2 = zeros(1, 2048);
    else
        temp_im2 = single(imcrop(im, temp_b2));
        temp_im2 = imresize(temp_im2, nn.meta.normalization.imageSize(1:2));
        temp_im2 = bsxfun(@minus, temp_im2, ...
            nn.meta.normalization.averageImage);
        nn.eval({'data', temp_im1});
        f2 = squeeze(...
        nn.vars(nn.getVarIndex('pool5')).value);
        f2 = f2';
    end
    
    Tags{2*i - 1, 1} = cr_b{i, 1};
    t1 = cr_b{i, 1};
    Tags{2*i, 1} = {t1{2} t1{1}};
    Features{2*i - 1, 1} = [f1 f2];
    Features{2*i, 1} = [f2 f1];

end
end

