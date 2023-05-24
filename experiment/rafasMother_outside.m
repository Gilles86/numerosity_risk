function rafasMother_outside(subCode, run, nameSub)
%%% For the behavioral experiment...
%%% Magnitude Comparison, n = 180
%%% Risky Decision Making, n = 210

%subCode = 1;
%nameSub = 'TEST';

%%% BEHAVIORAL PILOT SEQUENCE
inputTrials2 = 24;
%% CREATE SUBJECT-LEVEL FOLDERS

% Create Folder for Every Subject
%drive =  'N:\';
%drive =  'D:\';
drive =  'E:\';
%mainFolder = 'sessions\copy_to_client\mgarcia\';
%mainFolder = 'Projects\RISKPRECISION\';
mainFolder = 'Testlab\mgarcia\';
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

%% RISKY CHOICE TASK
% Half of the blocks are Case 2 (Numerical Comparison).
% Half of the blocks are Case 3 (Coins Comparison).

expType = 2;
run = [];
sequence = randperm(2);
for blockSeq = 1:2
    if sequence(blockSeq) == 1
        riskExpStim = 2;
        taskSequence = blockSeq;
        if blockSeq == 1
            taskSeqNum = 2;
        elseif blockSeq == 2
            taskSeqNum = 3;
        end
        
        behaviorPilot.expType2 = expType;
        behaviorPilot.riskExpStim2 = riskExpStim;
        behaviorPilot.taskSequence2 = taskSequence;
        behaviorPilot.taskSeqNum2 = taskSeqNum;
        
        exp_RiskComp_outside(subCode, run, nameSub, riskExpStim, inputTrials2, windowmode, screenResolution, bg, openFolder, subFolder, taskSequence, taskSeqNum)
        
    elseif sequence(blockSeq) == 2
        riskExpStim = 3;
        taskSequence = blockSeq;
        if blockSeq == 1
            taskSeqNum = 2;
        elseif blockSeq == 2
            taskSeqNum = 3;
        end
        
        behaviorPilot.expType3 = expType;
        behaviorPilot.riskExpStim3 = riskExpStim;
        behaviorPilot.taskSequence3 = taskSequence;
        behaviorPilot.taskSeqNum3 = taskSeqNum;
        
        exp_RiskComp_outside(subCode, run, nameSub, riskExpStim, inputTrials2, windowmode, screenResolution, bg, openFolder, subFolder, taskSequence, taskSeqNum)
        
    end
end

%%% Save all the parameters here.
behaviorPilot.drive = drive;
behaviorPilot.mainFolder = mainFolder;
behaviorPilot.openFolder = openFolder;
behaviorPilot.subFolder = subFolder;
behaviorPilot.windowmode = windowmode;
behaviorPilot.screenResolution = screenResolution;
behaviorPilot.bg = bg;
behaviorPilot.sequence = sequence;

if subCode < 10
    save([openFolder subFolder '\' 'sub_0' num2str(subCode) '_' nameSub '_pilPar' '.mat'],'behaviorPilot');
elseif subCode >= 10
    save([openFolder subFolder '\' 'sub_' num2str(subCode) '_' nameSub '_pilPar' '.mat'],'behaviorPilot');
end

%payment_RiskComp(subCode, nameSub, openFolder, subFolder, windowmode, screenResolution, bg)

%%% Note:
%%% I  might want to add an analysis pipeline to check subject responses.




