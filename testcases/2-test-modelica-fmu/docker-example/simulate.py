# -*- coding: utf-8 -*-
"""
this script is to test the simulation of compiled fmu
@ Yangyang Fu, yangyang@passivelogic.com
"""
# import numerical package
import numpy as np
import matplotlib
matplotlib.use('agg')
import matplotlib.pyplot as plt
# import fmu package
from pyfmi import load_fmu

## load fmu - cs
fmu_name = "test"
fmu = load_fmu(fmu_name+'.fmu')
fmu.set_log_level(0) # log level 0-7
options = fmu.simulate_options()
options['ncp'] = 500

# simualte 
res = fmu.simulate(start_time=0, final_time=10, options=options)
t = np.array(res['time'])
x = np.array(res['x'])

# plot
plt.figure()
plt.plot(t, x, 'b-')
plt.ylabel('x')
plt.xlabel('t')
plt.savefig(fmu_name+'.pdf')

# clean folder after simulation
def deleteFiles(fileList):
    """ Deletes the output files of the simulator.
    :param fileList: List of files to be deleted.
    """
    import os

    for fil in fileList:
        try:
            if os.path.exists(fil):
                os.remove(fil)
        except OSError as e:
            print ("Failed to delete '" + fil + "' : " + e.strerror)
        
filelist = [fmu_name+'_result.mat',fmu_name+'_log.txt']
deleteFiles(filelist)