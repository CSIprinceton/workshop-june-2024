
# PW=/home/deepmd23admin/Softwares/QuantumEspresso/q-e-qe-7.0/bin/pw.x
W90=/home/deepmd23admin/Softwares/wannier90-3.1.0/wannier90.x
# PWW90=/home/deepmd23admin/Softwares/QuantumEspresso/q-e-qe-7.0/bin/pw2wannier90.x
PW=/home/deepmd23admin/Softwares/QuantumEspresso/q-e-qe-6.4.1/bin/pw.x
PWW90=/home/deepmd23admin/Softwares/QuantumEspresso/q-e-qe-6.4.1/bin/pw2wannier90.x
## run a SCF DFT calculation.  
/usr/bin/mpirun -np 6 $PW -input scf.in > scf.out

## run a non-SCF DFT calculation for getting complete information on orbitals
## usually we need a denser k-grid for wannierzation. But here we use the sparse 2X2X2 grid to save time.
/usr/bin/mpirun -np 6 $PW -input nscf.in > nscf.out

# generate .nnkp as the input of the postprocessing code pw2wannier90
$W90 -pp water

# produce the matrices needed for maximally localized wannierization .mmn, .amn, .eig…
/usr/bin/mpirun -np 6 $PWW90 < water.pw2wan > pw2wan.out

## minimize the spread, calculate wannier function.
/usr/bin/mpirun -np 6 $W90 water
## The Wannier90 compiled on Azure virtual machine may not work as intended. If you get mpi error, run the following commands to get the wannier90 output.
# cp ../ice_mlwf/water.wout ./water.wout
# cp ../water_centers.xyz ./water_centers.xyz

 