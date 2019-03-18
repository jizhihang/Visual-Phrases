function [interactions] = predict_interactions(vargargin)
%PREDICT_INTERACTIONS Predicts potential interactions between subjects
%in image.
%   This function predicts potential interactions between subjects in an
%   image if there is an overlap between the bounding boxes of the
%   subjects. If there is an overlap, the new bounding box is that which
%   contains both subjects.
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
opts.imPath = '3000_000022.jpg';

bx = [];
classes = {'background', 'aeroplane', 'bicycle', 'bird', ...
 'boat', 'bottle', 'bus', 'car', 'cat', 'chair', 'cow', 'diningtable', ...
 'dog', 'horse', 'motorbike', 'person', 'pottedplant', 'sheep', ...
 'sofa', 'train', 'tvmonitor'} ;





end

