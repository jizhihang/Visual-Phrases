# -*- coding: utf-8 -*-
"""
@author briank
"""

import numpy as np
import lightgbm as lgb
from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix
from sklearn.metrics import accuracy_score

ogt_str = 'OGT.csv'
inp_str = 'TrainingInputA.csv'
out_str = 'TrainingOutputA.csv'
        
out_arr = np.loadtxt(out_str, delimiter=',',unpack=True,dtype=int)
inp_arr = np.loadtxt(inp_str, delimiter=',',dtype=float)
key_value = np.loadtxt(ogt_str, delimiter=',', dtype=str)

ogt_dic = {k:int(v) for k, v in key_value}

# split data into training, validation, and test samples.
in_train, in_S, out_train, out_S = train_test_split(
                                            inp_arr, out_arr, test_size=0.2)
in_valid, in_test, out_valid, out_test = train_test_split(
                                            in_S, out_S, test_size = 0.2)

# create lightgbm Dataset
train_data = lgb.Dataset(in_train, label=out_train)
valid_data = lgb.Dataset(in_valid, label=out_valid, reference=train_data)


numclass = ogt_dic.__len__()
param = {'num_leaves':100, 
         'num_trees':80, 
         'objective':'multiclass', 
         'metric':'multi_logloss', 
         'num_class':numclass, 
         'learning_rate':0.2}
num_round = 100

# create model
Mod = lgb.train(param, train_data, num_round, valid_sets=valid_data)
Mod.save_model('modelA2.txt')

pred = Mod.predict(in_test)

# get predicted label. 
tr_sz = pred.shape
tr_len = tr_sz[0]
pred_lab = []
incr = 0

for r in range(tr_len):
    temp = pred[r].argmax(axis=0)
    pred_lab.append(temp)
    if out_test[r] == temp:
        incr = incr + 1
     
# confusion matrix
cm = confusion_matrix(out_test, pred_lab)

# accuracy
accuracy = accuracy_score(pred_lab, out_test)
print('Model A trial 2 accuracy:', accuracy)

# Validation results..
pred2 = Mod.predict(in_valid)
v_sz = pred2.shape
vlen = pred2[0]
vlen
v_sz
vlen = v_sz[0]
pl2 = []
incr = 0
for r in range(vlen):
    temp = pred2[r].argmax(axis=0)
    pl2.append(temp)
    if out_valid[r] == temp:
        incr = incr + 1

val = accuracy_score(pl2, out_valid)
print('Model accuracy on validation set is: ', val)

