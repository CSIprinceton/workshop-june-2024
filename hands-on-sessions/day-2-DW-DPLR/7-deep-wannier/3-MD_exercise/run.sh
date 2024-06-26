#!/bin/bash
#SBATCH --nodes=1                # node count
#SBATCH --ntasks=1               # total number of tasks across all nodes
#SBATCH --cpus-per-task=1        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem-per-cpu=4G         # memory per cpu-core (4G is default)
#SBATCH --gres=gpu:1             # number of gpus per node
#SBATCH --time=2:00:00          # total run time limit (HH:MM:SS)
#SBATCH --job-name="run_md" 

## For della:
#dp_image=/tigress/yifanl/workshop-june-2024_images/deepmd-kit_2024Q1_cu11.sif 
## For Azure:
dp_image=/home/deepmd23admin/Softwares/deepmd-kit_2024Q1_cu11.sif

## the deep dipole model
ln -s ../train_energy_model/frozen_model.pb frozen_model.pb

apptainer exec --nv $dp_image lmp -v TEMP 330 -v PRES 1.0 -in in.lammps > thermo.log
