from pyfmi import load_fmu
from pyfmi.master import Master

eplus_dir = r'D:\EnergyPlusV9-5-0\EnergyPlusToFMU-v3.1.0\Scripts\win\US_SF_CZ3A_hp_slab_IECC_2021.fmu'
eplus = load_fmu(fmu = eplus_dir, log_level = 7)
output_names = list(eplus.get_model_variables(causality=3).keys())
print(output_names)

# remember to connect to vpn, which can ensure your fmu from dymola can load
pv_dir = r'C:\Users\10178\Documents\Dymola\TEES_PVPanels.fmu'
pv = load_fmu(pv_dir, log_level = 7)
input_names = pv.get_model_variables(causality=2).keys()
print(input_names)

models = [eplus, pv]
# set up connections
connections = []
# add power connections
connections = connections + [(eplus, 'P_building', pv, 'Load')]
print(connections)

# master the simulation
sim = Master(models, connections)
opts = sim.simulate_options()
time_stop = 30 * 24 * 3600
ts = 0 * 24 * 3600
te = ts + time_stop
idf_steps_per_hour = 6
# opts['step_size'] = 60/idf_steps_per_hour*60
opts["step_size"] = 600

# simulation
res = sim.simulate(start_time=ts, final_time=te, options=opts)

# get results
time_eplus = res[eplus]["time"]
time_pv = res[pv]["time"]
P_building = res[eplus]["P_building"]
E_building = res[eplus]["E_building"]
print("OK")
