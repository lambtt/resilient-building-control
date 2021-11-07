from pyfmi import load_fmu
from pyfmi.master import Master
import numpy as np
import numpy.random as random
import pandas as pd
import random
eplus_dir = r"D:\EnergyPlusV9-5-0\EnergyPlusToFMU-v3.1.0\Scripts\win\US_SF_CZ3A_hp_slab_IECC_2021.fmu"
eplus = load_fmu(fmu = eplus_dir, log_level = 7)
output_names = list(eplus.get_model_variables(causality=3).keys())
print(output_names)

time_stop = 30 * 24 * 3600
ts = 0 * 24 * 3600
te = ts + time_stop
# if you use this two lines, it will say "initialization fails"
# eplus.setup_experiment(False, 0, 0, True, stop_time=te)
# eplus.initialize(ts,te)
idf_steps_per_hour = 6
options = eplus.simulate_options()
options['ncp'] = (time_stop-ts)/3600*idf_steps_per_hour
print((time_stop-ts)/3600*idf_steps_per_hour)

res = eplus.simulate(start_time=ts,
                        final_time=te,
                        options=options)

P_building = res['P_building']
print(P_building)