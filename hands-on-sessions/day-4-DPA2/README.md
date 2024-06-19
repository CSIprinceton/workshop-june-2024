# Deep Modeling for Molecular Simulation
Hands-on sessions Day 4

# Aims
This tutorial will introduce some basic concepts of Large Atomic Model (LAM) and demonstrate how to use a 
pretrained LAM by zero-shot and finetune. In specific, we will learn how to use the recently released DPA2 [1].

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
Before diving into DPA2, we can first test a well-established DP model using the se_a descripter
trained by an active learning workflow, which serves as our baseline model here.
```
$ cd ./test-sea
$ sbatch ./run.slurm
# Wait few minutes for the job to finish...
$ grep "Force  RMSE" ./slurm-<YOUR-JOBID>.out
```

# Zero-shot
Zero-shot is a method to test the LAM's generalization. In this scenario, we train the DPA2 for ZERO
step, which only adjusts the energy_bias in the fitting_net that maps the pretrained descripter to the atomic energy.

```
$ cd ./zero-sho
$ sbatch ./run.slurm
# Wait few minutes for the job to finish...
$ grep "Force  RMSE" ./slurm-<YOUR-JOBID>.out
DEEPMD INFO    Force  RMSE        : 1.568359e-01 eV/A  # classical_ice
DEEPMD INFO    Force  RMSE        : 1.983394e+00 eV/A  # classical_liq
DEEPMD INFO    Force  RMSE        : 1.651158e-01 eV/A  # quantum_ice
DEEPMD INFO    Force  RMSE        : 1.730639e-01 eV/A  # quantum_liq
DEEPMD INFO    Force  RMSE        : 6.493739e-01 eV/A  # <- weighted error on the entire dataset
```

> [!NOTE]
> You may see something like `DEEPMD WARNING sel of type 0 is not enough! The expected value is not less than 343, but you set it to 120.`
> in the slurm.out. This is due to the large cutoff of 9 Angstrom used in DPA2.

As DPA2 is trained in a multi-task manner, it contains several task heads while uses a shared descriptor. 
Each head corresponds to one fitting_net for a dataset. Here, we use the `H2O_H2O-PD` head (command option `-m H2O_H2O-PD`), 
the fitting_net of which is trained on a dataset by VASP at SCAN.[2] Since there is a large difference in the total energy by VASP and CP2K,
we may expect a large error in energy by DPA2 for our dataset.

> [!TIP]
> You may test DPA2 with other heads, for example, `H2O_H2O-PBE0TS`.

# (Single-Task) Fine-tune
Fine-tune is a method to train a small fraction of parameters of a large model to improve the performance on a specific dataset.
For the DPA2 architecture, the descriptor parameters are frozen (pretrained on multiple datasets) and only fitting_net parameters
are updated during the fine-tuning.
Here, we train DPA2 on our dataset for 10_000 steps (numb_steps in input.json) based on the `H2O_H2O-PD` head.
The force_rmse for all systems are significantly improved after a small numb_steps.

```
$ cd ./fine-tune
$ sbatch ./run.slurm
# Wait few minutes for the job to finish...
$ grep "Force  RMSE" ./slurm-<YOUR-JOBID>.out
DEEPMD INFO    Force  RMSE        : 2.589388e-02 eV/A
DEEPMD INFO    Force  RMSE        : 1.625268e-01 eV/A
DEEPMD INFO    Force  RMSE        : 3.390621e-02 eV/A
DEEPMD INFO    Force  RMSE        : 4.319233e-02 eV/A
DEEPMD INFO    Force  RMSE        : 6.319815e-02 eV/A
```

> [!NOTE]
> Besides the single-task fine-tune, you may train your target dataset with a dataset used in the pretraining to avoid overfitting, which
> is called multi-task fine-tune. See the [DPA-2.1.0-2024Q1](https://www.aissquare.com/models/detail?pageType=models&name=DPA-2.1.0-2024Q1&id=244) report for more information.

# (Optional) Molecular Dynamics

# References
1. Zhang, Duo, et al. "DPA-2: Towards a universal large atomic model for molecular and material simulation." arXiv preprint arXiv:2312.15492 (2023).
2. Zhang, Linfeng, et al. "Phase diagram of a deep potential water model." Physical review letters 126.23 (2021): 236001.
