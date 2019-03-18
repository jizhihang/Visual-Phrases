import numpy as np

def getTopN(pred, n):
    sz = pred.shape
    l = sz[0]
    top_n = np.empty((l, n))

    for i in range(l):
        top_n[i] = np.argpartition(pred[i], -n)[-n:]
    top_n = top_n.astype(int)
    return top_n


def get_top_n_values(pred, top_n):
    sz = top_n.shape
    top_n_val = np.empty(sz)
    
    for i in range(sz[0]):
        top_n_val[i] = pred[i][top_n[i]]
    
    return top_n_val

"""
Example after getting predictions from model and saving to csv file 
called test_prediction.csv.

pred = np.genfromtxt('test_prediction.csv', delimiter=',')

top_3 = getTopN(pred, 3)

top_3_val = get_top_n_values(pred, top_3)

"""