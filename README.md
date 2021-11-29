1.Before the simulation, in Modelica package, model "model_stategraph" need to be translated to FMU. 
  
This model's control logic is based at state-graph.
  
  This model has one input: 
  - "Load" which should be from E+ FMU.
  
  This model has three output: 
  - "pvpower" power generated from PVPanel;
  - "mode" battery's mode, 1 means dormant, 2 means charging, 3 means discharging;
  - "soc" battery's power state.

2.And please use the python code "4-test-simu-sequence/simu_sequence.py" to run the simulation of E+ FMU and Modelica FMU.
  
 Remember to change the FMU path in python code.




