function exp_RiskComp_outside(subCode, nameSub, expType, riskExpStim, inputTrials, windowmode, screenResolution, bg, openFolder, subFolder, taskSequence, taskSeqNum)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% STUDY: PREDICTING RISK ATTITUDES FROM THE PRECISION OF NEURAL NUMBER REPRESENTATION
% This script runs the risky choice task outside the scanner

% This script presents two lotteries: one sure bet and one probabilistic
% bet. Following Khaw, Li, and Woodford (2017), probabilities are fixed at
% a given proportion (55%/45%). Here we provide different presentation
% formats. In paticular, we have three types of stimuli:

% Risky Choice Experimental Stimuli...
% Case 1: Probabilities represented as bars.
% Case 2: Probabilities represented as pies. (Most preferred comparison)
% Case 3: Magnitudes presented as coins. (Most preferred)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

edfn = 1;
EyeTracking_name = edfn; % Label edfn name (8 char.)
dummy = [];
isFMRI = [];

rad_fix_diff = 210;

%%%%%%%%%%%%%%%%%%%%%%%
%% GENERATE STIMULI
%%%%%%%%%%%%%%%%%%%%%%%

expType = 2;
startStim = 5;
maxStim = 28;
numRoot = 2;
rngMin = 0;
rngMax = 8;
rngSpc = 1;
probability = 0.55;
run = [];

%%%%%%%%%%%%%%%%%%%
%% LOAD PARADIGM
%%%%%%%%%%%%%%%%%%%

% Task Sequence: Whether the magnitudes will be presented as either pies or
% coins.

switch taskSequence
    case 1 % Generate a new set of stimuli
        gen_dotMagRisk_behaviorPilot(subCode, run, nameSub, expType, inputTrials, startStim, numRoot, maxStim, rngMin, rngMax, rngSpc, probability, openFolder, subFolder);
        if subCode < 10
            load([openFolder subFolder '\' 'sub_0' num2str(subCode) '_' nameSub '_genPar_0'  num2str(expType) '_riskComp' '.mat']);
        elseif subCode >= 10
            load([openFolder subFolder '\' 'sub_' num2str(subCode) '_' nameSub '_genPar_0'  num2str(expType) '_riskComp' '.mat']);
        end
    case 2 % Especially for the second task, use the same set of stimuli
        if subCode < 10
            load([openFolder subFolder '\' 'sub_0' num2str(subCode) '_' nameSub '_genPar_0'  num2str(expType) '_riskComp' '.mat']);
        elseif subCode >= 10
            load([openFolder subFolder '\' 'sub_' num2str(subCode) '_' nameSub '_genPar_0'  num2str(expType) '_riskComp' '.mat']);
        end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% WINDOW AND RESOLUTION PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%windowmode = 0;                 % 0: small window; 1: full screen
%screenRes = 3;                  % 1=640x480, 2=800x600, 3=1024x768
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

% if ~exist('isFMRI', 'var') || isempty(isFMRI)
%     isFMRI = false;
% else
%     isFMRI = logical(isFMRI(1));
%     fMRIFlag = 1;
% end

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

if subCode < 10
    config_results([openFolder subFolder '\' 'sub_0' num2str(subCode) '_' nameSub '_resPar_0'  num2str(expType) '_riskComp_0' '_taskSeq_0' num2str(taskSequence) '.txt']);
elseif subCode >= 10
    config_results([openFolder subFolder '\' 'sub_' num2str(subCode) '_' nameSub '_resPar_0'  num2str(expType) '_riskComp_0' num2str(riskExpStim) '_taskSeq_0' num2str(taskSequence) '.txt']);
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RISKY CHOICE DISPLAY PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fixationResponseDuration = 3000*ones(1,magRiskTrial.nTrials);                                                    % Max duration for response
fixDurations = 750*ones(1,magRiskTrial.nTrials);
rewardDurations = 500*ones(1,magRiskTrial.nTrials);                                 % Duration of the green cross
transitDurations = 600*ones(1,magRiskTrial.nTrials);

if taskSequence == 1
    sessionBreaks = 5; % Includes a break before the start of the second task
    startInterval = 42;
    for i = 1:sessionBreaks
        breakPeriods(i) = startInterval + startInterval*(i-1) ;
    end
elseif taskSequence == 2
    sessionBreaks = 5; % Does not include a break before the start of the second task
    startInterval = 42 % 30; %40;
    for i = 1:sessionBreaks
        breakPeriods(i) = startInterval + startInterval*(i-1) ;
    end
    
end

% Size of the pie or position
switch riskExpStim
    case 2
        xShift = 180;
    case 3
        xShift = 270;
end

%%% Pie Stimuli
pie_size = 150;
number_shift = 35;

%%% Coins Stimuli
yShift = -40;
yshift_pie = 215;

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

if expType == 2                 % Only in the risky choice task that we need this.
    reset = magRiskTrial.reset;
end
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

% ----------------------
% CREATE STIMULI SPRITES
% ----------------------
switch riskExpStim
    
    % ----------------------------
    case 2 % Probabilities as Pies
        % ----------------------------
        % --------
        % Sure Bet
        % --------
        cgmakesprite(20,pie_size,pie_size,bg,bg,bg)
        cgsetsprite(20)
        cgpencol(0.85,0.85,0.85)
        cgellipse(0,0,pie_size,pie_size,'f')
        
        % -----------------
        % Probabilsitic Bet
        % -----------------
        % draw the points for the constant points
        % ----------
        % 55 percent
        % ----------
        cgmakesprite(211,pie_size,pie_size,bg,bg,bg)
        cgsetsprite(211)
        cgpencol(0.85,0.85,0.85)
        cgarc(0,0,pie_size,pie_size,252,90,'S')
        % ----------
        % 45 percent
        % ----------
        cgpencol(0.60,0.60,0.60)
        cgarc(0,0,pie_size,pie_size,90,252,'S')
        
        % -----------------
        % Probabilsitic Bet
        % -----------------
        % draw the points for the constant points
        % ----------
        % 45 percent
        % ----------
        cgmakesprite(212,pie_size,pie_size,bg,bg,bg)
        cgsetsprite(212)
        cgpencol(0.60,0.60,0.60)
        cgarc(0,0,pie_size,pie_size,288,90,'S')
        % ----------
        % 55 percent
        % ----------
        cgpencol(0.85,0.85,0.85)
        cgarc(0,0,pie_size,pie_size,90,288,'S')
        
        % -----------------------
    case 3 % Payoffs as Coins
        % -----------------------
        % Coins
        cgtrncol(2,'n')
        cgsetsprite(2)
        resize = 0.030;
        I = imresize(imread('1franc_new2.png'),resize);
        imwrite(I, 'coin2.png');
        loadpict('coin2.png',2,0,0);
        
        %                 cgtrncol(2,'n')
        %                 cgsetsprite(2)
        %                 resize = 0.035;
        %                 I = imresize(imread('coin.png'),resize);
        %                 imwrite(I, 'coin2.png');
        %                 loadpict('coin2.png',2,0,0);
        
        % --------
        % Sure Bet
        % --------
        cgmakesprite(20,60,60,bg,bg,bg)
        cgsetsprite(20)
        cgpencol(0.85,0.85,0.85)
        cgellipse(0,0,60,60,'f')
        
        % -----------------
        % Probabilistic Bet
        % -----------------
        cgmakesprite(211,60,60,bg,bg,bg)
        cgsetsprite(211)
        cgpencol(0.85,0.85,0.85)
        cgarc(0,0,60,60,252,90,'S')
        % ----------
        % 45 percent
        % -----------
        cgpencol(0.45,0.45,0.45)
        cgarc(0,0,60,60,90,252,'S')
        
        % -----------------
        % Probabilistic Bet
        % -----------------
        cgmakesprite(212,60,60,bg,bg,bg)
        cgsetsprite(212)
        cgpencol(0.45,0.45,0.45)
        cgarc(0,0,60,60,288,90,'S')
        % ----------
        % 45 percent
        % ----------
        cgpencol(0.85,0.85,0.85)
        cgarc(0,0,60,60,90,288,'S')
end

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

% ---------------
% REST PERIODS
% ---------------
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% PROMPT START OF THE TASK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cgflip(bg,bg,bg)                                        % Instructions 1
cgfont('Arial',25)
cgpencol(1,1,1)
cgtext(['TASK ' num2str(taskSeqNum)],0,25)
cgtext(['Press Enter to start'],0,-25)
cgflip(bg,bg,bg);

%%% Option: also change enterKey to spaceKey
[k,~,~] = waitkeydown(inf, enterKey);                   % press Enter when ready to start with the experiment
if k(1) == 1
    logstring('aborted');
    stop_cogent;
    return;
end
waitTime(50/1000);                                      % Just to provide a smooth transition to the next presentation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% INSTRUCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cgflip(bg,bg,bg)                                        % Instructions 2
cgfont('Arial',25)
cgpencol(1,1,1)
cgtext(['TASK ' num2str(taskSeqNum) ' INSTRUCTIONS:'],0,50)
cgtext(['Press the LEFT arrow if you choose the option on the left.'],0,0)
cgtext(['Press the RIGHT arrow if you choose the option on the right.'],0,-50)
cgtext(['By the end of the experiment, we will pay you based on the option you chose.'],0,-100)
cgtext(['Press ENTER to start.'],0,-175)
cgflip(bg,bg,bg);

[k,~,~] = waitkeydown(inf, enterKey);           % press Enter when ready to start with the experiment
if k(1) == 1
    logstring('aborted');
    stop_cogent;
    return;
end

instruct_t0 = time;
instructDuration = time - instruct_t0;
magRiskTrial.instructDuration = instructDuration;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FMRI TRIGGER (But not needed for now)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

startONSETS = time;
if ~dummy
    et.setAnalyseMessage(sprintf('%s','Experiment_on'));
end
logstring('startonsets')

%%%%%%%%%%%%%%%%%%%%%%%%%%5%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% TRIAL LOOP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~abort
    for randTrial = 1:magRiskTrial.nTrials
        
        
        %%% Trialwise eye-fix variables to evaluate
        goodFixation = 1;
        tic;
        
        i = randTrial;
        
        %-------------------------------
        % Set the keypad responses
        
        correct = magRiskTrial.correct_perm;
        
        if reset(i) == 1
            if correct(i) == 1
                targetKey = itemLeftKey;
            elseif correct(i) == -1
                targetKey = itemRightKey;
            end
        elseif reset(i) == -1
            if correct(i) == 1
                targetKey = itemRightKey;
            elseif correct(i) == -1
                targetKey = itemLeftKey;
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% (1) SET UP FIXATION CROSS AND PROBABILITIES
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        switch riskExpStim
            % -------------------------------------------------------------
            % (1.a) PROBABILITIES
            % -------------------------------------------------------------
            case 2 % Probabilities as Pies
                cueOnset1(i) = time
                while (time < cueOnset1(i) + fixDurations(i))
                    if reset(i) == -1
                        cgdrawsprite(20,-xShift*reset(i),0);
                        cgdrawsprite(211,xShift*reset(i),0);
                    elseif reset(i) == 1
                        cgdrawsprite(20,-xShift*reset(i),0);
                        cgdrawsprite(212,xShift*reset(i),0);
                    end
                    
                    % ---------------------------------------------------------
                    % (1.b) RED FIXATION CROSS
                    % ---------------------------------------------------------
                    
                    cgdrawsprite(1,0,0);
                    cgflip(bg,bg,bg);
                    
                    if ~dummy
                        et.setAnalyseMessage(sprintf('%d_%s', i, 'rfx'));
                    end
                    
                    %%% % fixcheck0
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
                cueOffset1(i) = time
                cueDiff1(i) = cueOffset1(i) - cueOnset1(i)
                
                fixed_t0 = time;
                firstCue_t0 = fixed_t0;
                
                %waitTime(fixDurations(i)/1000);
                
                firstCueDuration = time - firstCue_t0;
                magRiskTrial.firstCueDuration(i) = firstCueDuration;
                
                % ---------------------------------------------------------
                % (1.c) GREEN FIXATION CROSS TO PROMPT RESPONSE
                % ---------------------------------------------------------
                cueOnset2(i) = time
                while (time < cueOnset2(i) + transitDurations(i))
                    if reset(i) == -1                       %%% Probabilities
                        cgdrawsprite(20,-xShift*reset(i),0);
                        cgdrawsprite(211,xShift*reset(i),0);
                    elseif reset(i) == 1
                        cgdrawsprite(20,-xShift*reset(i),0);
                        cgdrawsprite(212,xShift*reset(i),0);
                    end
                    cgdrawsprite(3,0,0);                    %%% Response
                    cgflip(bg,bg,bg);
                    
                    if ~dummy
                        et.setAnalyseMessage(sprintf('%d_%s', i, 'gfx'));
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
                cueOffset2(i) = time
                cueDiff2(i) = cueOffset2(i) - cueOnset2(i)
                
                secondCue_t0 = time;
                %wait(transitDurations);
                
                secondCueDuration = time - secondCue_t0;
                magRiskTrial.secondCueDuration(i) = secondCueDuration;
                
                fixedDuration = time - fixed_t0;
                magRiskTrial.fixedDuration(i) = fixedDuration;
                
                % -------------------------------------------------------------
                % (2.a) PROBABILITIES
                % -------------------------------------------------------------
            case 3 % Coins
                
                cueOnset1(i) = time
                while (time < cueOnset1(i) + fixDurations(i))
                    if reset(i) == -1
                        cgdrawsprite(20,-xShift*reset(i),yshift_pie);
                        cgdrawsprite(211,xShift*reset(i),yshift_pie);
                    elseif reset(i) == 1
                        cgdrawsprite(20,-xShift*reset(i),yshift_pie);
                        cgdrawsprite(212,xShift*reset(i),yshift_pie);
                    end
                    
                    % ---------------------------------------------------------
                    % (2.b) RED FIXATION CROSS
                    % ---------------------------------------------------------
                    cgdrawsprite(1,0,0);
                    cgflip(bg,bg,bg);
                    
                    if ~dummy
                        et.setAnalyseMessage(sprintf('%d_%s', i, 'rfx'));
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
                cueOffset1(i) = time
                cueDiff1(i) = cueOffset1(i) - cueOnset1(i)
                
                fixed_t0 = time;
                firstCue_t0 = fixed_t0;
                
                %waitTime(fixDurations(i)/1000);
                
                firstCueDuration = time - firstCue_t0;
                magRiskTrial.firstCueDuration(i) = firstCueDuration;
                
                % ---------------------------------------------------------
                % (2.c) GREEN FIXATION CROSS TO PROMPT RESPONSE
                % ---------------------------------------------------------
                cueOnset2(i) = time
                while(time < cueOnset2(i) + transitDurations(i))
                    if reset(i) == -1
                        cgdrawsprite(20,-xShift*reset(i),yshift_pie);
                        cgdrawsprite(211,xShift*reset(i),yshift_pie);
                    elseif reset(i) == 1
                        cgdrawsprite(20,-xShift*reset(i),yshift_pie);
                        cgdrawsprite(212,xShift*reset(i),yshift_pie);
                    end
                    cgdrawsprite(3,0,0);
                    cgflip(bg,bg,bg);
                    
                    if ~dummy
                        et.setAnalyseMessage(sprintf('%d_%s', i, 'gfx'));
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
                cueOffset2(i) = time
                cueDiff2(i) = cueOffset2(i) - cueOnset2(i)
                
                %secondCue_t0 = time;
                
                %waitTime(transitDurations(i)/1000);
                
                %secondCueDuration = time - secondCue_t0;
                %magRiskTrial.secondCueDuration(i) = secondCueDuration;
                
                %fixedDuration = time - fixed_t0;
                %magRiskTrial.fixedDuration(i) = fixedDuration;
                
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% (2) PRESENT MAGNITUDES AS NUMBERS OR COINS
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % draw the points for the constant points
        switch riskExpStim
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % MAGNITUDE AS NUMBERS
            % -------------------------------------------------------------
            
            % ----------------------------
            case 2 % PROBABILISTIC BET
                % ----------------------------
                stimOnset(i) = time
                while(time < stimOnset(i) + 500)
                    if reset(i) == -1
                        cgdrawsprite(20,-xShift*reset(i),0);
                        cgdrawsprite(211,xShift*reset(i),0);
                        
                        % ------------
                        % 55 percent
                        % ------------
                        cgpencol(0.60,0.60,0.60)
                        cgfont(Font,FontSize)
                        cgtext(num2str(prob_bet(i)), xShift*reset(i) + number_shift, 0)
                        cgpencol(0.85,0.85,0.85)
                        cgfont(Font,FontSize)
                        cgtext(num2str(0), xShift*reset(i) - number_shift, 0)
                        
                    elseif reset(i) == 1
                        cgdrawsprite(20,-xShift*reset(i),0);
                        cgdrawsprite(212,xShift*reset(i),0);
                        
                        % ------------
                        % 55 percent
                        % ------------
                        cgpencol(0.60,0.60,0.60)
                        cgfont(Font,FontSize)
                        cgtext(num2str(prob_bet(i)), xShift*reset(i) - number_shift, 0)
                        cgpencol(0.85,0.85,0.85)
                        cgfont(Font,FontSize)
                        cgtext(num2str(0), xShift*reset(i) + number_shift, 0)
                    end
                    stimOffset(i) = time
                    stimDiff(i) = stimOffset(i) - stimOnset(i)
                    % ---------------------------------------------------------
                    % SURE BET
                    % ---------------------------------------------------------
                    cgpencol(0.60,0.60,0.60)
                    cgfont(Font,FontSize)
                    cgtext(num2str(sure_bet(i)), -xShift*reset(i), 0)
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % MAGNITUDE AS COINS
                % -------------------------------------------------------------
                
                % -------------------------
            case 3 % COINS STIMULI
                % -------------------------
                
                [xConst,yConst] = rand_grid2(sure_bet(i), 8, -xShift*reset(i), yShift, rad(i), expType); %rand_grid2(172, 8, -xShift*reset(i), yShift, rad(i));
                [xStim,yStim] = rand_grid2(prob_bet(i), 8, xShift*reset(i), yShift , rad(i), expType);   %rand_grid2(172, 8, xShift*reset(i), yShift , rad(i));
                
                stimOnset(i) = time
                while(time < stimOnset(i) + 500)
                    % Sure Bet
                    for s = 1:sure_bet(i); %1:172;
                        cgdrawsprite(2,xConst(s),yConst(s));
                    end
                    % Probabilistic Bet
                    for s = 1:prob_bet(i); %1:172;
                        cgdrawsprite(2,xStim(s),yStim(s));
                    end
                    
                    % ---------------
                    % PROBABILITIES
                    % ---------------
                    if reset(i) == -1
                        cgdrawsprite(20,-xShift*reset(i),yshift_pie);
                        cgdrawsprite(211,xShift*reset(i),yshift_pie);
                    elseif reset(i) == 1
                        cgdrawsprite(20,-xShift*reset(i),yshift_pie);
                        cgdrawsprite(212,xShift*reset(i),yshift_pie);
                    end
                end
                
                stimOffset(i) = time
                stimDiff(i) = stimOffset(i) - stimOnset(i)
                
        end
        
        % Do not remove dots when all stimuli are drawn
        % Draw go cross
        
        cgdrawsprite(3,0,0);
        cgflip(bg,bg,bg);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% (3) RESPONSE (CHOOSE EITHER LEFT OR RIGHT)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        [kd]=cgkeymap;
        kd(itemLeftKey) = 0;
        kd(itemRightKey) = 0;
        t0 = time;
        
        while ~kd(itemLeftKey) && ~kd(itemRightKey)
            
            while time-t0>fixationResponseDuration % subject did not choose before fixationResponseDuration
                addresults(i, 'miss', -1, 0);
                magRiskTrial.accuracy(i) = -1;
                magRiskTrial.pressedKey(i) = -1;
                magRiskTrial.rt(i) = -1;
                break
            end
            
            [kd,kp]=cgkeymap;
            kp = find(kp);
               
            if length(kp)==1
                rt = time-t0;
                magRiskTrial.rt(i) = rt;
                fprintf('Key:%d \n',kp(1));
                magRiskTrial.pressedKey(i) = kp(1);
                            
                if kp==targetKey
                    magRiskTrial.accuracy(i) = 1;
                    outMissHit = 'corr';
                    
                    % Show the selected option
                    if kp(1) == itemRightKey
                        
                        switch riskExpStim
                            case 2 % Probability as Pies
                                                        
                                if reset(i) == -1
                                    
                                    cgdrawsprite(20,-xShift*reset(i),0);
                                    cgdrawsprite(211,xShift*reset(i),0);
                                    
                                    % ----------------------
                                    % Probabilistic Bet Text
                                    % 55 percent
                                    % ----------------------
                                    cgpencol(0.60,0.60,0.60)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(prob_bet(i)), xShift*reset(i) + number_shift, 0)
                                    cgpencol(0.85,0.85,0.85)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(0), xShift*reset(i) - number_shift, 0)
                                    
                                elseif reset(i) == 1
                                    
                                    cgdrawsprite(20,-xShift*reset(i),0);
                                    cgdrawsprite(212,xShift*reset(i),0);
                                    
                                    % ----------------------
                                    % Probabilistic Bet Text
                                    % 55 percent
                                    % ----------------------
                                    cgpencol(0.60,0.60,0.60)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(prob_bet(i)), xShift*reset(i) - number_shift, 0)
                                    cgpencol(0.85,0.85,0.85)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(0), xShift*reset(i) + number_shift, 0)
                                end
                                
                                % -------------
                                % Sure Bet Text
                                % -------------
                                cgpencol(0.60,0.60,0.60)
                                cgfont(Font,FontSize)
                                cgtext(num2str(sure_bet(i)), -xShift*reset(i), 0)
                                
                                % ------------
                            case 3 % Coins
                                % ------------
                                
                                % --------
                                % Sure Bet
                                % --------
                                for s = 1:sure_bet(i);
                                    cgdrawsprite(2,xConst(s),yConst(s));
                                end
                                
                                % -----------------
                                % Probabilistic Bet
                                % -----------------
                                for s = 1:prob_bet(i);
                                    cgdrawsprite(2,xStim(s),yStim(s));
                                end
                                if reset(i) == -1
                                    cgdrawsprite(20,-xShift*reset(i),yshift_pie);
                                    cgdrawsprite(211,xShift*reset(i),yshift_pie);
                                elseif reset(i) == 1
                                    cgdrawsprite(20,-xShift*reset(i),yshift_pie);
                                    cgdrawsprite(212,xShift*reset(i),yshift_pie);
                                end
                        end
                        
                        cgdrawsprite(6,0,0)
                        cgflip(bg,bg,bg);  
                        waitTime(rewardDurations(i)/1000);
                        
                    else
                        
                        switch riskExpStim
                            case 2
                                if reset(i) == -1
                                    cgdrawsprite(20,-xShift*reset(i),0);
                                    cgdrawsprite(211,xShift*reset(i),0);
                                    
                                    % -----------------
                                    % Probabilistic Bet
                                    % 55 percent
                                    % -----------------
                                    cgpencol(0.60,0.60,0.60)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(prob_bet(i)), xShift*reset(i) + number_shift, 0)
                                    cgpencol(0.85,0.85,0.85)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(0), xShift*reset(i) - number_shift, 0)
                                    
                                elseif reset(i) == 1
                                    cgdrawsprite(20,-xShift*reset(i),0);
                                    cgdrawsprite(212,xShift*reset(i),0);
                                    % -----------------
                                    % Probabilistic Bet
                                    % 55 percent
                                    % -----------------
                                    cgpencol(0.60,0.60,0.60)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(prob_bet(i)), xShift*reset(i) - number_shift, 0)
                                    cgpencol(0.85,0.85,0.85)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(0), xShift*reset(i) + number_shift, 0)
                                end
                                % --------
                                % Sure Bet
                                % --------
                                cgpencol(0.60,0.60,0.60)
                                cgfont(Font,FontSize)
                                cgtext(num2str(sure_bet(i)), -xShift*reset(i), 0)
                                
                            case 3
                                % --------
                                % Sure Bet
                                % --------
                                for s = 1:sure_bet(i); % 1:172;
                                    cgdrawsprite(2,xConst(s),yConst(s));
                                end
                                % -----------------
                                % Probabilistic Bet
                                % -----------------
                                for s = 1:prob_bet(i); % 1:172;
                                    cgdrawsprite(2,xStim(s),yStim(s));
                                end
                                if reset(i) == -1
                                    cgdrawsprite(20,-xShift*reset(i),yshift_pie);
                                    cgdrawsprite(211,xShift*reset(i),yshift_pie);
                                elseif reset(i) == 1
                                    cgdrawsprite(20,-xShift*reset(i),yshift_pie);
                                    cgdrawsprite(212,xShift*reset(i),yshift_pie);
                                end
                        end
                        
                        cgdrawsprite(7,0,0)
                        cgflip(bg,bg,bg);
                        waitTime(rewardDurations(i)/1000);
                        
                    end
                    
                    
                    %waitTime(rewardDurations(i)/1000);
                    
                else
                    magRiskTrial.accuracy(i) = 0;
                    outMissHit = 'incorr';
                    
                    % Show the selected option
                    if kp(1) == itemRightKey
                        
                        switch riskExpStim
                            case 2
                                if reset(i) == -1
                                    cgdrawsprite(20,-xShift*reset(i),0);
                                    cgdrawsprite(211,xShift*reset(i),0);
                                    
                                    % ----------------------
                                    % Probabilistic Bet Text
                                    % 55 percent
                                    % ----------------------
                                    cgpencol(0.60,0.60,0.60)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(prob_bet(i)), xShift*reset(i) + number_shift, 0)
                                    cgpencol(0.85,0.85,0.85)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(0), xShift*reset(i) - number_shift, 0)
                                elseif reset(i) == 1
                                    cgdrawsprite(20,-xShift*reset(i),0);
                                    cgdrawsprite(212,xShift*reset(i),0);
                                    % ----------------------
                                    % Probabilistic Bet Text
                                    % 55 percent
                                    % ----------------------
                                    cgpencol(0.60,0.60,0.60)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(prob_bet(i)), xShift*reset(i) - number_shift, 0)
                                    cgpencol(0.85,0.85,0.85)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(0), xShift*reset(i) + number_shift, 0)
                                end
                                % -------------
                                % Sure Bet Text
                                % -------------
                                cgpencol(0.60,0.60,0.60)
                                cgfont(Font,FontSize)
                                cgtext(num2str(sure_bet(i)), -xShift*reset(i), 0)
                                
                            case 3
                                % Sure Bet
                                for s = 1:sure_bet(i); %1:172;
                                    cgdrawsprite(2,xConst(s),yConst(s));
                                end
                                % Probabilistic Bet
                                for s = 1:prob_bet(i); %1:172;
                                    cgdrawsprite(2,xStim(s),yStim(s));
                                end
                                if reset(i) == -1
                                    cgdrawsprite(20,-xShift*reset(i),yshift_pie);
                                    cgdrawsprite(211,xShift*reset(i),yshift_pie);
                                elseif reset(i) == 1
                                    cgdrawsprite(20,-xShift*reset(i),yshift_pie);
                                    cgdrawsprite(212,xShift*reset(i),yshift_pie);
                                end
                        end
                        cgdrawsprite(6,0,0)
                        cgflip(bg,bg,bg);
                        waitTime(rewardDurations(i)/1000);
                        
                        
                        
                    else
                        
                        switch riskExpStim
                            case 2
                                if reset(i) == -1
                                    cgdrawsprite(20,-xShift*reset(i),0);
                                    cgdrawsprite(211,xShift*reset(i),0);
                                    
                                    % Probabilistic Bet Text
                                    % 55 percent
                                    cgpencol(0.60,0.60,0.60)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(prob_bet(i)), xShift*reset(i) + number_shift, 0)
                                    cgpencol(0.85,0.85,0.85)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(0), xShift*reset(i) - number_shift, 0)
                                elseif reset(i) == 1
                                    cgdrawsprite(20,-xShift*reset(i),0);
                                    cgdrawsprite(212,xShift*reset(i),0);
                                    
                                    % Probabilistic Bet Text
                                    % 55 percent
                                    cgpencol(0.60,0.60,0.60)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(prob_bet(i)), xShift*reset(i) - number_shift, 0)
                                    cgpencol(0.85,0.85,0.85)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(0), xShift*reset(i) + number_shift, 0)
                                end
                                % Sure Bet Text
                                cgpencol(0.60,0.60,0.60)
                                cgfont(Font,FontSize)
                                cgtext(num2str(sure_bet(i)), -xShift*reset(i), 0)
                                
                            case 3
                                % Sure Bet
                                for s = 1:sure_bet(i);
                                    cgdrawsprite(2,xConst(s),yConst(s));
                                end
                                % Probabilistic Bet
                                for s = 1:prob_bet(i);
                                    cgdrawsprite(2,xStim(s),yStim(s));
                                end
                                if reset(i) == -1
                                    cgdrawsprite(20,-xShift*reset(i),yshift_pie);
                                    cgdrawsprite(211,xShift*reset(i),yshift_pie);
                                elseif reset(i) == 1
                                    cgdrawsprite(20,-xShift*reset(i),yshift_pie);
                                    cgdrawsprite(212,xShift*reset(i),yshift_pie);
                                end
                        end
                        cgdrawsprite(7,0,0)
                        cgflip(bg,bg,bg);     
                        waitTime(rewardDurations(i)/1000);
                        
                        
                    end
                    
                    cgflip(bg,bg,bg);
                    
                    %waitTime(rewardDurations(i)/1000);
                    
                end
                addresults(i, outMissHit, rt, kp);
                % After decision is made draw red frame over chosen item
            end
            
        end
        magRiskTrial.trialDuration(i) = toc;
        
        magRiskTrial.rad(i) = rad(i);
        %magRiskTrial.trialAccumulation = cumsum([magRiskTrial.trialAccumulation, magRiskTrial.trialDuration(i)]);
        
        
        % Note: add array for length of duration
        
        if kp == 75
            magRiskTrial.leftRight(i) = 1;
        elseif kp == 77
            magRiskTrial.leftRight(i) = -1;
        elseif kp ~= 75 | kp ~= 78
            magRiskTrial.leftRight(i) = 0;
        end
    end
    
    %breakDuration = find(breakDuration > 0);
    %magRiskTrial.breakDuration = breakDuration;
    
    magRiskTrial.trialAccumulation = cumsum(magRiskTrial.trialDuration);
    selTrial = magRiskTrial.accuracy(magRiskTrial.selectedTrial);
    
    magRiskTrial.dataFile = [magRiskTrial.trialAccumulation...
        magRiskTrial.trialDuration...
        magRiskTrial.rt/1000 ...
        magRiskTrial.accuracy...
        sure_bet...
        prob_bet...
        magRiskTrial.s2Prob_perm...
        magRiskTrial.diffVal_perm...
        magRiskTrial.rad'...
        magRiskTrial.correct_perm...
        magRiskTrial.reset...
        magRiskTrial.leftRight];
    
    %% SAVE FILES
    
    % Naming:
    % subject_01_MG_resultsParadigm_01_magComp.mat (if expType = 1)
    % subject_01_MG_resultsParadigm_02_riskComp_stim_01.mat (if expType = 2)
    
    if subCode < 10
        save([openFolder subFolder '\' 'sub_0' num2str(subCode) '_' nameSub '_resPar_0'  num2str(expType) '_riskComp_0' num2str(riskExpStim) '_taskSeq_0' num2str(taskSequence) '.mat'],'magRiskTrial');
    elseif subCode >= 10
        save([openFolder subFolder '\' 'sub_' num2str(subCode) '_' nameSub '_resPar_0'  num2str(expType) '_riskComp_0' num2str(riskExpStim) '_taskSeq_0' num2str(taskSequence) '.mat'],'magRiskTrial');
    end
    
    stop_cogent;
    cgshut
    
    return
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
