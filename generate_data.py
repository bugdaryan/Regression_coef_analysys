import numpy as np
from scipy.linalg import eigh, cholesky
from scipy.stats import norm
import pandas as pd
import os

num_samples = 3000

r = np.array([
        [  3.40, -2.75, -2.00],
        [ -2.75,  5.50,  1.50],
        [ -2.00,  1.50,  1.25]
    ])

x = norm.rvs(size=(3, num_samples))

evals, evecs = eigh(r)
c = np.dot(evecs, np.diag(np.sqrt(evals)))

y = np.dot(c, x)

df1 = pd.DataFrame({'X':y[0], 'Y':y[1]})
df2 = pd.DataFrame({'X':y[1], 'Y':y[2]})
df3 = pd.DataFrame({'X':y[0], 'Y':y[2]})

data_folder = 'data'

if not os.path.exists(data_folder):
    os.makedirs(data_folder)

df1.to_csv(os.path.join(data_folder,'1.csv'))
df2.to_csv(os.path.join(data_folder,'2.csv'))
df3.to_csv(os.path.join(data_folder,'3.csv'))