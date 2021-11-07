from pyfmi import load_fmu
from pyfmi.master import Master
import numpy as np
import numpy.random as random
import pandas as pd
import random
pvpanels_dir = r"C:\Users\10178\Documents\Dymola\TEES_PVPanels.fmu"
pvpanels = load_fmu(pvpanels_dir)
options = pvpanels.simulate_options()
options['ncp'] = 500.
# inputs/outputs
input_names = list(pvpanels.get_model_variables(causality=2).keys())
output_names = list(pvpanels.get_model_variables(causality=3).keys())
print(input_names, output_names)
time_stop = 365 * 24 * 3600
ts = 0
te = ts + time_stop
time_arr = np.arange(ts, te)
y = np.ones(time_arr.shape) * 0.5
input_trac = np.transpose(np.vstack((time_arr.flatten(), y.flatten())))
input_object = (input_names, input_trac)
res = pvpanels.simulate(start_time=ts,
                        final_time=te,
                        options=options,
                        input=input_object)
power = res['power']
power_df = pd.DataFrame({'power': np.array(power)})
power_df.to_excel(r"D:\Docu\power_python.xlsx")

