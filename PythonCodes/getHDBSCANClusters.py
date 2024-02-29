# -*- coding: utf-8 -*-
#------------------------------------------------------------------------------
import scipy.io
import re
import seaborn as sns
import numpy as np
import pandas as pd
import sys
import os
import h5py

from matplotlib import pyplot as plt, rcParams

# from matplotlib_inline.backend_inline import set_matplotlib_formats

rcParams['figure.figsize'] = (8,5)
rcParams['figure.dpi'] = 100
# set_matplotlib_formats('retina')
plt.style.use('seaborn')

# These are the implementations we'll be using so we don't have to code it ourselves
from sklearn.cluster import HDBSCAN


#-----------------------------------------------------------------------------
# OPTICS implementation
def HDBSCANimplementation(filename,path):
    
    try:
        # filename = 'EnsembleKSMatrix_1k_109_45200_45800_NumConc_70%_0-P_1-F_1.2_N.mat'
        data = scipy.io.loadmat(path + filename)['ensmblKSMatrixCondConc'][:, :]
    except NotImplementedError:
        mat_file = h5py.File(path + filename, 'r')
        variable = mat_file['ensmblKSMatrixCondConc']
        data = variable[()]
        mat_file.close()
        
    # Fill the diagonal with zeros since each distribution perfectly matches itself (obviously)
    np.fill_diagonal(data, 0)
    
    # Fill missing values with 1 to assume no similarity (there is probably a better way to fill the missing values...)
    data[np.isnan(data)] = 1
    data[data>1] = 1
    
    # sns.heatmap(data, cmap='viridis', square=True)
    # plt.title('Distribution Similarity')
    # plt.show()
    
    #------------------------------------------------------------------------------
    
    # HDBSCAN Implementation
    
    # This just says to calculate the distance between point x and point y, just use element (x,y) in our data matrix
    metric = lambda x, y: data[int(x[0]), int(y[0])]
    
    # We reshape to make into a column vector
    ids = np.arange(data.shape[1]).reshape(-1, 1)
    
    # round(data.shape[1]/2)
    params = list(range(10, 100))#max(round(data.shape[1]/4),150)))
    tmp = []
    for x in params:
        hdbscan = HDBSCAN(min_cluster_size=x, metric=metric)
        labels = hdbscan.fit_predict(ids)
        tmp.append(np.unique(labels).size - 1)
        saveTag = path + 'HDBSCANResults/cluster_minP_' + str(x) + '.mat'
        scipy.io.savemat(saveTag,{'clusterInfo':labels,'minPoints':x},)
        # scipy.io.savemat('clusterVsMinPoints_OPTICS.mat',{'minPoints':params,'clusterCounts':tmp},)
        # print(x,tmp[-1])
    # print(tmp)
    # optmMinPointsInd = tmp.index(max(tmp))
    # optmMinPoints = params[optmMinPointsInd]
    
    #pattern = "EnsembleKSMatrix_1k(.*)_NumConc"
    #filetag = re.search(pattern, filename).group(1)
    
    filetag = filename[:]
    saveTag = path + 'OPTICSResults/clusterVsMinPoints_OPTICS' + filetag + '.mat'

    
    # saveTag = os.path.join(path,saveTag)
    scipy.io.savemat(saveTag,{'minPoints':params,'clusterCounts':tmp},)
    
    #------------------------------------------------------------------------------
    
    # Finding the value of the combination that maximizes the number of clusters
    i=0
    optmMinPointsInd=[]
    
    maxVal = max(tmp)
    
    for val in tmp:
        if val == maxVal:
            optmMinPointsInd.append(i)
        i = i + 1
    
    
    if maxVal ==1:
        optmMinPointsInd = optmMinPointsInd[0]
    else:
        optmMinPointsInd = optmMinPointsInd[-1]
    
    
    optmMinPoints = params[optmMinPointsInd]
    print('Segment: ', filetag[1:])
    print('Max # of clusters: ',  maxVal)
    print('Optimal Min Points: ',optmMinPoints)
    #-----------------------------------------------------------------------------
    
    # Running HDBSCAN again with the optimized parameters
    hdbscan = HDBSCAN(min_cluster_size=optmMinPoints, metric=metric)
    labels = hdbscan.fit_predict(ids)
    
    print(f"Verification number of clusters for optimal minpoints: {np.unique(labels).size - 1}")
    
    saveTag = path +'HDBSCANResults/cluster_HDBSCAN' + filetag + '.mat'
    # saveTag = os.path.join(path,saveTag)
    scipy.io.savemat(saveTag,{'clusterInfo':labels,'eps':np.inf,'minPoints':optmMinPoints},)
    
    
    
    
#------------------------------------------------------------------------------

path = sys.argv[1]
filename = sys.argv[2]
if os.path.isdir(os.path.join(path,'OPTICSResults')) is False :
    os.mkdir(os.path.join(path,'OPTICSResults'))
HDBSCANimplementation(filename,path)
