from netCDF4 import Dataset
import numpy as np
import glob,os

cwd = os.getcwd()

yearly_mean = np.zeros((1,601,1440))

k = 0
for year in range(2010,2011):

    j = 0
    year_matrix = np.zeros((12,601,1440))

    for month in range(1,13):

        dir = cwd+'/'+str(year)+'/utci-'+str(year)+'-'+str(month)
        print(dir)
        os.chdir(dir)
        files = glob.glob("*.nc")
        number_files = len(files)
        month_matrix = np.zeros((number_files, 601, 1440))

        i = 0
        for file in files:
            f = Dataset(file)
            month_matrix[i]  += np.mean(f.variables['utci'], axis=0)
            i += 1
        
        year_matrix[j] += np.mean(month_matrix, axis=0)
        j += 1
    
    yearly_mean[k] += np.mean(year_matrix,axis=0)
    k += 1

np.save(cwd+'/yearly_mean.npy',yearly_mean)

        