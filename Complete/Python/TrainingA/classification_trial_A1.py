#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 14 10:19:24 2019

@author: briank
"""

import numpy as np
import lightgbm as lgb

ogt_str = 'OGT.csv'
inp_str = 'TrainingInputA.csv'
out_str = 'TrainingOutputA.csv'
        
out_arr = np.loadtxt(out_str, delimiter=',',unpack=True,dtype=int)
inp_arr = np.loadtxt(inp_str, delimiter=',',dtype=float)
key_value = np.loadtxt(ogt_str, delimiter=',', dtype=str)

ogt_dic = {k:int(v) for k, v in key_value}

# bounds for training, validation, and test sets.
sz = out_arr.size
tr_bnd = [0, 6000]
va_bnd = [tr_bnd[1], sz-100]
te_bnd = [sz-100, sz]

tr_inp = inp_arr[tr_bnd[0]:tr_bnd[1]]
tr_out = out_arr[tr_bnd[0]:tr_bnd[1]]

va_inp = inp_arr[va_bnd[0]:va_bnd[1]]
va_out = out_arr[va_bnd[0]:va_bnd[1]]

te_inp = inp_arr[te_bnd[0]:te_bnd[1]]
te_out = out_arr[te_bnd[0]:te_bnd[1]]

# create lightgbm data
train_data = lgb.Dataset(tr_inp, label=tr_out)
valid_data = lgb.Dataset(va_inp, label=va_out, reference=train_data)

numclass = ogt_dic.__len__()

param = {'num_leaves':31, 'num_trees':100, 'objective':'multiclass', 
         'metric':'multi_logloss', 'num_class':numclass}

num_round = 10
modA = lgb.train(param, train_data, num_round, valid_sets=[valid_data])

modA.save_model('model.txt')
pred = modA.predict(te_inp)
print(pred)

tr_sz = pred.shape
tr_len = tr_sz[0]
pred_lab = []
incr = 0

for r in range(tr_len):
    temp = pred[r].argmax(axis=0)
    pred_lab.append(temp)
    if te_out[r] == temp:
        incr = incr + 1
        
model_acc = incr / tr_len
print('Model Accuracy on Test set is: ', model_acc)
