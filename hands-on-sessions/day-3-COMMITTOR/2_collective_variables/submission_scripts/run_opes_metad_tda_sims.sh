#!/bin/bash

# source programs
source /home/etrizio@iit.local/Bin/dev/plumed2-dev/sourceme.sh

# define core offset and number
CORE_NUM=1
CORE_OFFSET=10

cd simulations

FOLDER_NAME="opes_metad_tda" 
rm -r $FOLDER_NAME
echo folder $FOLDER_NAME

# create folder from template (need inputs, plumed.dat and model)
cp -r ../templates/opes_metad_tda_template $FOLDER_NAME
# move to folder
cd $FOLDER_NAME

# by default we run from A and B
mkdir A
mkdir B

# modify seed to prevent trajectories from synchronizing
sed -i "s/random_seed       42/random_seed       1/g" input_md_A.dat
sed -i "s/random_seed       42/random_seed       3/g" input_md_B.dat

# cd A + run sim A
cd A
taskset --cpu-list $CORE_OFFSET-$(($CORE_OFFSET+$CORE_NUM-1)) plumed ves_md_linearexpansion < ../input_md_A.dat &
wait 1
cd ..
CORE_OFFSET=$(($CORE_OFFSET+$CORE_NUM))


# cd B + run sim B
cd B
taskset --cpu-list $CORE_OFFSET-$(($CORE_OFFSET+$CORE_NUM-1)) plumed ves_md_linearexpansion < ../input_md_B.dat &
cd ..
CORE_OFFSET=$(($CORE_OFFSET+$CORE_NUM))

cd ..

