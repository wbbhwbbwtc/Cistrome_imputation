#!/usr/bin/python

"""
predicting binding sites of the whole genome, and the best model, best premeters, and the prediction set should be determined in advance

"""
import pandas as pd
import numpy as np
import xgboost as xgb
import matplotlib as plt
import graphviz
from xgboost.sklearn import XGBClassifier
from sklearn import cross_validation, metrics   #Additional scklearn functions
from sklearn.grid_search import GridSearchCV

# Training part
dtrain = xgb.DMatrix('YY1.K562.4')
dtest = xgb.DMatrix('YY1.K562.8')
params = {'max_depth': 8, 'eta': 0.05, 'silent': 1, 'objective': 'binary:logistic', 'min_child_weight' : 2}
params['eval_metric'] = ['auc', 'error']
evallist = [(dtest, 'eval'),(dtrain, 'train')]
num_round = 50
bst = xgb.train(params, dtrain, num_round, evallist, early_stopping_rounds = 20)

# Prediction part
with open('HCT116.data2', 'r') as f:
    result = []
    while True:
        lines = f.readlines(30000000)
        if not lines:
            break
        with open('mid', 'w') as mid:
            for line in lines:
                mid.write(line)
        test = xgb.DMatrix('mid')
        ypred = bst.predict(test)
        ypred = ypred.tolist()
        result.extend(ypred)
    # Find index
    index = np.argsort(result)
    index = index.tolist()
    index_1k = index[-1000:]
    index_1w = index[-10000:]
with open('index_value','w') as q:
    for num in index:
        q.write(str(result[num]) + '\n')
# Write the file asked by toolkit
with open('test_regions.blacklistfiltered.bed', 'r') as r:
    lines = r.readlines()
with open('allpeaks95', 'w') as w:
    for i in range(len(result)):
        if result[i] >= 0.95:
            w.write(lines[i])
with open('allpeaks90', 'w') as w:
    for i in range(len(result)):
        if result[i] >= 0.9:
            w.write(lines[i])
#with open('pred_peaks_1k.bed', 'w') as w:    
#    for num in index_1k:
#        w.write(lines[num])
#with open('pred_peaks_1w.bed', 'w') as w:    
#    for num in index_1w:
#        w.write(lines[num])




