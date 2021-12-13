# Docking
This tutorial aims to dock glycans and glycosminoglycans to proteins using the [AutoDock Vina](https://vina.scripps.edu), [Vina-carb](https://pubs.acs.org/doi/10.1021/acs.jctc.5b00834) and [GlycoTorch Vina](https://pubs.acs.org/doi/10.1021/acs.jcim.0c00373)
You can download all the input files by clicking in Code --> Download Zip. Unzip this file and go inside docking directory. 
We will breakdown this tutorial in five steps.

## 1. Structure Preperation
In this tutorial we will be docking a Heparan sulfate (HS) etrasaccharide to human HS 3-O-sulfotransferase isoform 3 (3-OST-3), a key sulfotransferase that transfers a sulfuryl group to a specific glucosamine residue in HS. Firt of all, download X-ray structure of the complex from PDB [PDB ID: 1T8U] (https://www.rcsb.org/structure/1t8u). Now, open the PDB Structure in PyMOL and perform following structure manipulations:
#### remove crystal waters: 
Open 1t8u.pdb fil in PyMOL and click non on Action --> remove waters
#### save ligand and protein selerately
Now split the complex in protein and HS and save them seperately in two seperate pdb files. 
Select HS tetrasaccharide by clicking left mouse button on each monosaccharide. Then click on File --> export molecule --> Selection (sele) --> Save File name: ligand --> Files of type: pdb --> save

Now select all the co-crystalized ligands and remove them (Action --> remove atoms). Then save protein: File --> export molecule --> Selection (1t8u) --> Save File name: receptor --> Files of type: pdb --> save

These files have been prepared and placed under gag-docking direcotry. 

## 2. Preperation of reseptor and ligand PDBQT files
module load mgltools/v2.1.5.7
prepare_pdb_split_alt_confs.py -r receptor.pdb
prepare_receptor4.py -r receptor_A.pdb -o receptor.pdbqt -A "hydrogens"
prepare_ligand4.py -l ligand.pdb -o ligand.pdbqt -A hydrogens

## 3. Prepare docking configuration files
Load 1T8U.pdb in pymol and open Auodock/Vina plugin. Select grid settings and set spacking to 1, X-points, Y-points and Z-points to 40. Now select heparin sulfate in PyMOL window and write "sele" in Selection abd hit eneter. You will see a 40A cubical box centered at the liagnd. Make sure ligand is place fully inside the box as docking program will do conformation search and find a possible docking solution inside the box only. 
![alt text](https://github.com/glycodynamics/gag-docking/blob/main/images/Screenshot%20from%202021-12-13%2015-40-31.png)

Now open config.txt file and add following lines at the end of the file, save and close. 

receptor=receptor.pdbqt
ligand=ligand.pdbqt 
ncpus=1
exhaustiveness=8
seed=0
num_modes=200
energy_range=10

This file (config.txt) has been prepared and provided with input files.

## 4. Docking
module load autodock-vina
vina --config config.txt --out docked-vina.pdbqt  --log docked_vina.log
----
#################################################################
# If you used AutoDock Vina in your work, please cite:          #
#                                                               #
# O. Trott, A. J. Olson,                                        #
# AutoDock Vina: improving the speed and accuracy of docking    #
# with a new scoring function, efficient optimization and       #
# multithreading, Journal of Computational Chemistry 31 (2010)  #
# 455-461                                                       #
#                                                               #
# DOI 10.1002/jcc.21334                                         #
#                                                               #
# Please see http://vina.scripps.edu for more information.      #
#################################################################

WARNING: The search space volume > 27000 Angstrom^3 (See FAQ)
WARNING: at low exhaustiveness, it may be impossible to utilize all CPUs
Reading input ... done.
Setting up the scoring function ... done.
Analyzing the binding site ... done.
Using random seed: 0
Performing search ... 
0%   10   20   30   40   50   60   70   80   90   100%
|----|----|----|----|----|----|----|----|----|----|
***************************************************
done.
Refining results ... done.

mode |   affinity | dist from best mode
     | (kcal/mol) | rmsd l.b.| rmsd u.b.
-----+------------+----------+----------
   1         -8.6      0.000      0.000
   2         -8.0      1.455      3.875
   3         -7.7      2.179      5.238
   4         -7.4      1.653      3.331
   5         -7.3      2.943      6.291
   6         -7.3      1.509      2.142
   7         -7.3      3.421     11.138
   8         -7.2      3.022     10.935
   9         -7.1      4.229      8.443
  10         -7.1      1.662      3.182
  11         -7.0      3.277     12.084
  12         -7.0      5.594     10.896
  13         -6.9      2.794     11.533
  14         -6.9      6.149     10.777
  15         -6.9      5.631     10.283
  16         -6.8      4.276      8.444
  17         -6.7      5.037     10.192
  18         -6.7      2.762     11.182
  19         -6.4      5.728     10.274
  20         -6.4      3.254      6.168
Writing output ... done.
-----


## 5. Analyzing Docking Results
