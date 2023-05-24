##############################################################################################
###
### Individual risk attitudes arise from noise 
### in neurocognitive magnitude representations
###
### M. Barretto Garcia, G. de Hollander, M. Grueschow, R. Polania, M. Woodford, and C. C. Ruff
### v. 2017
###
###
### This contains the code to run the perceptual magnitude and risky choice tasks. 
###
### The following scripts contain the following (.mat): 
###
### (1) rafasMother_fMRI     = this script creates the individual subject folder and stores the timings and behavioural data 
###                            in .mat file for the perceptual magnitude task. To run the script, input the subject number (subCode), 
###                            run number (run), and pseudo-subject initials (nameSub). 
###
### (2) exp_RiskComp_fMRI    = this is the main script or the perceptual magnitude task inside the fMRI scanner. This script
###                            requires installation of Cogent 2000 before running this script. Important parameters to note
###                            here include the number of trials (inputTrials), window mode (small or full screen), the screen
###                            resolution (screenResolution), the graphics window colour parameters (bg = set at 0), the folder 
###                            parameters (openFolder and subFolder) and task sequence parameters (taskSequence and taskSeqNum).
###                            To fully execute this script requires gen_dotMagRisk_fMRI.mat as well as the coin image.
###
### (3) gen_dotMagRisk_fMRI  = this generates the distribution and dispersion of coin clouds for the perceptual magnitude task. 
###
### (4) rafasMother_outside  = this script creates teh individual subject folder and stores the timings and behavioural data in .mat
###                            file for the risky choice task. Input the subject number (subCode), runs (run), and subject initials 
###                            (nameSub) to run the task. 
###
### (5) exp_RiskComp_outside = this is the main script for the risky choice task outside the scanner. This script
###                            requires installation of Cogent 2000 before running this script. Important parameters
###                            include the number of trials (inputTrials), window mode (small or full screen), the screen
###                            resolution (screenResolution), the graphics window colour parameters (bg = 0), folder
###                            parameters (openFolder and subFolder) and task sequence parameters (taskSequence and taskSeqNum).
###                            To fully execute this script requires gen_dotMagRisk_fMRI.mat as well as the coin image.
### 
### (6) gen_dotMagRisk_behaviorPilot = this generates the distribution and dispersion of coin clouds for the risky choice task. 
###
###
### Note: rafasMother'; 'exp'; and 'gen_dot' scripts are duplicates of each other except for the paramters thats specifically
###       tailored for the task. 

