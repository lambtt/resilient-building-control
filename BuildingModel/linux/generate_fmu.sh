#! /bin/bash
# call energyplustofmu script
export ENERGYPLUSTOFMU_PATH=${HOME}/EnergyPlusToFMU-v3.1.0
# set energyplus path
export ENERGYPLUS_PATH=/usr/local/EnergyPlus-9-4-0

idf_name=US_SF_CZ3A_hp_slab_IECC_2021
weather_name=USA_TX_Dallas-Love.Field.722583_TMY3
# call energyplus to fmu main function to compile local idf to fmu
python ${ENERGYPLUSTOFMU_PATH}/Scripts/EnergyPlusToFMU.py -i ${ENERGYPLUS_PATH}/Energy+.idd -w ${weather_name}.epw -a 2 ${idf_name}.idf

# clean folder
rm idf-to-fmu-export-prep-linux util-get-address-size.exe

# rename fmu
rename=building.fmu

# remove if exists already
if test -f "${rename}"; 
then 
    rm ${rename}
fi 
# rename the fmu
# the generated fmu will have a different name as the .idf: replace dash by underscore
fmu_name=${idf_name//-/_}
echo ${fmu_name}
mv ${fmu_name}.fmu ${rename} 
