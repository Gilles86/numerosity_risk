function exp_RiskComp_fMRI(subCode, run, nameSub, inputTrials, windowmode, screenResolution, bg, openFolder, subFolder, taskSequence, taskSeqNum)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% STUDY: PREDICTING RISK ATTITUDES FROM THE PRECISION OF NEURAL NUMBER REPRESENTATION
% This script runs the magnitude comparison task inside the fMRI

% TASK: Participants have to decide whether one pile of coins is greater
% than the other. The stimuli (pile of coins) are presented sequentially.
% One the second stimulus is presented, participants make a decision.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

edfn = 1;
EyeTracking_name = edfn; % Label edfn name (8 char.)
dummy = 1;
isFMRI = [];

rad_fix_diff = 210;

%%%%%%%%%%%%%%%%%%%%%%%
%% GENERATE STIMULI
%%%%%%%%%%%%%%%%%%%%%%%

expType = 1;        % Calls in Magnitude Comparison Task
startStim = 5;      % The minimum reference value for the sure bet
maxStim = 28;       % The maximum reference value for the sure bet
numRoot = 2;        % The root that creates the sequence spacing for the risky bets
rngMin = -6;        % The minimum range for the risky bets
rngMax = 6;         % The maximum range for the risky bets
rngSpc = 2;         % The range spacing
probability = 1;    % The probability

%%%%%%%%%%%%%%%%%%%
%% LOAD PARADIGM
%%%%%%%%%%%%%%%%%%%
gen_dotMagRisk_fMRI(subCode, run, nameSub, expType, inputTrials, startStim, numRoot, maxStim, rngMin, rngMax, rngSpc, probability, openFolder, subFolder);

if subCode < 10
    load([openFolder subFolder '\' 'sub_0' num2str(subCode) '_run_0' num2str(run) '_' nameSub '_genPar_0'  num2str(expType) '_magComp' '.mat']);
elseif subCode >= 10
    load([openFolder subFolder '\' 'sub_' num2str(subCode) '_run_0' num2str(run) '_' nameSub '_genPar_0'  num2str(expType) '_magComp' '.mat']);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% WINDOW AND RESOLUTION PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%windowmode = 0;                 % 0: small window; 1: full screen
%screenResolution = 3;           % 1=640x480, 2=800x600, 3=1024x768
%bg = 0;

if screenResolution ==1  screenWidth = 640; screenHeight = 480;
elseif screenResolution ==2  screenWidth = 800; screenHeight = 600;
else   screenWidth = 1024; screenHeight = 768;
end

%%%%%%%%%%%%%%%%%%%%%%%%
%% INPUT ERROR CHECK
%%%%%%%%%%%%%%%%%%%%%%%%

if ~dummy                              % is with eyetracker
    et = EyeTracker();
    et.init(0);
    et.calibrate();
    et.openFile(EyeTracking_name);     % up to 8 chars
else
    et = [];
end

if ~exist('isFMRI', 'var') || isempty(isFMRI)
    isFMRI = false;
else
    isFMRI = logical(isFMRI(1));
    fMRIFlag = 1;
end

%for MRI trigger:
if ~isempty(isFMRI)
    config_serial(1,19200);    % to connect to external devices, e.g. MR
else
    config_keyboard
end
%or just:
%config_serial(1,19200);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% START COGENT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
config_display(windowmode,screenResolution,[0 0 0], [bg bg bg]); % configure graphics window

config_log

start_cogent;
start_cogent_time = time;

%%% Create Folder
if subCode < 10
    config_results([openFolder subFolder '\' 'sub_0' num2str(subCode) '_' nameSub '_resPar_0'  num2str(expType) '_magComp' '_taskSeq_0' num2str(taskSequence) '.txt']);
elseif subCode >= 10
    config_results([openFolder subFolder '\' 'sub_' num2str(subCode) '_' nameSub '_resPar_0'  num2str(expType) '_magComp' '_taskSeq_0' num2str(taskSequence) '.txt']);
end

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MAGNITUDE COMPARISON DISPLAY PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fixationWaitDuration = 3000*ones(1,magRiskTrial.nTrials);
fixationStartDuration = 1000*ones(1,magRiskTrial.nTrials);                          % Duration of the red fixation cross
fixationCueResponseDuration = 500*ones(1,magRiskTrial.nTrials);                     % Duration of the coins

upperLimFixTime2 = 9000;                                                            % Upper bound of the ITI
lowerLimFixTime2 = 6000;                                                            % Lower bound of the ITI
fixDurations2 = randsample(lowerLimFixTime2:upperLimFixTime2,magRiskTrial.nTrials); % Duration of the ITI (jittered)

rewardDurations = 600*ones(1,magRiskTrial.nTrials);                                 % Duration of the green arrows
fixationResponseDuration = 2500*ones(1,magRiskTrial.nTrials);                       % Max duration for response


%%% (We might not need any breaks!)
% sessionBreaks = 5; % Includes a break before the start of the second task
% startInterval = 30;
% for i = 1:sessionBreaks
%     breakPeriods(i) = startInterval + startInterval*(i-1) ;
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FONT AND KEYBOARD PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Font = 'Arial';
FontSize = 30;

cgfont(Font,FontSize)

%------------------------
% Inputs
keysMap = getkeymap;
%itemUpKey = 78;    % Choose item up
%itemDownKey = 28;  % Choose item down
itemLeftKey = 75;   % Choose item up
itemRightKey = 77;  % Choose item down
enterKey = keysMap.Return;
escKey = 1;

sure_bet = magRiskTrial.s1_perm;
prob_bet = magRiskTrial.s2_perm;

%%% Version 1: Create random numbers following a given interval.
rad = zeros(magRiskTrial.nTrials,1);

for i = 1:magRiskTrial.nTrials
    radInterval = 150:10:210;
    radSequence = randperm(length(radInterval));
    rad(i) = radInterval(:,radSequence(:,1));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOAD SPRITES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% -------------------------------
% FIXATION START TRIAL (Sprite 1)
% -------------------------------
w = 0.7;
cgmakesprite(1,100,100,bg,bg,bg)
cgsetsprite(1)
cgpencol(155/255, 16/255, 16/255)                   % Draw a red cross
cgrect(0,0,4*w,20*w)
cgrect(0,0,20*w,4*w)
cgtrncol(1,'n')

% --------------------------------
% CREATE STIMULI SPRITE (Sprite 2)
% --------------------------------
cgtrncol(2,'n')
cgsetsprite(2)
resize = 0.030; %0.015;
%resize = 0.0140; %0.015;
I = imresize(imread('1franc_new2.png'),resize);
%I = imadjust(I, [0.01 0.8], [0.6 1.0]);
imwrite(I, 'coin2.png');
loadpict('coin2.png',2,0,0);

% ----------------------------------------------
% CREATE GREEN FIXATION FOR GO SPRITE (Sprite 3)
% ----------------------------------------------
cgmakesprite(3,100,100,bg,bg,bg)
cgsetsprite(3)
cgpencol(49/255, 135/255, 39/255)                     % Draw a green cross
cgrect(0,0,4*w,20*w)
cgrect(0,0,20*w,4*w)
cgtrncol(3,'n')

% ---------------------------------------
% CREATE RIGHT LETTER RESPONSE (Sprite 6)
% ---------------------------------------
cgmakesprite(6,50,50,bg,bg,bg)
cgsetsprite(6)
cgfont('Times',30)
cgpencol(49/255, 135/255, 39/255)
cgtext('r',0,3)

% --------------------------------------
% CREATE LEFT LETTER RESPONSE (Sprite 7)
% --------------------------------------
cgmakesprite(7,50,50,bg,bg,bg)
cgsetsprite(7)
cgfont('Times',30)
cgpencol(49/255, 135/255, 39/255)
cgtext('l',0,0)

% --------------------------------------------
% CREATE WHITE FIXATION CROSS (WAITING PERIOD)
% --------------------------------------------
cgmakesprite(8,100,100,bg,bg,bg)
cgsetsprite(8)
cgpencol(1, 1, 1)                   % Draw a red cross
cgrect(0,0,4*w,20*w)
cgrect(0,0,20*w,4*w)
cgtrncol(8,'n')

% --------------------------------------------
% REST PERIODS
% --------------------------------------------
cgmakesprite(40,screenWidth,screenHeight,bg,bg,bg)
cgsetsprite(40)
cgfont('Arial',30)
cgpencol(1,1,1)
cgtext('Please rest your eyes and hands.',0,30)
cgtext('We will resume the experiment momentarily.',0,-30)
cgmakesprite(41,screenWidth,screenHeight,bg,bg,bg)
cgsetsprite(41)
cgfont('Arial',30)
cgpencol(1,1,1)
cgtext('Press Enter to continue...',0,0)

%*************************************************************
% Set sprite zero and set the pen colour to white

abort = false;

if ~dummy
    et.startRecording();
    et.setAnalyseMessage(sprintf('scr_pix_%d_%d', screenWidth, screenHeight));
end

cgsetsprite(0)
cgpencol(1,1,1)
%*************************************************************

%%%%%%%%%%%%%%%%%%%%%%%%
%%% BEHAVARIOAL TASK %%%
%%%%%%%%%%%%%%%%%%%%%%%%

abort = false;

if ~dummy
    et.startRecording();
    et.setAnalyseMessage(sprintf('scr_pix_%d_%d', screenWidth, screenHeight));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% PROMPT START OF THE TASK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cgflip(bg,bg,bg)                                % Instructions 1
cgfont('Arial',25)
cgpencol(1,1,1)
cgtext(['TASK ' num2str(taskSeqNum)],0,25)
cgtext(['Press Enter to start'],0,-25)
cgflip(bg,bg,bg);

%%% Option: also change enterKey to spaceKey
[k,~,~] = waitkeydown(inf, enterKey);           % press Enter when ready to start with the experiment
if k(1) == 1
    logstring('aborted');
    stop_cogent;
    return;
end
waitTime(50/1000);                                       % just to provide a smooth transition to the next presentation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% INSTRUCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cgflip(bg,bg,bg)                                % Instructions 2
cgfont('Arial',25)
cgpencol(1,1,1)
cgtext(['TASK ' num2str(taskSeqNum) ' INSTRUCTIONS:'],0,25)
cgtext(['Press the LEFT ARROW if the first pile of coins is greater.'],0,-25)
cgtext(['Press the RIGHT ARROW if the second pile of coins is greater.'],0,-75)
cgtext(['Press ENTER to start.'],0,-175)
cgflip(bg,bg,bg);

[k,~,~] = waitkeydown(inf, enterKey);           % press Enter when ready to start with the experiment
if k(1) == 1
    logstring('aborted');
    stop_cogent;
    return;
end

%cgflip(bg,bg,bg)

%%%%%%%%%%%%%%%%%%%%%%%
%% FMRI TRIGGER
%%%%%%%%%%%%%%%%%%%%%%%
if isFMRI == 1
    startOfExperimentTime = time
    [byte, startOfExperimentTime, n] = waitserialbyte(1,120000000000, 53);
    if ~dummy
        et.setAnalyseMessage(sprintf('%s','fMRIon'));
    end
else
    startOfExperimentTime = time
    disp('START OF EXPERIMENT !!!!')
end

%start_t0 = time;
%startDuration = time - start_t0;
%magRiskTrial.startDuration = startDuration;

startONSETS = time;
if ~dummy
    et.setAnalyseMessage(sprintf('%s','Experiment_on'));
end
logstring('startonsets')

%%%%%%%%%%%%%%%%%%%%%%%%%%5%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% TRIAL LOOP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~abort
    for i = 1:magRiskTrial.nTrials
        
        %%% Trialwise eye-fix variables to evaluate
        goodFixation = 1;
        
        tic;
        while toc < 0.97
            %%% % fixcheck
            if ~dummy
                isFixating = fixate(screenWidth, screenHeight, 0, 0, rad_fix_diff);
                if isFixating ~= 1
                    goodFixation = 0;
                end
            else
                dummyfix = mousefixated(0, 0, rad_fix_diff);
                if dummyfix ~= 1
                    goodFixation = 0;
                end
            end
            %%%
        end
        
        % -------------------------
        % Set the keypad responses
        % -------------------------
        
        correct = magRiskTrial.correct_perm;
        
        if correct(i) == 1
            targetKey = itemLeftKey;
        elseif correct(i) == -1
            targetKey = itemRightKey;
        elseif correct(i) == 0
            targetKey = itemRightKey;
        elseif correct(i) == 0
            targetKey = itemLeftKey;
        end
        %%% msg for the start of the trial
        
        sample_onset = time;                % takes the onset of ITI here, current value is used for calculating ITI and overwritten during the next trial etc
        %sample_onset_time(iSample) = time;
        trial_onset_time(i) = time;
        thisONSET(i) = time - startONSETS;
        clearkeys;
        
        % fixed_t0 = time;  % From old script
        if ~dummy
            et.setAnalyseMessage(sprintf('%d_%s', i, 'trialon'));
        end
        logstring('trialon')
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% START OF TRIAL CUE (WHITE FIXATION CROSS)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        trialSequence2 = [0 magRiskTrial.trialSequence];
        
        currTrialTime(i) = trialSequence2(i+1) - trialSequence2(i);
        currLapseTime(i) = trialSequence2(i);
        trialOnsetTime1(i) = time;
        trialOnset1(i) = trialOnsetTime1(i);
        
        %wait(fixationWaitDuration(randTrial));
        
        %while (time < trialOnsetTime1(i) + currTrialTime(i)) && time >  currLapseTime(i) - startOfExperimentTime
        
        cueOnset1(i) = time;
        while (time < cueOnset1(i) + fixationWaitDuration(i));
            cgdrawsprite(8,0,0);    % Draw white fixation cross
            cgflip(bg,bg,bg);
            if ~dummy
                et.setAnalyseMessage(sprintf('%d_%s', i, 'wfx'));
            end
        end
        cueOffset1(i) = time;
        cueDiff1(i) = cueOffset1(i) - cueOnset1(i);
        %waitTime(fixationWaitDuration(i)/1000);
        %trialOnsetTime1(i) = time;
        %cueOnset(i) = time - trialOnsetTime1(i);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% START OF STIMULUS CUE (RED FIXATION CROSS)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        cueOnset2(i) = time;
        while (time < cueOnset2(i) + fixationStartDuration(i));
            cgdrawsprite(1,0,0);    % Draw red fixation cross
            cgflip(bg,bg,bg);
            if ~dummy
                et.setAnalyseMessage(sprintf('%d_%s', i, 'rfx'));
            end
        end
        cueOffset2(i) = time;
        cueDiff2(i) = cueOffset2(i) - cueOnset2(i);
        %waitTime(fixationStartDuration(i)/1000);
        %trialOnsetTime2(i) = time;
        %cueOnsetPrep(i) = time - trialOnsetTime2(i);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% FIRST STIMULUS PRESENTATION
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Draw the points for the constant points
        
        [xConst,yConst] = rand_grid2(magRiskTrial.s1_perm(i), 8, 0, 0, rad(i), expType);
        cgdrawsprite(1,0,0);
        stimOnset1(i) = time;
        while time < ( stimOnset1(i) + fixationCueResponseDuration(i) );
            
            % draw the points for the constant points
            for s = 1:magRiskTrial.s1_perm(i);
                cgdrawsprite(2,xConst(s),yConst(s));
                %cgpencol(1,1,1)
                %cgfont(Font,FontSize)
                %cgtext(num2str(sure_bet(i)), 0, 0)
                if ~dummy
                    et.setAnalyseMessage(sprintf('%d_%d_%s',i,s,'stm1'));   % eyetracker message - trial and frame number
                end
                
            end
            
            cgflip(bg,bg,bg);
            cgdrawsprite(1,0,0);
            
            %%% % fixcheck
            if ~dummy
                isFixating = fixate(screenWidth, screenHeight, 0, 0, rad_fix_diff);
                if isFixating ~= 1
                    goodFixation = 0;
                end
            else
                dummyfix = mousefixated(0, 0, rad_fix_diff);
                if dummyfix ~= 1
                    goodFixation = 0;
                end
            end
            %%%
            
        end
        stimOffset1(i) = time;
        stimDiff1(i) = stimOffset1(i) - stimOnset1(i);
        
        cgflip(bg,bg,bg);
        %firstStim_t0(i) = time;
        %waitTime(fixationCueResponseDuration(i)/1000); %% Create a while loop instead.
        %firstStimDuration(i) = time - firstStim_t0(i);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% STIMULUS INTERVAL
        %%%%%%%%%%%%%%%%%%%5%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        isiStimOnset(i) = time;
        fxDurations2(i) = magRiskTrial.fixDurations2(i);
        while time < isiStimOnset(i) + fxDurations2(i)
            
            cgdrawsprite(1,0,0);
            
            if ~dummy
                et.setAnalyseMessage(sprintf('%d_%s',i,'isi'));   % eyetracker message - trial and frame number
            end
        end
        isiStimOffset(i) = time;
        isiStimDiff(i) = isiStimOffset(i) - isiStimOnset(i);
        %waitTime(fixDurations2(i)/1000);
        %isimStimDuration(i) = time - isiStim_t0(i);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % SECOND STIMULUS PRESENTATION
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [xStim,yStim] = rand_grid2(magRiskTrial.s2_perm(i), 8, 0, 0, rad(i), expType);
        cgdrawsprite(1,0,0);
        stimOnset2(i) = time;
        while time < ( stimOnset2(i) + fixationCueResponseDuration(i) );
            % draw the points for the constant points
            for s = 1:magRiskTrial.s2_perm(i);
                cgdrawsprite(2,xStim(s),yStim(s));
                %cgpencol(1,1,1)
                %cgfont(Font,FontSize)
                %cgtext(num2str(prob_bet(i)), 0, 0)
                
                if ~dummy
                    et.setAnalyseMessage(sprintf('%d_%d_%s',i,s,'stm2'));   % eyetracker message - trial and frame number
                end
                
            end
            
            cgflip(bg,bg,bg);
            cgdrawsprite(1,0,0);
            
            %%% % fixcheck
            if ~dummy
                isFixating = fixate(screenWidth, screenHeight, 0, 0, rad_fix_diff);
                if isFixating ~= 1
                    goodFixation = 0;
                end
            else
                dummyfix = mousefixated(0, 0, rad_fix_diff);
                if dummyfix ~= 1
                    goodFixation = 0;
                end
            end
            %%%
            
        end
        
        stimOffset2(i) = time;
        stimDiff2(i) = stimOffset2(i) - stimOnset2(i);
        
        cgflip(bg,bg,bg);
        
        %secondStim_t0(i) = time;
        %waitTime(fixationCueResponseDuration(i)/1000);
        %secondStimDuration(i) = time - secondStim_t0(i);
        
        cgdrawsprite(1,0,0);
        cgflip(bg,bg,bg);
        waitTime(200/1000);
        
        % Do not remove dots when all stimuli are drawn
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % RESPONSE FIXATION CUE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        cgdrawsprite(3,0,0);
        cgflip(bg,bg,bg);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % RESPONSE
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        [kd]=cgkeymap;
        kd(itemLeftKey) = 0;
        kd(itemRightKey) = 0;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        response_t0(i) = time;
        
        while ~kd(itemLeftKey) && ~kd(itemRightKey)
            
            if time-response_t0(i)>fixationResponseDuration(i) % subject did not choose before fixationResponseDuration
                addresults(i, 'miss', -1, 0);
                magRiskTrial.accuracy(i) = -1;
                magRiskTrial.pressedKey(i) = -1;
                magRiskTrial.rt(i) = -1;
                break
                
                if ~dummy
                    et.setAnalyseMessage(sprintf('%d_%s',i, 'noResp'));   % eyetracker message - trial and frame number
                end
                
                %%% % fixcheck
                if ~dummy
                    isFixating = fixate(screenWidth, screenHeight, 0, 0, rad_fix_diff);
                    if isFixating ~= 1
                        goodFixation = 0;
                    end
                else
                    dummyfix = mousefixated(0, 0, rad_fix_diff);
                    if dummyfix ~= 1
                        goodFixation = 0;
                    end
                end
                
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% READ BUTTON PRESS
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            [kd,kp]=cgkeymap;
            kp = find(kp);
            
            if length(kp)==1
                
                rt(i) = time-response_t0(i);
                magRiskTrial.rt(i) = rt(i);
                fprintf('Key:%d \n',kp(1));
                magRiskTrial.pressedKey(i) = kp(1);
                
                if kp==targetKey
                    
                    if ~dummy
                        et.setAnalyseMessage(sprintf('%d_%s',i, 'Resp01'));   % eyetracker message - trial and frame number
                    end
                    
                    %%% % fixcheck
                    if ~dummy
                        isFixating = fixate(screenWidth, screenHeight, 0, 0, rad_fix_diff);
                        if isFixating ~= 1
                            goodFixation = 0;
                        end
                    else
                        dummyfix = mousefixated(0, 0, rad_fix_diff);
                        if dummyfix ~= 1
                            goodFixation = 0;
                        end
                    end
                    
                    magRiskTrial.accuracy(i) = 1;
                    outMissHit = 'corr';
                    if kp(1) == itemRightKey
                        cgdrawsprite(6,0,0)
                    else
                        cgdrawsprite(7,0,0)
                    end
                    cgflip(bg,bg,bg);
                    
                    waitTime(rewardDurations(i)/1000);
                    
                    cgdrawsprite(8,0,0);    % Revert back to white fixation cross.
                    % cgdrawsprite(1,0,0);
                    waitTime(300/1000);
                    cgflip(bg,bg,bg);
                else
                    
                    if ~dummy
                        et.setAnalyseMessage(sprintf('%d_%s',i, 'Resp00'));   % eyetracker message - trial and frame number
                    end
                    
                    %%% % fixcheck
                    if ~dummy
                        isFixating = fixate(screenWidth, screenHeight, 0, 0, rad_fix_diff);
                        if isFixating ~= 1
                            goodFixation = 0;
                        end
                    else
                        dummyfix = mousefixated(0, 0, rad_fix_diff);
                        if dummyfix ~= 1
                            goodFixation = 0;
                        end
                    end
                    
                    magRiskTrial.accuracy(i) = 0;
                    outMissHit = 'incorr';
                    if kp(1) == itemRightKey
                        cgdrawsprite(6,0,0)
                    else
                        cgdrawsprite(7,0,0)
                    end
                    cgflip(bg,bg,bg);
                    
                    waitTime(rewardDurations(i)/1000);
                    
                    cgdrawsprite(8,0,0);    % Revert back to white fixation cross.
                    waitTime(300/1000);
                    % cgdrawsprite(1,0,0);
                    cgflip(bg,bg,bg);
                end
                addresults(i, outMissHit, rt, kp);
                % After decision is made draw red frame over chosen item
            end
            
            
        end
        
        if kp == 75
            magRiskTrial.leftRight(i) = 1;
        elseif kp == 77
            magRiskTrial.leftRight(i) = -1;
        elseif kp ~= 75 | kp ~= 78
            magRiskTrial.leftRight(i) = 0;
        end
        
        magRiskTrial.rad(i) = rad(i);
        %magRiskTrial.trialAccumulation = cumsum([magRiskTrial.trialAccumulation, magRiskTrial.trialDuration(i)]);
        
        if ~dummy
            if goodFixation == 0
                et.setAnalyseMessage(sprintf('%d_%s',i,'badfixtrial'));
            end
        end
        
        % Timing Variables
        response_end(i) = time;
        magRiskTrial.trialDuration(i) = toc;
        
        %end
    end
    
    %breakDuration = find(breakDuration > 0);
    %magRiskTrial.breakDuration = breakDuration;
    
    magRiskTrial.cueOnset1 = cueOnset1';
    magRiskTrial.cueOffset1 = cueOffset1';
    magRiskTrial.cueOnset2 = cueOnset2';
    magRiskTrial.cueOffset2 = cueOffset2';
    magRiskTrial.stimOnset1 = stimOnset1';
    magRiskTrial.stimOffset1 = stimOffset1';
    magRiskTrial.isiStimOnset = isiStimOnset';
    magRiskTrial.isiStimOffset = isiStimOffset';
    magRiskTrial.stimOnset2 = stimOnset2';
    magRiskTrial.stimOffset2 = stimOffset2';
    magRiskTrial.response_t0 = response_t0';
    magRiskTrial.response_end = response_end';
    magRiskTrial.cueDiff1 = cueDiff1';
    magRiskTrial.cueDiff2 = cueDiff2';
    magRiskTrial.stimDiff1 = stimDiff1';
    magRiskTrial.isiStimDiff = isiStimDiff';
    magRiskTrial.stimDiff2 = stimDiff2';
    
    
    magRiskTrial.trialAccumulation = cumsum(magRiskTrial.trialDuration);
    selTrial = magRiskTrial.accuracy(magRiskTrial.selectedTrial);
    
    
    magRiskTrial.dataFile = [magRiskTrial.cueOnset1...    % dataFile(1)
        magRiskTrial.cueOffset1...           % dataFile(2)
        magRiskTrial.cueOnset2...            % dataFile(3)
        magRiskTrial.cueOffset2...           % dataFile(4)
        magRiskTrial.stimOnset1...           % dataFile(5)
        magRiskTrial.stimOffset1...          % dataFile(6)
        magRiskTrial.isiStimOnset...         % dataFile(8)
        magRiskTrial.isiStimOffset...        % dataFile(9)
        magRiskTrial.stimOnset2...           % dataFile(10)
        magRiskTrial.stimOffset2...          % dataFile(11)
        magRiskTrial.response_t0...          % dataFile(12)
        magRiskTrial.response_end...         % dataFile(13)
        magRiskTrial.cueDiff1...             % dataFile(14)
        magRiskTrial.cueDiff2...
        magRiskTrial.stimDiff1...
        magRiskTrial.isiStimDiff...
        magRiskTrial.stimDiff2...
        magRiskTrial.rt/1000 ...               % dataFile(12)
        magRiskTrial.trialAccumulation...      % dataFile(9)
        magRiskTrial.trialDuration...          % dataFile(10)       
        magRiskTrial.accuracy...               % dataFile(13)
        sure_bet...                            % dataFile(14)
        prob_bet...                            % dataFile(15)
        magRiskTrial.s2Prob_perm ...           % dataFile(16)
        magRiskTrial.diffVal_perm ...          % dataFile(17)
        magRiskTrial.rad'...                   % dataFile(18)
        magRiskTrial.correct_perm...           % dataFile(19)
        magRiskTrial.leftRight];               % dataFile(20)
    
    %%%%%%%%%%%%%%%%%%
    %% SAVE FILES
    %%%%%%%%%%%%%%%%%%
    
    % Naming:
    % subject_01_MG_resultsParadigm_01_magComp.mat (if expType = 1)
    % subject_01_MG_resultsParadigm_02_riskComp_stim_01.mat (if expType = 2)
    
    if subCode < 10
        save([openFolder subFolder '\' 'sub_0' num2str(subCode) '_run_0' num2str(run) '_' nameSub '_resPar_0'  num2str(expType) '_magComp' '_taskSeq_0' num2str(taskSequence) '.mat'],'magRiskTrial');
    elseif subCode >= 10
        save([openFolder subFolder '\' 'sub_' num2str(subCode) '_run_0' num2str(run) '_' nameSub '_resPar_0'  num2str(expType) '_magComp' '_taskSeq_0' num2str(taskSequence) '.mat'],'magRiskTrial');
    end
    
    %% needs some additional time with large files to be transfered from one computer to another:
    if ~dummy
        et.stopRecording();
        waitTime(0.2);
        et.closeFile();
        waitTime(0.2);
        et.receiveFile();
        waitTime(0.2);
        et.shutdown();
        waitTime(0.2);
    end
    
    endOfExperiment = time - startOfExperimentTime
    
    cgshut()
    
    stop_cogent;
    
    return
end

cgflip(bg,bg,bg)                                % Instructions 1
cgfont('Arial',25)
cgpencol(1,1,1)
cgtext(['END OF THE TASK'],0,0)
cgflip(bg,bg,bg);

end

function abort = conditionalWait(timeout)

%% CONSTANTS
ABORT_KEY = 1; % ESC Key

%% CHECK INPUT
abort = false;

%% WAIT FOR KEY PRESS OR TIME OUT
tic;
while (toc < timeout)
    keyState = cgkeymap();
    currentlyPressedKey = find(keyState);
    if ~isempty(currentlyPressedKey)
        if currentlyPressedKey == ABORT_KEY
            abort = true;
            break;
        end
    end
end
end



%%%%%%%%%%%%%%%%%%%%%%%%
%% LOAD FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%
function waitTime(timeout)
timerID = tic();
%busy loop
while toc(timerID) < timeout,end
end

function dummyfix = mousefixated(fixX, fixY, radialAllowance)
[mouseX, mouseY, ~] = cgmouse();
dummyfix = sqrt((mouseX-fixX).^2+(mouseY-fixY).^2) < radialAllowance;
end

function isFixating = fixate(screenWidth, screenHeight, fixX, fixY, radialAllowance)
%evt = et.EventData;
evt = Eyelink('newestfloatsample'); % what Marcus used, and works
eyeX = evt.gx(2) - screenWidth / 2; % 1 - left eye, 2 - right eye
eyeY = evt.gy(2)- screenHeight / 2;
isFixating = sqrt((eyeX-fixX).^2+(eyeY-fixY).^2) < radialAllowance;
end
