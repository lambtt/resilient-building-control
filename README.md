# co-simulation_fmus
co-simulation between e+ and dymola
TEES_PVPanels.fmu in ElectricalModel is called in co-simu.py and the co-simulation failed.
It has one input interface(Load) and one output interface(power).
This fmu just consists of PVPanels.

TEES_PV_Battery.fmu in ElectricalModel/PVandBattery consists of PVPanels and battery. 
It has one input interface(Load) and two output interfaces(power, soc)
I will try to co-simulate this fmu and eplus's fmu in 11/7 and draw the control logic by state-graph.
