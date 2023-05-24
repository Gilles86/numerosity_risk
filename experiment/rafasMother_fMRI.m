function rafasMother_fMRI(subCode, run, nameSub)
%%% For the behavioral experiment...
%%% Magnitude Comparison, n = 180 (but we divide it now into 9 runs) 
%%% Risky Decision Making, n = 210

%subCode = 1;
%nameSub = 'TEST';


%% fMRI PARAMETERS
inputTrials1 = 18;

%% CREATE SUBJECT-LEVEL FOLDERS

% Create Folder for Every Subject
%drive =  'N:\';
%drive =  'D:\';
drive =  'E:\';
%mainFolder = 'sessions\copy_to_client\mgarcia\';
%mainFolder = 'Projects\RISKPRECISION\';
mainFolder = 'Testlab\mgarcia\'; % BLU Lab
openFolder = [drive mainFolder];
cd(openFolder);

if subCode < 10
    subFolder = ['sub_0' num2str(subCode) '_' nameSub];
elseif subCode >= 10
    subFolder = ['sub_' num2str(subCode) '_' nameSub];
end
%subFolder = subFolder(1:(length(subFolder)-1));

mkdir(subFolder);

%% Basic Parameters
windowmode = 0;
screenResolution = 3;
bg = 0.8;

%% MAGNITUDE COMPARISON TASK
expType = 1;
riskExpStim = 0;
taskSequence = 1;
taskSeqNum = 1;

behaviorPilot.magExpType = expType;
behaviorPilot.magRiskExpStim = riskExpStim;
behaviorPilot.magTaskSequence = taskSequence;
behaviorPilot.magTaskSeqNum = taskSeqNum;

exp_RiskComp_fMRI(subCode, run, nameSub, inputTrials1, windowmode, screenResolution, bg, openFolder, subFolder, taskSequence, taskSeqNum)

%%% Save all the parameters here.
behaviorPilot.drive = drive;
behaviorPilot.mainFolder = mainFolder;
behaviorPilot.openFolder = openFolder;
behaviorPilot.subFolder = subFolder;
behaviorPilot.windowmode = windowmode;
behaviorPilot.screenResolution = screenResolution;
behaviorPilot.bg = bg;

if subCode < 10
    save([openFolder subFolder '\' 'sub_0' num2str(subCode) '_run_0' num2str(run) '_' nameSub '_pilPar' '.mat'],'behaviorPilot');
elseif subCode >= 10
    save([openFolder subFolder '\' 'sub_' num2str(subCode) '_run_0' num2str(run) '_' nameSub '_pilPar' '.mat'],'behaviorPilot');
end

%%% sum all the runs. 
% payment_RiskComp(subCode, nameSub, openFolder, subFolder, windowmode, screenResolution, bg)
 




