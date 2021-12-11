@ECHO Off
:: set/add energyplus to path
set energyplus_path=C:\EnergyPlusV9-3-0\Energy+.idd

:: get EnergyPlusToFMU folder
for %%a in ("%CD%") do set "p_dir=%%~dpa"
for %%a in (%p_dir:~0,-1%) do set "p2_dir=%%~dpa"

set efmu_path=EnergyPlusToFMU-v3.1.0\Scripts\
set full_efmu_path=%p2_dir%%efmu_path%
set efmu_script=%full_efmu_path%EnergyPlusToFMU.py

:: specify weather file
set weather_file=%CD%\USA_TX_Dallas-Love.Field.722583_TMY3.epw

:: specify energyplus idf file
set idf_name=US_SF_CZ3A_hp_slab_IECC_2021
set idf_path=%CD%\%idf_name%.idf

:: call energyplustofmu script
echo %efmu_script%
echo %energyplus_path%
echo %weather_file%
echo %idf_path%

python %efmu_script% -i %energyplus_path% -w %weather_file% -a 2 %idf_path%

:: clean folder
rm idf-to-fmu-export-prep-win.exe util-get-address-size.exe

:: rename fmu
:: rm building.fmu
if exist building.fmu rm building.fmu
ren %idf_name%.fmu building.fmu
:done