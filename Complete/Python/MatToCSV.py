""" 
Convert .mat files to .csv
"""
from scipy.io import loadmat
import numpy as np
import csv


def unpackmat(fname, istype):
    """    
    unpackmat(filename, istype='inp')
    Returns:
        input: ndarray of ndarrays
        output: list of integers
        OGT: dict with key (string), value (integer) pairings
        
    Unpack .mat files that were created using the CollectIO.m script for the
    Visual Phrases project.
    
    Parameters
    ----------
    fname : filename / path to file.
    File should be of type .mat , created from the CollectIO.m script. In the 
    CollectIO.m script, some cells seem to be a cell containing a cell 
    containing a cell ... etc when it should instead be a cell containing an 
    int or array. Therefore this function takes that assumption and extracts
    the desired value. If there are errors related to exceeding array bounds
    check the object to see what type a data sample is.
    numpy.ndenumerate turns a matlab 'cell' -> ndarray . 
    so a triple nested cell would be an ndarray of an ndarray of an ndarray.. 
    etc.
    {{{'matlab nested cell'}}} -> ndarray[0][0]['matlab nested cell']
    
    istype : There are three types that the data can be. 
            'inp' = Input
            'out' = Output
            'ogt' = Output Ground Truth Table
    """
    
    
    def in_f():
        D = mat['TrainingInput']
        inp_v = []
        #Get input feature arrays
        for ind, val in np.ndenumerate(D):
            inp_v.append(val[0])        
        return inp_v
    
    
    def out_f():
        D = mat['TrainingOutput']
        out_v = []
        for ind, val in np.ndenumerate(D):
            out_v.append(val[0][0])         
        return out_v
    
    
    def ogt_f():
        D = mat['OGT']
        ogt_s = []
        ogt_v = []
        # extract strings and values 
        for ind, value in np.ndenumerate(D):
            if ind[1] == 0:
                ogt_s.append(value[0])
            if ind[1] == 1:
                ogt_v.append(value[0][0])
        # create dict for groundtruth table.
        ogt_dict = dict(zip(ogt_s, ogt_v))   
        return ogt_dict
    
    
    istype_list = {'inp':in_f, 'out':out_f, 'ogt':ogt_f}
    
    #load data, unpack .mat file for input/output/OGT..
    mat = loadmat(fname)
    func = istype_list.get(istype)
    data = func()
       
    return data

    
def tocsv(fname, data, istype):
    """
    tocsv(fname, data, istype='inp')
    
    Save data structure to csv file.
    IF the file to be saved exists, data will be appended to the 
    end of the file, else it will create a new file with the given name.
    
    input/output mode saves a data structure type list to a .csv file.
    Input data is assumed to be of type 1.8float
    Output data is assumed to be of type int
    OGT is assumed to be a dictionary with key, value pairings.
    
    Parameters
    ----------
    fname: csv file destination
    data: data to be saved
    istype
    There are three types that the data can take. 
            'inp' = Input
            'out' = Output
            'ogt' = Output Ground Truth Table
    """
   
    
    def in_f():
        with open(fname, 'a') as csv_file:
            np.savetxt(csv_file, data, delimiter=',', fmt='%1.8f')
        csv_file.close()
        
        
    def out_f():
        with open(fname, 'a') as csv_file:
            np.savetxt(csv_file, data, delimiter=',', fmt='%i' )
        csv_file.close()
        
    
    def ogt_f():
        with open(fname, 'a') as csv_file:
            writer = csv.writer(csv_file)
            for key, val in data.items():
                writer.writerow([key, val])
        csv_file.close()
        
    
    istype_list = {'inp':in_f, 'out':out_f, 'ogt':ogt_f}

    func = istype_list.get(istype)
    func()

