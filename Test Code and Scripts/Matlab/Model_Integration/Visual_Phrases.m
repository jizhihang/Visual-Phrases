function Visual_Phrases()
%VISUAL_PHRASES Summary of this function goes here
%   Detailed explanation goes here
tic
% NN parameters
opts.gpus = [] ;
%opts.gpus = 1;
opts.modelPath = '' ;
opts.roiVar = 'rois' ;
opts.scale = 600 ;
opts.nmsThresh = 0.3 ;
opts.confThresh = 0.8 ;
opts.maxScale = 1000 ;
opts.wrapper = 'dagnn' ;
% Directory with images.
files = dir('G:\Documents\Visual_Phrases_Project_DATA\Test\Images');

classes = {'background', 'aeroplane', 'bicycle', 'bird', ...
 'boat', 'bottle', 'bus', 'car', 'cat', 'chair', 'cow', 'diningtable', ...
 'dog', 'horse', 'motorbike', 'person', 'pottedplant', 'sheep', ...
 'sofa', 'train', 'tvmonitor'} ;

% load networks rcnn for bbox detection, resnet for feature extraction
net = dagnn.DagNN.loadobj(load('faster-rcnn-vggvd-pascal.mat'));
net.mode = 'test';
imnet = dagnn.DagNN.loadobj(load('imagenet-resnet-50-dag.mat'));
imnet.mode = 'normal';
imnet.vars(imnet.getVarIndex('pool5')).precious = 1;

Input = {};
Tags = {};
IOError = {};
PairBounds = {};

f = numel(files);
for imgs = 1:f
    try
        bx = [];
        file = files(imgs);
        filename = file.name;
        if file.isdir == 0
            
            image = imread(filename);
            im = single(image);

            % choose variables to track if using dagnn
            if strcmp(opts.wrapper, 'dagnn')
                clsIdx = net.getVarIndex('cls_prob') ;
                bboxIdx = net.getVarIndex('bbox_pred') ;
                roisIdx = net.getVarIndex(opts.roiVar) ;
                [net.vars([clsIdx bboxIdx roisIdx]).precious] = deal(true) ;
            end
            % resize to meet the faster-rcnn size criteria
            imsz = [size(im,1) size(im,2)] ; maxSc = opts.maxScale ; 
            factor = max(opts.scale ./ imsz) ; 
            if any((imsz * factor) > maxSc), factor = min(maxSc ./ imsz) ; end
            newSz = factor .* imsz ; imInfo = [ round(newSz) factor ] ;

            % resize and subtract mean
            data = imresize(im, factor, 'bilinear') ; 
            data = bsxfun(@minus, data, net.meta.normalization.averageImage) ;

            % set inputs
            sample = {'data', data, 'im_info', imInfo} ;
            net.meta.classes.name = classes ;
            %% Get Bounding Boxes for subjects of interest (classes)
            % run network and retrieve results
            net.eval(sample) ;
            probs = squeeze(net.vars(clsIdx).value) ;
            deltas = squeeze(net.vars(bboxIdx).value) ;
            boxes = net.vars(roisIdx).value(2:end,:)' / imInfo(3) ;

            for i = 2:numel(classes)
                c = find(strcmp(classes{i}, net.meta.classes.name)) ;
                cprobs = probs(c,:) ;
                cdeltas = deltas(4*(c-1)+(1:4),:)' ;

                cboxes = bbox_transform_inv(boxes, cdeltas);
                cls_dets = [cboxes cprobs'] ;

                keep = bbox_nms(cls_dets, opts.nmsThresh) ;
                cls_dets = cls_dets(keep, :) ;

                sel_boxes = find(cls_dets(:,end) >= opts.confThresh) ;
                if numel(sel_boxes) == 0, continue ; end

                %{
                bbox_draw(im/255,cls_dets(sel_boxes,:));
                title(sprintf('Dets for class ''%s''', classes{i})) ;
                if exist('zs_dispFig', 'file'), zs_dispFig ; end

                fprintf('Detections for category ''%s'':\n', classes{i});
                %}
                for j=1:size(sel_boxes,1)
                  bbox_id = sel_boxes(j,1);
                  %{
                  fprintf('\t(%.1f,%.1f)\t(%.1f,%.1f)\tprobability=%.6f\n', ...
                          cls_dets(bbox_id,1), cls_dets(bbox_id,2), ...
                          cls_dets(bbox_id,3), cls_dets(bbox_id,4), ...
                          cls_dets(bbox_id,end));
                  %}
                  % contains bounding box coordinates for OG images.
                  % first col is the class index, followed by xmin, ymin, xmax, ymax.
                  bx = [bx;i cls_dets(bbox_id,1) cls_dets(bbox_id,2) ...
                      cls_dets(bbox_id,3) cls_dets(bbox_id,4)];

                end

            end
            %% Reformat Bounding Boxes
            % format bounding boxes for bb_to_rect()
            if isempty(bx)
                continue
            end
            [~,~, u_cla] = unique(bx(:,1));
            u_cc = unique(bx(:,1));
            for i = 1:length(u_cc)
               bb_s{i,1} = classes{u_cc(i)}; 
            end
            bb_s1 = accumarray(u_cla, 1:size(bx,1),[],@(r){bx(r,(2:5))});
            bb_f = [bb_s bb_s1];
            bb_r = bb_to_rect(bb_f);

            % find overlap candidates between all subjects in image.
            intersections = bbox_interaction(bb_r);
            % get crop bounding boxes in format for feature extraction.
            crop_bounds = get_bounds(intersections, bb_f, bx, classes);

            % get pontential pair bounding box candidates.
            pair_bounds = predict_crops(intersections, bb_f);

            %% Extract Features from Cropped Images, format for LightGBM model
            % Extract features and format for model.
            [F, T] = extract_features(imnet, image, crop_bounds);
            if ~isempty(F)
                Input = [Input; F];
                Tags = [Tags; T];
            end
            if iscell(pair_bounds)
                PairBounds = [PairBounds; pair_bounds];
            end
            clearvars -except Features Tags IOError imnet net ... 
                classes opts f imgs files PairBounds; 
        end
     
    catch ME
         err = length(IOError); 
         IOError{err+1,1} = filename;
         msgText = getReport(ME);
         IOError{err+1,2} = msgText;
    end
       
end
fprintf('All files took:');
toc
%% Save
% Remove blanks.
Tags = Tags(~cellfun('isempty', Tags));
Input = Input(~cellfun('isempty', Input));
cd G:\Documents\Visual_Phrases_Project_DATA\Test\Data;
save('Features.mat', 'Features');
save('Tags.mat', 'Tags');
save('ErrorImgs.mat', 'IOError');
save('PairBounds.mat', 'PairBounds');
end

