#!/bin/bash

# Directory structure for /scratch/csng/YEL/data/:
#   raw -> sub-xx
#   nifti -> sub-xx
#   output -> fmriprep -> sub-xx
#          -> freesurfer -> sub-xx

# All scripts should be located in /home/jthompsz/analysis/yel, while data should be located in /scratch/csng/YEL during processing them moved to MEMORI drive (YEL) - data gets removed from $SCRATCH every 100 days or so.

# 1. Make directories as needed. 
ls -la /scratch/csng/

mkdir /scratch/csng/YEL/
mkdir /scratch/csng/YEL/data/raw
mkdir /scratch/csng/YEL/data/raw/sub-2015
#Only make nifti and output if these don't exist
mkdir /scratch/csng/YEL/data/nifti
mkdir /scratch/csng/YEL/data/output
mkdir /scratch/csng/YEL/work

# 2. Pull data from /groups/MRICORE/PI-NAME to /scratch/csng/YEL/data/raw
cp -r /groups/MRICORE/Chaplin/CHAPLIN-PAIT2_*2045*/ /scratch/csng/YEL/data/raw/sub-2045

# grabbing data from YEL storage
cp -r /groups/YEL/Data/2015/CHAPLIN-PAIT2_*2015*/ /scratch/csng/YEL/data/raw/sub-2015

# 3. Edit participants.tsv to include participants you wish to preprocess, using emacs or vi

vi participants.tsv

# 4. The edit the slurm script to account for the number of parallel jobs, where jobs=nsubs.

vi /home/jthompsz/analysis/yel/raw_2_bids-fMRIPREP-YEL.sh

# then run the .slurm scripts

sbatch /home/jthompsz/analysis/yel/raw_2_bids-fMRIPREP-YEL.slurm

# Note the Batch JobID you are assigned. Check progress using sacct - it will say RUNNING if running, COMPLETED if completed, FAILED if failed, and PENDING if pending

sacct -X

# if it fails (or completes and something seems wring (ie w data in nifti folder), check the .err file that was generated. It is located in $SCRATCH and should be called
# raw_2_bids-fMRIPREP-NODExx-JobID.err (where NODExx and JobID were assigned when it ran.

ls -la /scratch/csng/YEL/raw_2_bids
cat /scratch/csng/YEL/raw_2_bids-YEL-NODE{edit this}-{edit this}

# errors are usually around file naming.



# 5. Edit the fmriprep slurm script to reflect the number of jobs (participants) you will run in parallel. You can run lots, so 10-20 at once should be OK

vi YEL-fMRIPREP-parallel.slurm

# edit the line that says #SBATCH --array=1-3 to make it 1-HowEverManyYouWillRun

# 6. Then run the .slurm script

vi /home/jthompsz/analysis/yel/YEL-fMRIPREP-parallel.slurm

# and check as above. If you are impatient like me you can also check your spot in the queue using sprio. If you need to kill a job use scancel JobID

# once it is completed (about 15-18 hours) check the .err and .out files in $SCRATCH. Note these are too big to read using cat or emacs - you probably need to download them locally.
# You can sftp directly into argo or use Filezilla (if you have Filezilla on your local machine - I recommend this tbh)
