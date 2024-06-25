# Notes about Containers 

## Pull the Images

### DeePMD-kit
```
apptainer pull docker://ghcr.io/deepmodeling/deepmd-kit:2024Q1_cu11
```
### QE
```
apptainer pull docker://nvcr.io/hpc/quantum_espresso:qe-7.1
```

### Wannier90
```
apptainer pull docker://csiprinceton/workshop-june-2024:wannier90_ase_dpdata-v0.3
```


## Use the Images

### DeePMD-kit
```
apptainer exec --nv deepmd-kit_2024Q1_cu11.sif dp -h
```

### QE
```
apptainer exec --nv quantum_espresso_qe-7.1.sif
```

### ASE
``` 
apptainer exec workshop-june-2024_wannier90_ase_dpdata-v0.3.sif python -c "import ase"
```