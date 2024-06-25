import numpy as np
import ase 
import ase.io
from matplotlib import pyplot as plt
from deepmd.infer import DeepDipole # use it to load your model
 
def get_WC_O_distance(ase_atoms, dipole_model):
    d_all = []
    for atoms in ase_atoms:
        atypes = np.array(atoms.get_atomic_numbers()) - 1
        d_frame = dipole_model.eval(atoms.get_positions(), atoms.get_cell(), atom_types=atypes)
        d_all.append(d_frame)
    d_all = np.concatenate(d_all, 0)
    return d_all

## Load Deep Dipole model
dipole_model = DeepDipole('./dipole_model/frozen_model.pb')
## Load MD trajectories
liq_configs = ase.io.read( './liquid_dipole/water.lammpstrj',format = 'lammps-dump-text',index=':')
print('loaded {} liquid configurations'.format(len(liq_configs) ))

## Evaluate Deep Dipole Model
liq_d_vec = get_WC_O_distance(liq_configs, dipole_model)
liq_d_vec = np.linalg.norm(liq_d_vec, axis=-1).flatten()

#### Plot Histogram
fig, ax = plt.subplots( figsize = (4, 3))
ax.hist(liq_d_vec, bins=50, alpha = 0.5, label=r'$d(liq)={:.2f}A$'.format(liq_d_vec.mean()))
ax.set_xlabel(r'$d$ [Angstrom]')
ax.set_ylabel('Histogram')
ax.legend()
fig.tight_layout()
plt.savefig('Wannier_Centroid_distribution.png')
