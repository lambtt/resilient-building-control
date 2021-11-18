within ;
package TEES

  model Original_AcBattery "This example shows how to use the AC battery model"
    extends Modelica.Icons.Example;
    Buildings.Electrical.AC.OnePhase.Storage.Battery bat_ideal(
      eta_DCAC=1,
      etaCha=1,
      etaDis=1,
      SOC_start=0.5,
      EMax=749999.88,
      V_nominal=120) "Ideal battery without losses"
      annotation (Placement(transformation(extent={{20,22},{40,42}})));
    Buildings.Electrical.AC.OnePhase.Sources.FixedVoltage fixVol(f=60, V=120)
      annotation (Placement(transformation(extent={{-42,-10},{-22,10}})));
    Modelica.Blocks.Sources.Pulse pow(
      offset=-500,
      amplitude=1000,
      width=50,
      period=1200)
      "Signal that indicates how much power should be stored in the battery"
      annotation (Placement(transformation(extent={{-20,60},{0,80}})));
    Buildings.Electrical.AC.OnePhase.Storage.Battery bat_loss_acdc(
      etaCha=1,
      etaDis=1,
      SOC_start=0.5,
      eta_DCAC=0.95,
      EMax=749999.88,
      V_nominal=120) "Battery with losses for AC/DC conversion"
      annotation (Placement(transformation(extent={{20,-10},{40,10}})));
    Buildings.Electrical.AC.OnePhase.Storage.Battery bat(
      SOC_start=0.5,
      eta_DCAC=0.95,
      EMax=749999.88,
      V_nominal=120)
      "Battery with losses for AC/DC conversion and charge/discharge"
      annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  equation
    connect(fixVol.terminal, bat_ideal.terminal) annotation (Line(
        points={{-22,0},{0,0},{0,32},{20,32}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(pow.y, bat_ideal.P) annotation (Line(
        points={{1,70},{30,70},{30,42}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(fixVol.terminal, bat_loss_acdc.terminal) annotation (Line(
        points={{-22,0},{0,0},{0,0},{20,0}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(fixVol.terminal, bat.terminal) annotation (Line(
        points={{-22,0},{0,0},{0,-30},{20,-30}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(pow.y, bat_loss_acdc.P) annotation (Line(
        points={{1,70},{50,70},{50,20},{30,20},{30,10}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(pow.y, bat.P) annotation (Line(
        points={{1,70},{66,70},{66,-10},{30,-10},{30,-20}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (            experiment(
        StopTime=3600,
        Tolerance=1e-6),
              __Dymola_Commands(file=
            "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/OnePhase/Storage/Examples/AcBattery.mos"
          "Simulate and plot"),
            Documentation(revisions="<html>
<ul>
<li>
Sept 19, 2014, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>",   info="<html>
<p>
This example shows how to use an AC battery model.
</p>
<p>
The example compares three different batteries. The battery named
<code>bat_ideal</code> is ideal and it does not account for any losses.
The battery named <code>bat_loss_acdc</code> accounts for conversion losses when converting
between AC and DC.
The battery named <code>bat</code> accounts for both conversion losses and inefficiencies
during both the charge and discharge phases.
</p>
<p>
All the batteries start from the same initial condition, which is 50% of their total capacity.
The batteries are charged and discharged in the same way. The input signal <code>pow.y</code>
is the power that each battery should store or release. The signal has a duty cycle equal to 50%.
Therefore, if there are no losses the same amount of power stored into the battery will be
released and after one cycle the State of Charge (SOC) has to be equal.
</p>
<p>
The image below shows the SOC of the three batteries.
</p>
<p align=\"center\">
<img alt=\"alt-image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/OnePhase/Storage/Examples/SOCs.png\"/>
</p>
<p>
As expected the red line (ideal battery) maintains the SOC over the time.
The other two batteries loose some
of the initial energy due to the losses.
</p>
</html>"));
  end Original_AcBattery;

  model Original_DCBattery "Test model for battery"
    extends Modelica.Icons.Example;
    Buildings.Electrical.DC.Storage.Battery     bat(EMax=40e3*3600, V_nominal=
          12)
      "Battery"
      annotation (Placement(transformation(extent={{120,-46},{140,-26}})));
    Buildings.Electrical.DC.Sources.ConstantVoltage    sou(V=12) "Voltage source"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          origin={98,-80})));
    Modelica.Electrical.Analog.Basic.Ground ground
      annotation (Placement(transformation(extent={{76,-120},{96,-100}})));
    Buildings.Electrical.DC.Loads.Conductor             loa(
      P_nominal=0, mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
      V_nominal=12) "Electrical load"
      annotation (Placement(transformation(extent={{140,-90},{160,-70}})));
    Modelica.Blocks.Sources.Constant const1(k=-11e3)
      "Power consumption of the load"
      annotation (Placement(transformation(extent={{200,-90},{180,-70}})));
    Modelica.Blocks.Sources.SampleTrigger startCharge(period=24*3600,
        startTime=23*3600)
      annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
    Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold=
         0.99)
      annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
    Modelica.Blocks.Sources.SampleTrigger startDischarge(period=24*3600,
        startTime=14*3600)
      annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));
    Modelica.Blocks.Logical.LessEqualThreshold lessEqualThreshold(threshold=
          0.01)
      annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
    Modelica.Blocks.Logical.Switch chaSwi "Switch to charge battery"
      annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
    Modelica.Blocks.Logical.Switch disSwi "Switch to discharge battery"
      annotation (Placement(transformation(extent={{60,10},{80,30}})));
    Modelica.Blocks.Sources.Constant PCha(k=1e4) "Charging power"
      annotation (Placement(transformation(extent={{0,-58},{20,-38}})));
    Modelica.Blocks.Sources.Constant POff(k=0) "Off power"
      annotation (Placement(transformation(extent={{0,-10},{20,10}})));
    Modelica.Blocks.Sources.Constant PDis(k=-1e4) "Discharging power"
      annotation (Placement(transformation(extent={{0,18},{20,38}})));
    Modelica.Blocks.Math.Add add
      annotation (Placement(transformation(extent={{100,0},{120,20}})));
    Buildings.Electrical.DC.Sensors.GeneralizedSensor powSen "Power sensor"
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={120,-60})));
    Modelica.StateGraph.InitialStep off(nIn=1, nOut=1)
                                        "Off state" annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          origin={-130,80})));
    Modelica.StateGraph.TransitionWithSignal toOn "Transition to on" annotation (
        Placement(transformation(
          extent={{-10,-10},{10,10}},
          origin={-100,80})));
    Modelica.StateGraph.StepWithSignal charge(nIn=1, nOut=1)
                                              "State to charge battery"
      annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
    Modelica.StateGraph.TransitionWithSignal toHold "Transition to hold"
      annotation (Placement(transformation(extent={{-50,70},{-30,90}})));
    Modelica.StateGraph.Step hold(nIn=1, nOut=1)
                                  "Battery charge is hold"
      annotation (Placement(transformation(extent={{-20,70},{0,90}})));
    Modelica.StateGraph.TransitionWithSignal toDischarge
      "Transition to discharge"
      annotation (Placement(transformation(extent={{10,70},{30,90}})));
    Modelica.StateGraph.StepWithSignal discharge(nIn=1, nOut=1)
                                                 "State to discharge battery"
      annotation (Placement(transformation(extent={{40,70},{60,90}})));
    Modelica.StateGraph.TransitionWithSignal toOff "Transition to off"
      annotation (Placement(transformation(extent={{70,70},{90,90}})));
    inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
      annotation (Placement(transformation(extent={{-200,80},{-180,100}})));
  equation

    connect(POff.y, disSwi.u3) annotation (Line(
        points={{21,0},{40,0},{40,12},{58,12}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(POff.y, chaSwi.u3) annotation (Line(
        points={{21,0},{40,0},{40,-38},{58,-38}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(PDis.y, disSwi.u1) annotation (Line(
        points={{21,28},{58,28}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(PCha.y, chaSwi.u1) annotation (Line(
        points={{21,-48},{30,-48},{30,-22},{58,-22}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(add.y, bat.P) annotation (Line(
        points={{121,10},{130,10},{130,-26}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(bat.SOC, greaterEqualThreshold.u) annotation (Line(
        points={{141,-30},{160,-30},{160,108},{-160,108},{-160,0},{-142,0}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(bat.SOC, lessEqualThreshold.u) annotation (Line(
        points={{141,-30},{160,-30},{160,108},{-160,108},{-160,-60},{-142,-60}},
        color={0,0,127},
        smooth=Smooth.None));

    connect(const1.y, loa.Pow) annotation (Line(
        points={{179,-80},{160,-80}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(loa.terminal, sou.terminal) annotation (Line(
        points={{140,-80},{108,-80}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(bat.terminal, powSen.terminal_p) annotation (Line(
        points={{120,-36},{120,-50}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(powSen.terminal_n, sou.terminal) annotation (Line(
        points={{120,-70},{120,-80},{108,-80}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(sou.n, ground.p) annotation (Line(
        points={{88,-80},{86,-80},{86,-100}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(startCharge.y, toOn.condition) annotation (Line(
        points={{-119,30},{-100,30},{-100,68}},
        color={255,0,255},
        pattern=LinePattern.Dash));
    connect(charge.active, chaSwi.u2) annotation (Line(points={{-70,69},{-70,69},{
            -70,50},{-70,-30},{58,-30}}, color={255,0,255}));
    connect(greaterEqualThreshold.y, toHold.condition) annotation (Line(
        points={{-119,0},{-90,0},{-90,60},{-40,60},{-40,68}},
        color={255,0,255},
        pattern=LinePattern.Dash));
    connect(startDischarge.y, toDischarge.condition) annotation (Line(
        points={{-119,-30},{-80,-30},{-80,54},{20,54},{20,68}},
        color={255,0,255},
        pattern=LinePattern.Dash));
    connect(disSwi.u2, discharge.active) annotation (Line(points={{58,20},{58,20},
            {50,20},{50,46},{50,69}}, color={255,0,255}));
    connect(discharge.outPort[1], toOff.inPort)
      annotation (Line(points={{60.5,80},{76,80}}, color={0,0,0}));
    connect(lessEqualThreshold.y, toOff.condition) annotation (Line(
        points={{-119,-60},{-60,-60},{-60,48},{80,48},{80,68}},
        color={255,0,255},
        pattern=LinePattern.Dash));
    connect(off.outPort[1], toOn.inPort) annotation (Line(points={{-119.5,80},{-111.75,
            80},{-104,80}}, color={0,0,0}));
    connect(toOn.outPort, charge.inPort[1])
      annotation (Line(points={{-98.5,80},{-81,80},{-81,80}}, color={0,0,0}));
    connect(charge.outPort[1], toHold.inPort)
      annotation (Line(points={{-59.5,80},{-44,80},{-44,80}}, color={0,0,0}));
    connect(toHold.outPort, hold.inPort[1])
      annotation (Line(points={{-38.5,80},{-21,80},{-21,80}}, color={0,0,0}));
    connect(hold.outPort[1], toDischarge.inPort)
      annotation (Line(points={{0.5,80},{8,80},{16,80}}, color={0,0,0}));
    connect(toDischarge.outPort, discharge.inPort[1])
      annotation (Line(points={{21.5,80},{39,80},{39,80}}, color={0,0,0}));
    connect(toOff.outPort, off.inPort[1]) annotation (Line(points={{81.5,80},{92,80},
            {92,100},{-150,100},{-150,80},{-141,80}}, color={0,0,0}));
    connect(disSwi.y, add.u1) annotation (Line(points={{81,20},{90,20},{90,16},{98,
            16}}, color={0,0,127}));
    connect(chaSwi.y, add.u2) annotation (Line(points={{81,-30},{90,-30},{90,4},{98,
            4}}, color={0,0,127}));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,
              -120},{220,120}})),
      experiment(Tolerance=1e-06, StopTime=432000),
      __Dymola_Commands(file=
            "modelica://Buildings/Resources/Scripts/Dymola/Electrical/DC/Storage/Examples/Battery.mos"
          "Simulate and plot"),
      Documentation(info="<html>
<p>
This model illustrates use of a battery connected to an DC voltage source
and a constant load.
The battery is charged every night at 23:00 until it is full.
At 14:00, it is discharged until it is empty.
This control is implemented using a finite state machine.
The charging and discharing power is assumed to be controlled to
a constant value of <i>10,000</i> Watts.
</p>
</html>",
        revisions="<html>
<ul>
<li>
April 6, 2016, by Michael Wetter:<br/>
Replaced <code>Modelica_StateGraph2</code> with <code>Modelica.StateGraph</code>.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/504\">issue 504</a>.
</li>
<li>
January 10, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end Original_DCBattery;

  model PV_Battery "Pv and battery to test"

    Buildings.Electrical.AC.OnePhase.Loads.Inductive RL(
      mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
      P_nominal=-1000,
      V_nominal=120) "Load taht consumes the power generted by the PVs"
      annotation (Placement(transformation(extent={{-12,-54},{8,-34}})));
    Buildings.Electrical.AC.OnePhase.Sources.Grid grid(f=60, V=120)
      "Electrical grid model"
             annotation (Placement(transformation(extent={{-30,-94},{-14,-76}})));
    Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil(
      til=0.34906585039887,
      lat=0.65798912800186,
      azi=-0.78539816339745) "Diffuse irradiation on tilted surface"
      annotation (Placement(transformation(extent={{-76,82},{-62,96}})));
    Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
      til=0.34906585039887,
      lat=0.65798912800186,
      azi=-0.78539816339745) "Direct irradiation on tilted surface"
      annotation (Placement(transformation(extent={{-76,56},{-62,70}})));
    Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
        computeWetBulbTemperature=false, filNam=
          Modelica.Utilities.Files.loadResource(
          "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
      annotation (Placement(transformation(extent={{-130,76},{-110,96}})));
    Modelica.Blocks.Math.Add G "Total irradiation on tilted surface"
      annotation (Placement(transformation(extent={{-42,72},{-30,84}})));
    Buildings.Electrical.AC.OnePhase.Sources.PVSimple pvSimple(A=10, V_nominal=
          120) "PV array simplified"
      annotation (Placement(transformation(extent={{10,4},{30,24}})));
    Buildings.Electrical.AC.OnePhase.Storage.Battery bat_loss_acdc(
      etaCha=1,
      etaDis=1,
      SOC_start=0.5,
      eta_DCAC=0.95,
      EMax=180000000,
      V_nominal=120) "Battery with losses for AC/DC conversion"
      annotation (Placement(transformation(extent={{78,-76},{98,-56}})));
    Modelica.Blocks.Math.Add add
      annotation (Placement(transformation(extent={{60,24},{80,44}})));
    Modelica.Blocks.Logical.And and1
      annotation (Placement(transformation(extent={{202,2},{216,16}})));
    Modelica.Blocks.Logical.GreaterEqual greaterEqual
      annotation (Placement(transformation(extent={{152,48},{164,58}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant ref1(k=0)
      "Load consumed from the house" annotation (Placement(transformation(
            extent={{132,42},{140,50}}), iconTransformation(extent={{54,-180},{
              80,-154}})));
    Modelica.Blocks.Logical.Greater greater
      annotation (Placement(transformation(extent={{156,-88},{168,-76}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant ref3(k=0.9)
      "Load consumed from the house" annotation (Placement(transformation(
            extent={{130,-54},{138,-46}}), iconTransformation(extent={{54,-180},
              {80,-154}})));
    Modelica.Blocks.Logical.Switch switch1
      annotation (Placement(transformation(extent={{276,-8},{286,2}})));
    Modelica.Blocks.Logical.Less less
      annotation (Placement(transformation(extent={{152,20},{164,32}})));
    Modelica.Blocks.Logical.Less less1
      annotation (Placement(transformation(extent={{156,-46},{168,-34}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant ref2(k=0)
      "Load consumed from the house" annotation (Placement(transformation(
            extent={{132,14},{140,22}}), iconTransformation(extent={{54,-180},{
              80,-154}})));
    Modelica.Blocks.Logical.Or or1
      annotation (Placement(transformation(extent={{232,-10},{244,2}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant ref4(k=0.1)
      "Load consumed from the house" annotation (Placement(transformation(
            extent={{130,-94},{138,-86}}), iconTransformation(extent={{54,-180},
              {80,-154}})));
    Modelica.Blocks.Logical.And and2
      annotation (Placement(transformation(extent={{202,-26},{216,-12}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant ref5(k=0)
      "Load consumed from the house" annotation (Placement(transformation(
            extent={{258,-20},{266,-12}}), iconTransformation(extent={{54,-180},
              {80,-154}})));
    Modelica.Blocks.Interfaces.RealOutput pvpower
      annotation (Placement(transformation(extent={{52,66},{72,86}})));
    Modelica.Blocks.Math.Gain gain(k=-1)
      annotation (Placement(transformation(extent={{32,-108},{46,-94}})));
    Modelica.Blocks.Interfaces.RealOutput soc
      annotation (Placement(transformation(extent={{78,-118},{98,-98}})));
    Modelica.Blocks.Sources.Constant input_for_load(k=600)
      annotation (Placement(transformation(extent={{-78,-112},{-58,-92}})));
  equation
    connect(grid.terminal,RL. terminal)
                                       annotation (Line(
        points={{-22,-94},{-22,-98},{-34,-98},{-34,-44},{-12,-44}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(weaDat.weaBus,HDifTil. weaBus) annotation (Line(
        points={{-110,86},{-82,86},{-82,89},{-76,89}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None));
    connect(weaDat.weaBus,HDirTil. weaBus) annotation (Line(
        points={{-110,86},{-82,86},{-82,63},{-76,63}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None));
    connect(HDifTil.H,G. u1) annotation (Line(
        points={{-61.3,89},{-54,89},{-54,81.6},{-43.2,81.6}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(HDirTil.H,G. u2) annotation (Line(
        points={{-61.3,63},{-54,63},{-54,74.4},{-43.2,74.4}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(G.y,pvSimple. G) annotation (Line(
        points={{-29.4,78},{20,78},{20,26}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(pvSimple.terminal,RL. terminal) annotation (Line(
        points={{10,14},{10,12},{-64,12},{-64,-44},{-12,-44}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(bat_loss_acdc.terminal, RL.terminal) annotation (Line(points={{78,-66},
            {-18,-66},{-18,-44},{-12,-44}},      color={0,120,120}));
    connect(pvSimple.P, add.u1) annotation (Line(points={{31,21},{52,21},{52,40},
            {58,40}}, color={0,0,127}));
    connect(ref1.y, greaterEqual.u2) annotation (Line(points={{140.8,46},{145,
            46},{145,49},{150.8,49}}, color={0,0,127}));
    connect(add.y, greaterEqual.u1) annotation (Line(points={{81,34},{118,34},{
            118,53},{150.8,53}}, color={0,0,127}));
    connect(add.y, less.u1) annotation (Line(points={{81,34},{118,34},{118,26},
            {150.8,26}}, color={0,0,127}));
    connect(ref2.y, less.u2) annotation (Line(points={{140.8,18},{145,18},{145,
            21.2},{150.8,21.2}}, color={0,0,127}));
    connect(bat_loss_acdc.SOC, less1.u1) annotation (Line(points={{99,-60},{118,
            -60},{118,-40},{154.8,-40}}, color={0,0,127}));
    connect(bat_loss_acdc.SOC, greater.u1) annotation (Line(points={{99,-60},{
            118,-60},{118,-82},{154.8,-82}}, color={0,0,127}));
    connect(ref3.y, less1.u2) annotation (Line(points={{138.8,-50},{150,-50},{
            150,-44.8},{154.8,-44.8}}, color={0,0,127}));
    connect(ref4.y, greater.u2) annotation (Line(points={{138.8,-90},{150,-90},
            {150,-86.8},{154.8,-86.8}}, color={0,0,127}));
    connect(greaterEqual.y, and1.u1) annotation (Line(points={{164.6,53},{182,
            53},{182,9},{200.6,9}}, color={255,0,255}));
    connect(less1.y, and1.u2) annotation (Line(points={{168.6,-40},{182,-40},{
            182,3.4},{200.6,3.4}}, color={255,0,255}));
    connect(less.y, and2.u1) annotation (Line(points={{164.6,26},{182,26},{182,
            -19},{200.6,-19}}, color={255,0,255}));
    connect(greater.y, and2.u2) annotation (Line(points={{168.6,-82},{182,-82},
            {182,-24.6},{200.6,-24.6}}, color={255,0,255}));
    connect(and1.y, or1.u1) annotation (Line(points={{216.7,9},{222,9},{222,-4},
            {230.8,-4}}, color={255,0,255}));
    connect(and2.y, or1.u2) annotation (Line(points={{216.7,-19},{222,-19},{222,
            -8.8},{230.8,-8.8}}, color={255,0,255}));
    connect(or1.y, switch1.u2) annotation (Line(points={{244.6,-4},{274,-4},{
            274,-3},{275,-3}}, color={255,0,255}));
    connect(ref5.y, switch1.u3) annotation (Line(points={{266.8,-16},{270,-16},
            {270,-7},{275,-7}}, color={0,0,127}));
    connect(add.y, switch1.u1) annotation (Line(points={{81,34},{118,34},{118,
            68},{256,68},{256,1},{275,1}}, color={0,0,127}));
    connect(switch1.y, bat_loss_acdc.P) annotation (Line(points={{286.5,-3},{
            304,-3},{304,-28},{88,-28},{88,-56}}, color={0,0,127}));
    connect(pvSimple.P, pvpower) annotation (Line(points={{31,21},{52,21},{52,
            40},{46,40},{46,76},{62,76}}, color={0,0,127}));
    connect(gain.y, RL.Pow) annotation (Line(points={{46.7,-101},{56,-101},{56,
            -44},{8,-44}}, color={0,0,127}));
    connect(gain.y, add.u2) annotation (Line(points={{46.7,-101},{56,-101},{56,
            28},{58,28}}, color={0,0,127}));
    connect(bat_loss_acdc.SOC, soc) annotation (Line(points={{99,-60},{104,-60},
            {104,-92},{88,-92},{88,-108}},                color={0,0,127}));
    connect(input_for_load.y, gain.u) annotation (Line(points={{-57,-102},{22,
            -102},{22,-101},{30.6,-101}}, color={0,0,127}));
    annotation (Diagram(coordinateSystem(extent={{-160,-120},{320,140}})), Icon(
          coordinateSystem(extent={{-160,-120},{320,140}})),
      experiment(StopTime=31536000, __Dymola_Algorithm="Dassl"));
  end PV_Battery;

  model PV_Battery_stategraph "Pv and battery to test"

    Buildings.Electrical.AC.OnePhase.Loads.Inductive RL(
      mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
      P_nominal=-1000,
      V_nominal=120) "Load taht consumes the power generted by the PVs"
      annotation (Placement(transformation(extent={{-12,-54},{8,-34}})));
    Buildings.Electrical.AC.OnePhase.Sources.Grid grid(f=60, V=120)
      "Electrical grid model"
             annotation (Placement(transformation(extent={{-30,-94},{-14,-76}})));
    Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil(
      til=0.34906585039887,
      lat=0.65798912800186,
      azi=-0.78539816339745) "Diffuse irradiation on tilted surface"
      annotation (Placement(transformation(extent={{-76,82},{-62,96}})));
    Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
      til=0.34906585039887,
      lat=0.65798912800186,
      azi=-0.78539816339745) "Direct irradiation on tilted surface"
      annotation (Placement(transformation(extent={{-76,56},{-62,70}})));
    Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
        computeWetBulbTemperature=false, filNam=
          "Modelica.Utilities.Files.loadResource(\"modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.APModelica.Utilities.Files.loadResource(\"modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos\").724940_TMY3.mos\")")
      annotation (Placement(transformation(extent={{-130,76},{-110,96}})));
    Modelica.Blocks.Math.Add G "Total irradiation on tilted surface"
      annotation (Placement(transformation(extent={{-42,72},{-30,84}})));
    Buildings.Electrical.AC.OnePhase.Sources.PVSimple pvSimple(A=10, V_nominal=
          120) "PV array simplified"
      annotation (Placement(transformation(extent={{10,4},{30,24}})));
    Buildings.Electrical.AC.OnePhase.Storage.Battery bat_loss_acdc(
      etaCha=1,
      etaDis=1,
      SOC_start=0.5,
      eta_DCAC=0.95,
      EMax=180000000,
      V_nominal=120) "Battery with losses for AC/DC conversion"
      annotation (Placement(transformation(extent={{122,-34},{142,-14}})));
    Modelica.Blocks.Interfaces.RealInput Load annotation (Placement(
          transformation(extent={{-182,-10},{-160,12}}),iconTransformation(
            extent={{-182,-10},{-160,12}})));
    Modelica.Blocks.Math.Gain gain(k=-1)
      annotation (Placement(transformation(extent={{34,-108},{48,-94}})));
    battery_controller battery_controller1
      annotation (Placement(transformation(extent={{242,-20},{276,8}})));
    mode_switch mode_switch1
      annotation (Placement(transformation(extent={{116,30},{146,56}})));
  equation
    connect(grid.terminal,RL. terminal)
                                       annotation (Line(
        points={{-22,-94},{-22,-98},{-34,-98},{-34,-44},{-12,-44}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(weaDat.weaBus,HDifTil. weaBus) annotation (Line(
        points={{-110,86},{-82,86},{-82,89},{-76,89}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None));
    connect(weaDat.weaBus,HDirTil. weaBus) annotation (Line(
        points={{-110,86},{-82,86},{-82,63},{-76,63}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None));
    connect(HDifTil.H,G. u1) annotation (Line(
        points={{-61.3,89},{-54,89},{-54,81.6},{-43.2,81.6}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(HDirTil.H,G. u2) annotation (Line(
        points={{-61.3,63},{-54,63},{-54,74.4},{-43.2,74.4}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(G.y,pvSimple. G) annotation (Line(
        points={{-29.4,78},{20,78},{20,26}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(pvSimple.terminal,RL. terminal) annotation (Line(
        points={{10,14},{10,12},{-64,12},{-64,-44},{-12,-44}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(bat_loss_acdc.terminal, RL.terminal) annotation (Line(points={{122,-24},
            {-18,-24},{-18,-44},{-12,-44}},      color={0,120,120}));
    connect(Load, gain.u)
      annotation (Line(points={{3,-101},{32.6,-101}}, color={0,0,127}));
    connect(gain.y, RL.Pow) annotation (Line(points={{48.7,-101},{62,-101},{62,
            -44},{8,-44}}, color={0,0,127}));
    connect(gain.y, battery_controller1.load) annotation (Line(points={{48.7,
            -101},{252.1,-101},{252.1,-16.1}}, color={0,0,127}));
    connect(gain.y, mode_switch1.load) annotation (Line(points={{48.7,-101},{
            150,-101},{150,24},{106,24},{106,39.1},{114.9,39.1}}, color={0,0,
            127}));
    connect(pvSimple.P, mode_switch1.pvpower) annotation (Line(points={{31,21},
            {110,21},{110,50},{114,50}}, color={0,0,127}));
    connect(bat_loss_acdc.SOC, mode_switch1.soc) annotation (Line(points={{143,
            -18},{156,-18},{156,62},{106,62},{106,43.9},{114.9,43.9}}, color={0,
            0,127}));
    connect(mode_switch1.y, battery_controller1.u) annotation (Line(points={{
            147,44.2},{230,44.2},{230,-2.8},{240,-2.8}}, color={255,127,0}));
    connect(pvSimple.P, battery_controller1.pvpower) annotation (Line(points={{
            31,21},{139.5,21},{139.5,-12},{248,-12}}, color={0,0,127}));
    connect(battery_controller1.y_battery, bat_loss_acdc.P) annotation (Line(
          points={{263,-2},{262,-2},{262,14},{132,14},{132,-14}}, color={0,0,
            127}));
    annotation (Diagram(coordinateSystem(extent={{-160,-120},{320,140}})), Icon(
          coordinateSystem(extent={{-160,-120},{320,140}})),
      experiment(StopTime=31536000, __Dymola_Algorithm="Dassl"));
  end PV_Battery_stategraph;

  model mode_switch
    Modelica.Blocks.Interfaces.RealInput load annotation (Placement(
          transformation(extent={{-122,20},{-100,42}}), iconTransformation(
            extent={{-122,-60},{-100,-38}})));
    Modelica.Blocks.Interfaces.RealInput pvpower annotation (Placement(
          transformation(extent={{-122,0},{-100,22}}), iconTransformation(
            extent={{-122,40},{-100,62}})));
    Modelica.Blocks.Interfaces.RealInput soc annotation (Placement(
          transformation(extent={{-122,-18},{-100,4}}), iconTransformation(
            extent={{-122,-12},{-100,10}})));
    Modelica.StateGraph.InitialStepWithSignal dormant(nIn=2, nOut=2) annotation (
        Placement(transformation(
          extent={{-10,10},{10,-10}},
          rotation=-90,
          origin={-10,76})));
    Modelica.StateGraph.StepWithSignal charge(nIn=2, nOut=2) annotation (
        Placement(transformation(
          extent={{-10,10},{10,-10}},
          rotation=-90,
          origin={-8,-4})));
    Modelica.StateGraph.StepWithSignal discharge(nIn=2, nOut=2) annotation (
        Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=90,
          origin={-8,-94})));
    Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToIntDor(final
        integerTrue=Integer(TEES.battery_mode.Dormant), final integerFalse=0)
      annotation (Placement(transformation(extent={{142,30},{162,50}})));
    Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToIntCha(final
        integerTrue=Integer(TEES.battery_mode.Charging), final integerFalse=0)
      annotation (Placement(transformation(extent={{142,-14},{162,6}})));
    Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToIntDis(final
        integerFalse=0, final integerTrue=Integer(TEES.battery_mode.Discharging))
      annotation (Placement(transformation(extent={{142,-60},{162,-40}})));
    Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(nin=3)
      annotation (Placement(transformation(extent={{176,-14},{196,6}})));
    Modelica.Blocks.Interfaces.IntegerOutput y "Connector of Integer output signal" annotation (Placement(
          transformation(extent={{200,-12},{220,8}}),  iconTransformation(extent={{200,-8},
              {220,12}})));
    Modelica.StateGraph.Transition dorToCha1(
      condition=pvpower + load >= 0 and soc <= 0.9,
      enableTimer=true,
      waitTime=0)
      "Dormant to charging mode"
      annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=90,
          origin={-10,30})));
    Modelica.StateGraph.Transition chaToDis(
      condition=pvpower + load < 0,
      enableTimer=true,
      waitTime=0)
      "Charging mode to discharging mode"
      annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=90,
          origin={-8,-40})));
    Modelica.StateGraph.Transition disToCha(
      condition=pvpower + load >= 0,
      enableTimer=true,
      waitTime=0)
      "Discharging mode to charging mode"
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={28,-64})));
    Modelica.StateGraph.Transition chaToDor(
      condition=pvpower + load >= 0 and soc > 0.9,
      enableTimer=true,
      waitTime=0)
      "Charging mode to dormant mode"
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={62,30})));
    Modelica.StateGraph.Transition disToDor(
      condition=pvpower + load < 0 and soc < 0.1,
      enableTimer=true,
      waitTime=0)
      "Discharging mode to dormant mode"
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={84,-68})));
    Modelica.StateGraph.Transition dorToDis(
      condition=pvpower + load < 0 and soc >= 0.1,
      enableTimer=true,
      waitTime=0)
      "Dormant to discharging mode"
      annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=90,
          origin={-72,6})));
  equation
    connect(y, mulSumInt.y) annotation (Line(points={{210,-2},{204,-2},{204,-4},
            {198,-4}}, color={255,127,0}));
    connect(y, y)
      annotation (Line(points={{210,-2},{210,-2}}, color={255,127,0}));
    connect(dormant.outPort[1], dorToCha1.inPort)
      annotation (Line(points={{-10,65.5},{-10,34}}, color={0,0,0}));
    connect(dorToCha1.outPort, charge.inPort[1]) annotation (Line(points={{-10,
            28.5},{-10,14},{-8,14},{-8,7}}, color={0,0,0}));
    connect(charge.active, booToIntCha.u)
      annotation (Line(points={{3,-4},{140,-4}}, color={255,0,255}));
    connect(discharge.active, booToIntDis.u) annotation (Line(points={{3,-94},{
            134,-94},{134,-50},{140,-50}}, color={255,0,255}));
    connect(dormant.active, booToIntDor.u) annotation (Line(points={{1,76},{134,
            76},{134,40},{140,40}}, color={255,0,255}));
    connect(charge.outPort[1], chaToDis.inPort) annotation (Line(points={{-8.25,
            -14.5},{-8.25,-20},{-8,-20},{-8,-36}}, color={0,0,0}));
    connect(chaToDis.outPort, discharge.inPort[1])
      annotation (Line(points={{-8,-41.5},{-8,-83}}, color={0,0,0}));
    connect(discharge.outPort[1], disToCha.inPort) annotation (Line(points={{
            -8.25,-104.5},{28,-104.5},{28,-68}}, color={0,0,0}));
    connect(disToCha.outPort, charge.inPort[2]) annotation (Line(points={{28,
            -62.5},{28,14},{-7.5,14},{-7.5,7}}, color={0,0,0}));
    connect(booToIntCha.y, mulSumInt.u[1])
      annotation (Line(points={{164,-4},{174,-4}}, color={255,127,0}));
    connect(charge.outPort[2], chaToDor.inPort) annotation (Line(points={{-7.75,
            -14.5},{-7.75,-18},{36,-18},{36,16},{62,16},{62,26}}, color={0,0,0}));
    connect(chaToDor.outPort, dormant.inPort[1]) annotation (Line(points={{62,
            31.5},{62,92},{-10.5,92},{-10.5,87}}, color={0,0,0}));
    connect(discharge.outPort[2], disToDor.inPort) annotation (Line(points={{
            -7.75,-104.5},{2,-104.5},{2,-104},{28,-104},{28,-86},{84,-86},{84,
            -72}}, color={0,0,0}));
    connect(disToDor.outPort, dormant.inPort[2]) annotation (Line(points={{84,
            -66.5},{84,106},{-9.5,106},{-9.5,87}}, color={0,0,0}));
    connect(dorToDis.outPort, discharge.inPort[2]) annotation (Line(points={{
            -72,4.5},{-72,-66},{-8,-66},{-8,-84}}, color={0,0,0}));
    connect(dormant.outPort[2], dorToDis.inPort) annotation (Line(points={{-10,
            65.5},{-10,44},{-72,44},{-72,10}}, color={0,0,0}));
    connect(booToIntDor.y, mulSumInt.u[2]) annotation (Line(points={{164,40},{
            172,40},{172,6},{168,6},{168,-4},{174,-4}}, color={255,127,0}));
    connect(booToIntDis.y, mulSumInt.u[3]) annotation (Line(points={{164,-50},{
            166,-50},{166,-48},{172,-48},{172,-4},{174,-4}}, color={255,127,0}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -140},{200,120}})), Diagram(coordinateSystem(preserveAspectRatio=
              false, extent={{-100,-140},{200,120}})));
  end mode_switch;

  type battery_mode = enumeration(
      Dormant "Not engaged in operation",
      Charging "Charing mode",
      Discharging "Discharging mode") "Operation modes";
  model battery_controller "change model for the battery"
    Modelica.Blocks.Interfaces.IntegerInput u "Storage mode"
      annotation (Placement(transformation(extent={{-140,12},{-100,52}})));
    Modelica.Blocks.Interfaces.RealInput load annotation (Placement(
          transformation(extent={{-122,-34},{-100,-12}}),
                                                        iconTransformation(
            extent={{10,-68},{32,-46}})));
    Modelica.Blocks.Interfaces.RealInput pvpower annotation (Placement(
          transformation(extent={{-122,-60},{-100,-38}}), iconTransformation(
            extent={{-60,-66},{-38,-44}})));
    Buildings.Controls.OBC.CDL.Integers.Equal isDor "Is dormant"
      annotation (Placement(transformation(extent={{22,22},{42,42}})));
    Modelica.Blocks.Sources.IntegerExpression dorMod(y=Integer(TEES.battery_mode.Dormant))
      "Dormant mode"
      annotation (Placement(transformation(extent={{-20,-4},{0,16}})));
    Modelica.Blocks.Logical.Switch swi "Switch"
      annotation (Placement(transformation(extent={{148,22},{168,42}})));
    Modelica.Blocks.Sources.Constant zer(k=0) "Zero"
      annotation (Placement(transformation(extent={{22,76},{42,96}})));
    Modelica.Blocks.Math.Add add
      annotation (Placement(transformation(extent={{22,-46},{42,-26}})));
    Modelica.Blocks.Interfaces.RealOutput y_battery(
      final quantity="1",
      min=0,
      max=1) annotation (Placement(transformation(extent={{240,22},{260,42}}),
          iconTransformation(extent={{100,30},{120,50}})));
    Modelica.Blocks.Math.Gain gain(k=-1)
      annotation (Placement(transformation(extent={{-60,-30},{-46,-16}})));
  equation
    connect(dorMod.y, isDor.u2) annotation (Line(points={{1,6},{10,6},{10,24},{
            20,24}}, color={255,127,0}));
    connect(u, isDor.u1)
      annotation (Line(points={{-120,32},{20,32}}, color={255,127,0}));
    connect(isDor.y, swi.u2)
      annotation (Line(points={{44,32},{146,32}}, color={255,0,255}));
    connect(zer.y, swi.u1) annotation (Line(points={{43,86},{136,86},{136,40},{
            146,40}}, color={0,0,127}));
    connect(pvpower, add.u2) annotation (Line(points={{-111,-49},{12,-49},{12,
            -42},{20,-42}}, color={0,0,127}));
    connect(add.y, swi.u3) annotation (Line(points={{43,-36},{136,-36},{136,24},
            {146,24}}, color={0,0,127}));
    connect(swi.y, y_battery)
      annotation (Line(points={{169,32},{250,32}}, color={0,0,127}));
    connect(load, gain.u)
      annotation (Line(points={{-111,-23},{-61.4,-23}}, color={0,0,127}));
    connect(gain.y, add.u1) annotation (Line(points={{-45.3,-23},{12,-23},{12,
            -30},{20,-30}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -140},{240,140}}), graphics={
          Polygon(
            points={{36,56},{36,-6},{10,-6},{-12,56},{36,56}},
            smooth=Smooth.None,
            pattern=LinePattern.None,
            lineColor={0,0,0},
            fillColor={0,127,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-28,56},{-6,-6},{-26,-6},{-48,56},{-28,56}},
            smooth=Smooth.None,
            pattern=LinePattern.None,
            lineColor={0,0,0},
            fillColor={0,127,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-62,56},{-40,-6},{-60,-6},{-82,56},{-62,56}},
            smooth=Smooth.None,
            pattern=LinePattern.None,
            lineColor={0,0,0},
            fillColor={0,127,0},
            fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
            preserveAspectRatio=false, extent={{-100,-140},{240,140}})));
  end battery_controller;

  model state_graph_test
    PV_Battery_stategraph pV_Battery_stategraph
      annotation (Placement(transformation(extent={{-30,8},{18,36}})));
    Modelica.Blocks.Sources.Constant input_for_load(k=600)
      annotation (Placement(transformation(extent={{-76,12},{-56,32}})));
  equation
    connect(input_for_load.y, pV_Battery_stategraph.Load)
      annotation (Line(points={{-55,22},{-32,22}}, color={0,0,127}));
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
      experiment(StopTime=31536000, __Dymola_Algorithm="Dassl"));
  end state_graph_test;
  annotation (uses(Modelica(version="4.0.0"), Buildings(version="8.0.0")));
end TEES;
