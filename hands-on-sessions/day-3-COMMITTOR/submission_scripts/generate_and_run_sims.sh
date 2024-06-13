#!/bin/bash

# source programs
source /home/etrizio@iit.local/Bin/dev/plumed2-dev/sourceme.sh

# parse iteration number
iter=$1

# define core offset and number
CORE_NUM=1
CORE_OFFSET=10


FOLDER_NAME="iter_${iter}" 
rm -r $FOLDER_NAME
echo folder $FOLDER_NAME

# create folder from template (need inputs, plumed.dat and model)
cp -r template $FOLDER_NAME
# move to folder
cd $FOLDER_NAME

# by default we run from A and B
mkdir A
mkdir B

# modify seed
sed -i "s/random_seed       42/random_seed       $(($iter+1))/g" input_md_A.dat
sed -i "s/random_seed       42/random_seed       $(($iter+2))/g" input_md_B.dat


# modify model name in plumed.dat
sed -i "s/model_0_z.pt/model_${iter}_z.pt/g" plumed.dat
# sed -i "s/model_0_z.pt/model_${iter}_q.pt/g" plumed.dat


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

