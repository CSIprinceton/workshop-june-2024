# Deep Modeling for Molecular Simulation
Hands-on sessions Day 4

# Aims
This tutorial will introduce some basic concepts of Large Atomic Model (LAM) and demonstrate how to use a 
pretrained LAM by zero-shot and finetune. In specific, we will learn how to use the recently released DPA2 [1].

# Objectives
- Zero-shot.
- Fine-tune.

# Environment
As DPA2 is currently only supported by the latest version of DeePMD-kit, we need download a docker image that
prepares a necessary environment.
```
$ apptainer pull docker://ghcr.io/deepmodeling/deepmd-kit:2024Q1_cu11
```

Also, we need download the latest pretrained DPA2 model.
```
$ wget https://github.com/deepmodeling/deepmd-kit/pkgs/container/deepmd-kit/225322173?tag=2024Q1_cu11
```

# Dataset
Our target dataset is H2O liquid and ice labelled by CP2K at revPBE0-D3 (1778 structures in total).
| System Name   | Structure Number  |
| ------------- | ----------------- |
| classical_ice | 3                 |
| classical_liq | 179               |
| quantum_ice   | 847               |
| quantum_liq   | 749               |

```
$ tree ./assets/dataset -L 2
./assets/dataset
├── classical_ice
├── classical_liq
├── quantum_ice
└── quantum_liq
```

# Test se_a
```
$ cd ./test-sea
$ sbatch ./run.slurm
# Wait few minutes for the job to finish...
$ grep "Force  RMSE" ./slurm-<YOUR-JOBID>.out
```

# Zero-shot
```
$ cd ./zero-sho
$ sbatch ./run.slurm
# Wait few minutes for the job to finish...
$ grep "Force  RMSE" ./slurm-<YOUR-JOBID>.out
[2024-06-18 17:39:55,496] DEEPMD INFO    Force  RMSE        : 1.568359e-01 eV/A  # classical_ice
[2024-06-18 17:40:21,248] DEEPMD INFO    Force  RMSE        : 1.983394e+00 eV/A  # classical_liq
[2024-06-18 17:40:57,359] DEEPMD INFO    Force  RMSE        : 1.651158e-01 eV/A  # quantum_ice
[2024-06-18 17:41:27,344] DEEPMD INFO    Force  RMSE        : 1.730639e-01 eV/A  # quantum_liq
[2024-06-18 17:41:27,345] DEEPMD INFO    Force  RMSE        : 6.493739e-01 eV/A  # <- weighted error on the entire dataset
```

# Fine-tune
```
$ cd ./fine-tune
$ sbatch ./run.slurm
# Wait few minutes for the job to finish...
$ grep "Force  RMSE" ./slurm-<YOUR-JOBID>.out
```

# Summary

# References
[1] Zhang, Duo, et al. "DPA-2: Towards a universal large atomic model for molecular and material simulation." arXiv preprint arXiv:2312.15492 (2023).
