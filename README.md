# Visual-Phrases

The goal of this project is to train a classifier to identify visual phrases, or subject-action-(object)(*optional) relationships in an image.

The Dataset used is from the Recognition using Visual Phrases team at the University of Illinois at Urbana-Champaign : vision.cs.uiuc.edu/phrasal

The data extraction, formatting etc was done using Matlab. The Matlab code can be found in /Complete/Matlab/
The rest of this project will be completed using Python. 

___
This project will attempt to classify these visual phrases by training a model based 
on extracted feature vectors of images from the pooling layer of a convolutional neural network.

LightGBM will be used to create the classification model for this project.
___
This project is currently a work in progress.

Update: 2/16/19 - First Model Trained. 67% accuracy on test dataset.

___

Current To-do list: 
- Modify model parameters and test performance. 
- Remove prepositions in phrase if there are many errors due to this. 
	Clone dataset with modified phrase and train new model.
