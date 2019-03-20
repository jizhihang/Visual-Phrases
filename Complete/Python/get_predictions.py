# -*- coding: utf-8 -*-
"""
Script to get predictions from Random Forest Model. 
"""
import sys
import numpy as np
import lightgbm as lgb
import MatToCSV as mtc
import get_top_n as gtn


if __name__ == '__main__':
    
    filename = sys.argv[1]
    data = mtc.unpackmat(filename, istype='inp')
    mod = lgb.Booster(model_file='modelA2.txt')
    pred = mod.predict(data)
    
    
    if len(sys.argv) == 3:
        n = int(sys.argv[2])
    else:
        n = 3
        
    top_n = gtn.getTopN(pred, n)
    top_n_val = gtn.get_top_n_values(pred, top_n)
    
    f_cat = filename[:-4]
    
    val_str = f_cat + '_top_' + str(n) + '_val.csv'
    cla_str = f_cat + '_top_' + str(n) + '_class.csv'

    np.savetxt(val_str, top_n_val, fmt='%1.8f', delimiter=',')
    np.savetxt(cla_str, top_n.astype(int), fmt='%i', delimiter=',')
