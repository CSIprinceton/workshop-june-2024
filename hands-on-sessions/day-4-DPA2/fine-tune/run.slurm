#!/bin/bash -l
#SBATCH --job-name=dpa2_finetune
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
#SBATCH --partition gpu-test
#SBATCH --time=00:59:00
#SBATCH --mem-per-cpu=4G

module purge
export OMP_NUM_THREADS=1
export TF_INTRA_OP_PARALLELISM_THREADS=1
export TF_INTER_OP_PARALLELISM_THREADS=1
export DP_INFER_BATCH_SIZE=512

apptainer exec --nv ../deepmd-kit_2024Q1_cu11.sif dp --pt train ./input_finetune.json --finetune ../OpenLAM_2.1.0_27heads_2024Q1.pt --model-branch H2O_H2O-PD

apptainer exec --nv ../deepmd-kit_2024Q1_cu11.sif dp --pt test -m ./model.ckpt.pt -f ../assets/test.txt

apptainer exec --nv ../deepmd-kit_2024Q1_cu11.sif dp --pt freeze
