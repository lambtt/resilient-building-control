from pyfmi import load_fmu
from pyfmi.master import Master
import numpy as np
import numpy.random as random
import pandas as pd
import random
eplus_dir = r"D:\EnergyPlusV9-5-0\EnergyPlusToFMU-v3.1.0\Scripts\win\US_SF_CZ3A_hp_slab_IECC_2021.fmu"
eplus = load_fmu(fmu = eplus_dir, log_level = 7)
eplus_output_names = list(eplus.get_model_variables(causality=3).keys())
print("*****energyplus_output*****", eplus_output_names)
pv_battery_dir = r"C:\Users\10178\Documents\Dymola\TEES_PV_Battery.fmu"
pv_battery = load_fmu(pv_battery_dir, log_level = 7)
pv_battery_input_names = list(pv_battery.get_model_variables(causality=2).keys())
pv_battery_output_names = list(pv_battery.get_model_variables(causality=3).keys())
print("*****modelica_input__output*****", pv_battery_input_names, pv_battery_output_names)
# time settings
# by setting idf_steps_per_hour, you could set the resolution for E+ and Modelica.
time_stop = 30 * 24 * 3600
ts = 0 * 24 * 3600
te = ts + time_stop
idf_steps_per_hour = 6
# eplus simu
eplus_options = eplus.simulate_options()
eplus_options['ncp'] = (time_stop-ts)/3600*idf_steps_per_hour
res = eplus.simulate(start_time=ts,
                        final_time=te,
                        options=eplus_options)
P_building = res['P_building']
P_building_df = pd.DataFrame({'P_building': np.array(P_building)})
P_building_df.to_excel(r"D:\Docu\P_building.xlsx")
# pvbattery simu
pv_battery_options = pv_battery.simulate_options()
pv_battery_options['ncp'] = (time_stop-ts)/3600*idf_steps_per_hour
time_arr = np.arange(ts, te + 3600/idf_steps_per_hour, 3600/idf_steps_per_hour)
y = np.array(P_building)
input_trac = np.transpose(np.vstack((time_arr.flatten(), y.flatten())))
input_object = (pv_battery_input_names, input_trac)
res = pv_battery.simulate(start_time=ts,
                        final_time=te,
                        options=pv_battery_options,
                        input=input_object)
power = res['power']
power_df = pd.DataFrame({'power': np.array(power)})
power_df.to_excel(r"D:\Docu\power_python.xlsx")
soc = res['soc']
soc_df = pd.DataFrame({'soc': np.array(soc)})
soc_df.to_excel(r"D:\Docu\soc_python.xlsx")
