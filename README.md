## Software Requirement
If you are a University of Mississippi member, the following software are required to complete this tutorial:\
Linux/Mac Users: [PyMOL](https://pymol.org/2/)\
Windows Users: [PyMOL](https://pymol.org/2/), [PuTTY](https://www.putty.org/), [WinSCP](https://winscp.net/eng/download.php)\
\
Other users are required to have:\
Linux/Mac Users: [PyMOL](https://pymol.org/2/), [AutoDock Vina](https://vina.scripps.edu/), [Vina-carb](http://legacy.glycam.org/docs/othertoolsservice/downloads/downloads-software/index.html) and [GlycoTorch Vina](https://github.com/EricBoittier/GlycoTorch-Vina)\
Windows Users: [PyMOL](https://pymol.org/2/), [PuTTY](https://www.putty.org/), [WinSCP](https://winscp.net/eng/download.php), [AutoDock Vina](https://vina.scripps.edu/)

Vina-carb and GlycoTorch Vina software are not available for windows OS.



# Protein-GAG Docking tutorial:
This tutorial aims to dock glycans and glycosaminoglycans to proteins using the [AutoDock Vina](https://vina.scripps.edu), [Vina-carb](https://pubs.acs.org/doi/10.1021/acs.jctc.5b00834) and [GlycoTorch Vina](https://pubs.acs.org/doi/10.1021/acs.jcim.0c00373)
You can download all the input files by clicking on Code --> Download Zip. Unzip this file and go inside the docking directory. 
We will break down this tutorial into five steps.

## 1. Obtain Protein and GAG Structure for docking: 
In this tutorial, we will be docking a Heparan sulfate (HS) tetrasaccharide to human HS 3-O-sulfotransferase isoform 3 (3-OST-3), a key sulfotransferase that transfers a sulfuryl group to a specific glucosamine residue in HS. First of all, download the X-ray structure of the complex from PDB [PDB ID: 1T8U](https://www.rcsb.org/structure/1t8u). Now, open the PDB Structure in PyMOL and perform the following structure manipulations:
#### Remove crystal waters: 
Open 1t8u.pdb file in PyMOL and click non on Action --> remove waters
#### Save ligand and protein separately
Now split the complex in protein and HS and save them separately in two separate PDB files. \
Select HS tetrasaccharide by clicking left mouse button on each monosaccharide. Then click on File --> export molecule --> Selection (sele) --> Save File name: ligand --> Files of type: pdb --> save. A [ligand.pdb](https://github.com/glycodynamics/gag-docking/blob/main/receptor_A.pdb) file will be saved in your computer 

Now select all the co-crystalized ligands and remove them (Action --> remove atoms). \
Then save protein: File --> export molecule --> Selection (1t8u) --> Save File name: receptor --> Files of type: pdb --> save. \
A [receptor.pdb](https://github.com/glycodynamics/gag-docking/blob/main/receptor.pdb) file will be saved to the current working directory of your computer.

These files have been prepared and placed under ./practice directory. 

Login to fucose using the instructions provided during the lecture. Linux/Mac users can use terminal to connect to ccbrc workstation, whereas windows users should use PyTTY to connect to the ccbrc workstation.
```
leo:~ sushil$ ssh -X guestXX@machine.host.name
guestXX@machine.host.name's password: 
Last login: Thu Jan 28 18:24:45 2021

##########################################################################
##									##
##    Computational Chemistry and Bioinformatics Research Core (CCBRC)	##
##									##
##			Support: sushil_at_olemiss.edu			##
##									##
##----------------------------------------------------------------------##
## 	Access to this machine is strictly for research and to  	##
##	authorized users only. 						## 
##									##
##########################################################################
```
Now if you will type "ls -l" and hit enter, there should be two directories "practice and tutorial" available to everyone.
```
-bash-4.2$ ls -l
total 8
drwxr-xr-x. 2 guest40 cgw 4096 Dec 15 15:50 practice
drwxr-xr-x. 2 guest40 cgw 4096 Dec 15 15:50 tutorial
```

A directory named "practice" has only input files for docking, and you can run calculations under this directory. To do so, type cd "./practice" and hit enter. Then type "ls -l," and it should list six files (listed below). Directory "tutorial has all the precalculated data if you want to look into the correct output files.

```
-bash-4.2$ cd practice
-bash-4.2$ ls -l
total 800
-rw-r--r--. 1 guest40 cgw 445014 Dec 15 15:50 1t8u.pdb
-rw-r--r--. 1 guest40 cgw    233 Dec 15 15:50 config.txt
-rwxr-xr-x. 1 guest40 cgw     74 Dec 15 15:50 delete_all_output.sh
-rw-r--r--. 1 guest40 cgw   7244 Dec 15 15:50 ligand.pdb
-rw-r--r--. 1 guest40 cgw 351639 Dec 15 15:50 receptor.pdb
-rwxr-xr-x. 1 guest40 cgw    776 Dec 15 15:50 run_docking.sh

```

## 2. Prepare receptor and ligand input files for Vina (PDBQT files):
Now copy your ligand.pdb and receptor.pdb files to fucose workstation (or locally in your computer if you have AutoDock Tools installed) and run the following four commands one after another to generate pdbqt file. In the PDBQT files, additional columns of charge on each atom "Q"  and their atom-type "T" are added. PDBQT files contain information of rotatable bonds in the ligand for flexible ligand docking. If you plan to use provided input files, run folwoing commands under directory ./practice

```
module load vina-carb/v1.2 mgltools/v2.1.5.7 autodock-vina glycotorch-vina
prepare_pdb_split_alt_confs.py -r receptor.pdb 
prepare_receptor4.py -r receptor_A.pdb -o receptor.pdbqt -A "hydrogens"
prepare_ligand4.py -l ligand.pdb -o ligand.pdbqt -A hydrogens
```
This will create [ligand.pdbqt](https://github.com/glycodynamics/gag-docking/blob/main/ligand.pdbqt) and [receptor.pdbqt](https://github.com/glycodynamics/gag-docking/blob/main/receptor.pdbqt) files in the directory where your ligand and receptor PDB files were placed (./practice).\


## 3. Prepare docking configuration files
Load 1T8U.pdb in pyMOL and open the Auodock/Vina plugin. Select grid settings and set the spacing to 1, X-points, Y-points, and Z-points to 40. Now select heparin sulfate in the PyMOL window, write "sele" in Selection and hit enter. You will see a 40-angstrom cubical box centered at the ligand. Make sure the ligand is placed entirely inside the box, as the docking program will do a conformation search and find a possible docking solution inside the box. 
![alt text](https://github.com/glycodynamics/gag-docking/blob/main/images/Screenshot%20from%202021-12-13%2015-40-31.png)

Now open config.txt file and add the following lines at the end of the file, then save and close. 
```
receptor=receptor.pdbqt
ligand=ligand.pdbqt 
cpu=4 
exhaustiveness=8
seed=0 
num_modes=20
energy_range=10
```
These lines have been added to config.txt file [config.txt](https://github.com/glycodynamics/gag-docking/blob/main/config.txt) and provided to you togather with other input files.

## 4. Perform Docking
```
vina --config config.txt --out docked-vina.pdbqt  --log docked_vina.log
```
Please wait while docking is running. It may take upto 5 minutes to finish the docking. Once completed, it will generate two files: [docked-vina.pdbqt](https://github.com/glycodynamics/gag-docking/blob/main/docked-vina.pdbqt) and [docked_vina.log](https://github.com/glycodynamics/gag-docking/blob/main/docked_vina.log). The docked-vina.pdbq contains all the docking poses generated by AutoDock Vina, and docked_vina.log contains docking energies of each docked pose. 

Now you can use the same input files and perform docking by vina-carb and GlycoTorch Vina. The only difference in command will be the use of "--chi_coeff" and "chi_cutoff 2" values. These two parameters have been incorporated in vina-carb to allow better sampling of glycan conformation along with the glycosidic linkages.

```
vina-carb --config config.txt --out docked-vinacarb.pdbqt  --log docked_vinacarb.log --chi_coeff 1 --chi_cutoff 2

GlycoTorchVina --config config.txt --out docked-glycotorch.pdbqt  --log docked_glycotorch.log --chi_coeff 1 --chi_cutoff 2
```
If you cannot run these calculations remotely, docking was already performed and output files from vina-carb [docked-vinacarb.pdbqt](https://github.com/glycodynamics/gag-docking/blob/main/docked-vinacarb.pdbqt) and GlycoTorach Vina [docked-glycotorch.pdbqt](https://github.com/glycodynamics/gag-docking/blob/main/docked-glycotorch.pdbqt) ate available for analysis. 

/
instead running each step one by one, you can makse use of script [run_docking.sh](https://github.com/glycodynamics/gag-docking/blob/main/run_docking.sh) and run all the steps at once. You can do that by running run_docking.sh script as following:
```
bash ./run_docking.sh 
```

## 5. Analyzing Docking Results
We have docked heparin sulfate to sulfotransferase using three different software, AutoDock Vina, Vina-carb, and GlycoTorchVina. These three programs differ in their approach to sample glycosidic linkage and sugar ring. Now we want to visualize docking poses and see which program predicted heparin-binding similar to what has been seen in the crystal structure of the X-ray structure of the complex obtained from PDB [PDB ID: 1T8U](https://www.rcsb.org/structure/1t8u). Now Open PyMOL and load [docked-vina.pdbqt](https://github.com/glycodynamics/gag-docking/blob/main/docked-vina.pdbqt) and view all 20 docking poses by pressing the right arrow key of the keyboard. 

![alt text](https://github.com/glycodynamics/gag-docking/blob/main/images/docked_ligands.png)

As shown above, in the figure (middle), the top-scoring docked pose (pose 1) from AutoDock vina had docked ligand slightly differently. Only two monosaccharides overlap from its binding pose in the crystal structure. If you play all the docking poses, pose 14 overlaps nicely over the crystal structure binding pose. This shows that AutoDock vina produced a good docking pose but failed to rank that pose as a top-scoring pose. \
\
On the other hand, Vina-carb ranks that pose as the top-scoring pose as its top-scoring pose overlaps very well over the crystal structure binding pose.\
\
Please note that this tutorial aims to educate in running docking using all three software and not to show that vina docking poses will be wrong and vina-carb will always provide a good docking pose. The performance of docking programs is greatly affected by several factors, and careful investigation is advised on a case-to-case basis. However, vina-carb has generally shown improved accuracy for protein-glycan complexes when evaluated on larger protein-glycan datasets.

## Troubleshooting Errors:
If you see the following error in the fucose machine, use "unset LD_LIBRARY_PATH" to fix it:
```
init.c(556):ERROR:161: Cannot initialize TCL
```
Fix:
```
unset LD_LIBRARY_PATH
```
