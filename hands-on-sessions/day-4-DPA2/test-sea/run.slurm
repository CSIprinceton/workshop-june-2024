#!/bin/bash -l
#SBATCH --job-name=test_sea
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
#SBATCH --partition gpu-test
#SBATCH --time=00:09:00
#SBATCH --mem-per-cpu=4G

module purge
export OMP_NUM_THREADS=1
export TF_INTRA_OP_PARALLELISM_THREADS=1
export TF_INTER_OP_PARALLELISM_THREADS=1
export DP_INFER_BATCH_SIZE=512

apptainer exec --nv ../deepmd-kit_2024Q1_cu11.sif dp --pt test -m ../assets/revPBE0-D3-H2O.pb -f ../assets/test.txt
