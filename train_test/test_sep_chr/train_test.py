import pandas as pd
import numpy as np
import xgboost as xgb

with open("STAT3.HeLa-S3.set2",'r') as r1:
    lines1 = r1.readlines()

with open("STAT3.MCF-10A.set2",'r') as r3:
    lines3 = r3.readlines()
with open("STAT3.MD.set2",'r') as r4:
    lines4 = r4.readlines()
with open('all_sample_fortrain','w') as w:
    for i in range(int(len(lines1)/2)):
        w.write(lines1[i])

    for i in range(int(len(lines3)/2),len(lines3)):
        w.write(lines3[i])
    for i in range(int(len(lines4)/2),len(lines4)):
        w.write(lines4[i])
with open('all_sample_fortest','w') as w:
    for i in range(int(len(lines3)/2)):
        w.write(lines3[i])
    for i in range(int(len(lines4)/2)):
        w.write(lines4[i])
    for i in range(int(len(lines1)/2),len(lines1)):
        w.write(lines1[i])


dtrain = xgb.DMatrix('all_sample_fortrain')
dtest = xgb.DMatrix('all_sample_fortest')
params = {'max_depth': 8, 'eta': 0.1, 'silent': 1, 'objective': 'binary:logistic', 'min_child_weight' : 2}
params['nthread'] = 4
params['eval_metric'] = ['auc']
evallist = [(dtest, 'eval'), (dtrain, 'train')]
num_round = 100
bst = xgb.train(params, dtrain, num_round, evallist, early_stopping_rounds = 10)
test = xgb.DMatrix('pre')
ypred = bst.predict(test)
score = ypred.tolist()
c = pd.DataFrame({"label" : labels,
   "score" : score})
c.to_csv("ress.csv",index=False,sep=',')