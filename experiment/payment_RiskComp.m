function payment_RiskComp(subCode, nameSub, openFolder, subFolder, windowmode, screenResolution, bg)

%%% Load the Sequence Parameter
% if subCode < 10
%     load([openFolder subFolder '\' 'subject_0' num2str(subCode) '_' nameSub '_pilotParam' '.mat'],'behaviorPilot');
% elseif subCode >= 10
%     load([openFolder subFolder '\' 'subject_' num2str(subCode) '_' nameSub '_pilotParam' '.mat'],'behaviorPilot');
% end
% 
% % Load Magnitude Comparison Task
% expType = 1;
% taskSequence = 1;
% if subCode < 10
%     load([openFolder subFolder '\' 'subject_0' num2str(subCode) '_' nameSub '_resultsParadigm_0'  num2str(expType) '_magComp' '_taskSeq_0' num2str(taskSequence) '.mat'],'magRiskTrial');
% elseif subCode >= 10
%     load([openFolder subFolder '\' 'subject_' num2str(subCode) '_' nameSub '_resultsParadigm_0'  num2str(expType) '_magComp' '_taskSeq_0' num2str(taskSequence) '.mat'],'magRiskTrial');
% end

if subCode < 10
    load([openFolder subFolder '\' 'sub_0' num2str(subCode) '_' nameSub '_pilPar' '.mat'],'behaviorPilot');
elseif subCode >= 10
    load([openFolder subFolder '\' 'sub_' num2str(subCode) '_' nameSub '_pilPar' '.mat'],'behaviorPilot');
end

% Load Magnitude Comparison Task
expType = 1;
taskSequence = 1;
if subCode < 10
    load([openFolder subFolder '\' 'sub_0' num2str(subCode) '_' nameSub '_resPar_0'  num2str(expType) '_magComp' '_taskSeq_0' num2str(taskSequence) '.mat'],'magRiskTrial');
elseif subCode >= 10
    load([openFolder subFolder '\' 'sub_' num2str(subCode) '_' nameSub '_resPar_0'  num2str(expType) '_magComp' '_taskSeq_0' num2str(taskSequence) '.mat'],'magRiskTrial');
end

for i = 1:magRiskTrial.nTrials
    if magRiskTrial.dataFile(i,4) > 0
        MagComp(i) = magRiskTrial.dataFile(i,4);
    end
end
sumMagComp = sum(MagComp);
paymentMagComp = 0.20*sumMagComp;

sequence = behaviorPilot.sequence;

% Load Risky Decision Making Task
expType = 2;
riskComp1 = [];
riskComp2 = [];
if subCode < 10
    for blockSeq = 1:2
        if sequence(blockSeq) == 1
            riskExpStim = 2;
            taskSequence = blockSeq;
            riskComp1 = load([openFolder subFolder '\' 'sub_0' num2str(subCode) '_' nameSub '_resPar_0'  num2str(expType) '_riskComp_0' num2str(riskExpStim) '_taskSeq_0' num2str(taskSequence) '.mat'],'magRiskTrial');
        elseif sequence(blockSeq) == 2
            riskExpStim = 3;
            taskSequence = blockSeq;
            riskComp2 = load([openFolder subFolder '\' 'sub_0' num2str(subCode) '_' nameSub '_resPar_0'  num2str(expType) '_riskComp_0' num2str(riskExpStim) '_taskSeq_0' num2str(taskSequence) '.mat'],'magRiskTrial');
        end
    end
elseif subCode >= 10
    if sequence(blockSeq) == 1
        riskExpStim = 2;
        taskSequence = blockSeq;
        riskComp1 = load([openFolder subFolder '\' 'sub_' num2str(subCode) '_' nameSub '_resPar_0'  num2str(expType) '_riskComp_0' num2str(riskExpStim) '_taskSeq_0' num2str(taskSequence) '.mat'],'magRiskTrial');
    elseif sequence(blockSeq) == 2
        riskExpStim = 3;
        taskSequence = blockSeq;
        riskComp2 = load([openFolder subFolder '\' 'sub_' num2str(subCode) '_' nameSub '_resPar_0'  num2str(expType) '_riskComp_0' num2str(riskExpStim) '_taskSeq_0' num2str(taskSequence) '.mat'],'magRiskTrial');
    end
end

% if subCode < 10
%     for blockSeq = 1:2
%         if sequence(blockSeq) == 1
%             riskExpStim = 2;
%             taskSequence = blockSeq;
%             riskComp1 = load([openFolder subFolder '\' 'subject_0' num2str(subCode) '_' nameSub '_resultsParadigm_0'  num2str(expType) '_riskComp_0' num2str(riskExpStim) '_taskSeq_0' num2str(taskSequence) '.mat'],'magRiskTrial');
%         elseif sequence(blockSeq) == 2
%             riskExpStim = 3;
%             taskSequence = blockSeq;
%             riskComp2 = load([openFolder subFolder '\' 'subject_0' num2str(subCode) '_' nameSub '_resultsParadigm_0'  num2str(expType) '_riskComp_0' num2str(riskExpStim) '_taskSeq_0' num2str(taskSequence) '.mat'],'magRiskTrial');
%         end
%     end
% elseif subCode >= 10
%     if sequence(blockSeq) == 1
%         riskExpStim = 2;
%         taskSequence = blockSeq;
%         riskComp1 = load([openFolder subFolder '\' 'subject_' num2str(subCode) '_' nameSub '_resultsParadigm_0'  num2str(expType) '_riskComp_0' num2str(riskExpStim) '_taskSeq_0' num2str(taskSequence) '.mat'],'magRiskTrial');
%     elseif sequence(blockSeq) == 2
%         riskExpStim = 3;
%         taskSequence = blockSeq;
%         riskComp2 = load([openFolder subFolder '\' 'subject_' num2str(subCode) '_' nameSub '_resultsParadigm_0'  num2str(expType) '_riskComp_0' num2str(riskExpStim) '_taskSeq_0' num2str(taskSequence) '.mat'],'magRiskTrial');
%     end
% end

%%% Add trial numbers
allDataFile = [riskComp1.magRiskTrial.dataFile; riskComp2.magRiskTrial.dataFile];

missedTrial = allDataFile(:,12) == -2;
allDataFile(missedTrial,:) = [];

trialNum = 1:length(allDataFile);
allDataFile = [allDataFile trialNum'];

TrialShuffle = randperm(length(trialNum));
selectTrial = TrialShuffle(length(trialNum));

sureLottery = allDataFile(selectTrial ,5);
probLottery = allDataFile(selectTrial ,6);

chosenLottery = allDataFile(selectTrial ,11)*allDataFile(selectTrial ,12);
if chosenLottery == 1
    lotteryOutcome = sureLottery;
elseif chosenLottery == -1
    lotteryOutcome = probLottery;
end



%%% The random trial selected was...
%%% In that trial, the sure bet was X and the probabilistic lottery was Y
%%% You chose


if screenResolution ==1  screenWidth = 640; screenHeight = 480;
elseif screenResolution ==2  screenWidth = 800; screenHeight = 600;
else   screenWidth = 1024; screenHeight = 768;
end

config_display(windowmode,screenResolution,[0 0 0], [bg bg bg]); % configure graphics window
config_log
config_keyboard;
start_cogent;

cgloadlib

csd = cggetdata('csd');
if csd.Version < 124
    disp('This program requires Cogent graphics v1.24 or later')
    return;
end

gsd = cggetdata('gsd');
ScrWid = gsd.ScreenWidth;
ScrHgh = gsd.ScreenHeight;

cgscale(ScrWid)


%FONT AND KEYBOARD PARAMETERS
Font = 'Arial';
FontSize = 30;

cgfont(Font,FontSize)

%------------------------
% Inputs
keysMap = getkeymap;
%itemUpKey = 78;    % Choose item up
%itemDownKey = 28;  % Choose item down
%itemLeftKey = 75;   % Choose item up
%itemRightKey = 77;  % Choose item down
enterKey = keysMap.Return;
escKey = 1;

cgflip(bg,bg,bg)
cgfont('Arial',25)
cgpencol(1,1,1)
%cgtext(['TASK 1'],0,25)

%%% Payment Instructions
cgtext(['RESULTS'],0,50)
cgtext(['Press Enter to see your results.'],0,0)
cgflip(bg,bg,bg);
waitkeydown(inf, enterKey);
cgflip(bg,bg,bg)
wait(2000)

cgflip(bg,bg,bg)
cgfont('Arial',25)
cgpencol(1,1,1)
cgtext(['TASK 1 RESULTS'],0,100)
cgtext(['In TASK 1, you made ' num2str(sumMagComp) ' correct responses.'],0,50)
cgtext(['Each correct response is worth 0.20 CHF.'],0,0)
cgtext(['For TASK 1, you will receive ' num2str(paymentMagComp) ' CHF.'],0,-50)
cgtext(['Press ENTER to continue.'],0,-100)
cgflip(bg,bg,bg);
waitkeydown(inf, enterKey);
cgflip(bg,bg,bg)
wait(2000)

cgflip(bg,bg,bg)
cgfont('Arial',25)
cgpencol(1,1,1)
cgtext(['TASKS 2 and 3 RESULTS'],0,150)
cgtext(['The trial that was randomly selected was Trial No. ' num2str(selectTrial) '.'],0,100)
cgtext(['In this trial, the SURE lottery was worth ' num2str(sureLottery) ' CHF.'],0,50)
cgtext(['For the PROBABILISTIC lottery, you have a 55% chance of receiving ' num2str(probLottery) ' CHF'],0,0)
cgtext(['and a 45% chance of receiving 0 CHF.'],0,-50)

%%%
if lotteryOutcome == sureLottery
    cgtext(['You decided to bet on the SURE lottery that was worth ' num2str(sureLottery) ' CHF.'], 0, -100)
    cgtext(['Press ENTER to determine your final payoff.'],0,-150)
    
    payoff = paymentMagComp + sureLottery;
    
    cgflip(bg,bg,bg);
    waitkeydown(inf, enterKey);
    cgflip(bg,bg,bg)
    wait(2000)
    
elseif lotteryOutcome == probLottery
    cgtext(['You decided to bet on the PROBABILISTIC lottery.'], 0, -100)
    cgtext(['Press ENTER to roll the die and determine your payoff.'],0,-150)
    
    cgflip(bg,bg,bg);
    waitkeydown(inf, enterKey);
    cgflip(bg,bg,bg)
    wait(2000)
    
    cgflip(bg,bg,bg)
    cgfont('Arial',25)
    cgpencol(1,1,1)
    cgtext(['Here you have a 100-sided die.'],0,100)
    cgtext(['If the number you roll is anywhere between 1 and 45, you will receive 0 CHF.'],0,50)
    cgtext(['But if the number you roll is anywhere between 46 and 100, you will receive ' num2str(probLottery) ' CHF.'],0,0)
    cgtext(['To roll the die, press ENTER.'],0,-100)
    cgflip(bg,bg,bg);
    waitkeydown(inf, enterKey);
    cgflip(bg,bg,bg)
    wait(2000)
    
    
    %%%%%
    diceRoll = randperm(100);
    
    for i = 1:50
        cgpencol(0.4,0.4,0.4)
        cgrect(0,0,80,80);
        cgpencol(0.6,0.6,0.6)
        cgrect(0,0,70,70);
        cgfont('Arial',25)
        cgpencol(1,1,1)
        cgtext(num2str(diceRoll(i)), 0, 0)
        cgflip(bg,bg,bg);
        wait(75);
    end
    
    for i = 51:75
        cgpencol(0.4,0.4,0.4)
        cgrect(0,0,80,80);
        cgpencol(0.6,0.6,0.6)
        cgrect(0,0,70,70);
        cgfont('Arial',25)
        cgpencol(1,1,1)
        cgtext(num2str(diceRoll(i)), 0, 0)
        cgflip(bg,bg,bg);
        wait(150);
    end
    
    for i = 76:95
        cgpencol(0.4,0.4,0.4)
        cgrect(0,0,80,80);
        cgpencol(0.6,0.6,0.6)
        cgrect(0,0,70,70);
        cgfont('Arial',25)
        cgpencol(1,1,1)
        cgtext(num2str(diceRoll(i)), 0, 0)
        cgflip(bg,bg,bg);
        wait(225);
    end
    
    for i = 96:100
        cgpencol(0.4,0.4,0.4)
        cgrect(0,0,80,80);
        cgpencol(0.6,0.6,0.6)
        cgrect(0,0,70,70);
        cgfont('Arial',25)
        cgpencol(1,1,1)
        cgtext(num2str(diceRoll(i)), 0, 0)
        cgflip(bg,bg,bg);
        wait(300);
    end
    
    wait(2000)
    
    cgflip(bg,bg,bg)
    cgfont('Arial',25)
    cgpencol(1,1,1)
    if diceRoll(100) < 46
        cgtext(['The number that was rolled from the die was ' num2str(diceRoll(100)) '.' ],0,50)
        cgtext(['You will receive 0 CHF.'],0,0)
        cgtext(['Press ENTER to determine your final payoff.'],0,-50)
        
        payoff = paymentMagComp;
        
    elseif diceRoll(100) > 45
        cgtext(['The number that was rolled from the die was ' num2str(diceRoll(100)) ],0,50)
        cgtext(['You will receive ' num2str(probLottery) ' CHF.'],0,0)
        cgtext(['Press ENTER to determine your final payoff.'],0,-50)
        
        payoff = paymentMagComp + probLottery;
        
    end
    
    cgflip(bg,bg,bg);
    waitkeydown(inf, enterKey);
    cgflip(bg,bg,bg)
    wait(2000)
    
end

cgflip(bg,bg,bg)
cgfont('Arial',25)
cgpencol(1,1,1)
cgtext(['Your final payoff is ' num2str(payoff) ' CHF.' ],0,0)
cgtext(['Press ENTER to close the experiment.' ],0,-50)
cgflip(bg,bg,bg);
waitkeydown(inf, enterKey);
cgflip(bg,bg,bg)
wait(2000)

%%% Don't forget to save. 

stop_cogent;
cgshut;

