import numpy as np

"""
Example after getting predictions from model and saving to csv file 
called test_prediction.csv.

pred = np.genfromtxt('test_prediction.csv', delimiter=',')

top_3 = getTopN(pred, 3)

top_3_val = get_top_n_values(pred, top_3)

** 
Generally, the top N should be sorted in ascending order. However, there is an
issue where the values are not correctly sorted.
Ex of issue: sorts 0.0918 as greater than 0.9061
"""
def getTopN(pred, n):
    top_n = [np.argpartition(row, -n)[-n:] for row in pred]
    return top_n


def get_top_n_values(pred, top_n):
    sz = top_n.shape
    top_n_val = np.empty(sz)
    
    for i in range(sz[0]):
        top_n_val[i] = pred[i][top_n[i]]
    
    return top_n_val

