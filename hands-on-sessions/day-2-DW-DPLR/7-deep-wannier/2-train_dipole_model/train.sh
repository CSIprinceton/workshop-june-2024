#!/bin/bash
#SBATCH --nodes=1                # node count
#SBATCH --ntasks=1               # total number of tasks across all nodes
#SBATCH --cpus-per-task=8        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem-per-cpu=4G         # memory per cpu-core (4G is default)
#SBATCH --gres=gpu:1             # number of gpus per node
#SBATCH --time=1:00:00          # total run time limit (HH:MM:SS)
#SBATCH --job-name="train" 

## change the path to the image file
dp_image=/tigress/yifanl/workshop-june-2024_images/deepmd-kit_2024Q1_cu11.sif 
apptainer exec --nv $dp_image dp train input.json
