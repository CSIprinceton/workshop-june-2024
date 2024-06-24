#!/bin/bash
#SBATCH --job-name=train         # create a short name for your job
#SBATCH --nodes=1                # node count
#SBATCH --ntasks=1                # total number of tasks across all nodes
#SBATCH --cpus-per-task=1        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem-per-cpu=16G         # memory per cpu-core (4G is default)
##SBATCH --constraint=gpu80
#SBATCH --gpu-mps
#SBATCH --gres=gpu:1             # number of gpus per node
#SBATCH --time=00:59:00          # total run time limit (HH:MM:SS)

apptainer exec --nv [path to the .sif file]/deepmd-kit_2024Q1_cu11.sif dp train input.json
#Please make sure that you provide the correct [path to the .sif file]
