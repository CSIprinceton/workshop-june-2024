#!/bin/bash
#SBATCH --nodes=1                # node count
#SBATCH --ntasks=8               # total number of tasks across all nodes
#SBATCH --cpus-per-task=1        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem-per-cpu=4G         # memory per cpu-core (4G is default)
#SBATCH --gres=gpu:1             # number of gpus per node
#SBATCH --time=0:50:00          # total run time limit (HH:MM:SS)
#SBATCH --job-name="wannier" 

qe_image=/tigress/yifanl/workshop-june-2024_images/quantum_espresso_qe-7.1.sif
wan_image=/tigress/yifanl/workshop-june-2024_images/workshop-june-2024_wannier90_ase_dpdata-v0.3.sif

## run a SCF DFT calculation.  
apptainer exec --nv $qe_image pw.x -input scf.in > scf.out

## run a non-SCF DFT calculation for getting complete information on orbitals
## usually we need a denser k-grid for wannierzation. But here we use the sparse 2X2X2 grid to save time.
apptainer exec --nv $qe_image pw.x -input nscf.in > nscf.out

# generate .nnkp as the input of the postprocessing code pw2wannier90
apptainer exec --nv $wan_image wannier90.x -pp water

# produce the matrices needed for maximally localized wannierization .mmn, .amn, .eig…
apptainer exec --nv $wan_image pw2wannier90.x < water.pw2wan > pw2wan.out

## minimize the spread, calculate wannier function
apptainer exec --nv $wan_image wannier90.x water
 
