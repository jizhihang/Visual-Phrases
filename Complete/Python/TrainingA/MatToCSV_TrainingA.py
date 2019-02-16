#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 14 09:51:46 2019

Uses MatToCSV.py script to save .mat files from Training Run A.

@author: briank
"""

import MatToCSV as mtc

inp = 'TrainingInputA.mat'
out = 'TrainingOutputA.mat'
ogt = 'OutputGT.mat'

inp_save = 'TrainingInputA.csv'
out_save = 'TrainingOutputA.csv'
ogt_save = 'OGT.csv'

inp_D = mtc.unpackmat(inp, istype='inp')
out_D = mtc.unpackmat(out, istype='out')
ogt_D = mtc.unpackmat(ogt, istype='ogt')

mtc.tocsv(inp_save, inp_D, istype='inp')
mtc.tocsv(out_save, out_D, istype='out')
mtc.tocsv(ogt_save, ogt_D, istype='ogt')