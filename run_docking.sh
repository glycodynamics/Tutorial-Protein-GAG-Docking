#!/bin/bash

# load modules
module load vina-carb/v1.2 mgltools/v2.1.5.7 autodock-vina glycotorch-vina

# split receptor conformations
prepare_pdb_split_alt_confs.py -r receptor.pdb 

# convert receptor PDB into PDBQT
prepare_receptor4.py -r receptor_A.pdb -o receptor.pdbqt -A "hydrogens"

# convert ligand PDB into PDBQT
prepare_ligand4.py -l ligand.pdb -o ligand.pdbqt -A hydrogens

# Dock using AutoDock Vina
vina --config config.txt --out docked-vina.pdbqt  --log docked_vina.log

# Dock using Vina-carb
vina-carb --config config.txt --out docked-vinacarb.pdbqt  --log docked_vinacarb.log --chi_coeff 1 --chi_cutoff 2

# Dock using GlycoTorch Vina
GlycoTorchVina --config config.txt --out docked-glycotorch.pdbqt  --log docked_glycotorch.log --chi_coeff 1 --chi_cutoff 2
