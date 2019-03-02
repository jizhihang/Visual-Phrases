# Visual-Phrases

The goal of this project is to train a classifier to identify visual phrases, or subject-action-(object)(*optional) relationships in an image.

The Dataset used is from the Recognition using Visual Phrases team at the University of Illinois at Urbana-Champaign : vision.cs.uiuc.edu/phrasal

The data extraction, formatting etc was done using Matlab. The Matlab code can be found in /Complete/Matlab/
This project will use both Matlab and Python. Completed code can be found in the /Complete/ section.  

___
This project will attempt to classify these visual phrases by training a model based 
on extracted feature vectors of images from the pooling layer of a convolutional neural network.

The feature vectors are extracted from MatConvNet.
LightGBM's Random Forest multi-class classifier is used to create the classification model for this project.
___
This project is currently a work in progress.

Update: 2/16/19 - First Model Trained. 67% top-1 accuracy on test dataset.

___

To-do list: 
	Roadmap:
	- Implement Object detection network to find objects of interest and its location instead of using ground-truth boxes.
	- Evaluate detection using mAP (mean average precision) 
	- Implement top-n accuracy for model. 
	- Consolidate system to:
		1) take an image
		2) detect subject + action (bounding box) 
		3) predict potential phrases (actions) for each bounding box
		4) superimpose bounding boxes with phrase on image

