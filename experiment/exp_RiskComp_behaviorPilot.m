function exp_RiskComp_behaviorPilot(subCode, nameSub, expType, riskExpStim, inputTrials, windowmode, screenResolution, bg, openFolder, subFolder, taskSequence, taskSeqNum)
% exp_RiskComp(1,0,1,0,1,'what',1)

%% THE SCRIPT
% This script presents two lotteries: one sure bet and one probabilistic
% bet. Following Khaw, Li, and Woodford (2017), probabilities are fixed at
% a given proportion (55%/45%). Here we provide different presentation
% formats. In paticular, we have three types of stimuli:

% Risky Choice Experimental Stimuli...
% Case 1: Probabilities represented as bars.
% Case 2: Probabilities represented as pies. (Most preferred comparison)
% Case 3: Magnitudes presented as coins. (Most preferred)

%cogstd('spriority','high')
%cogstd('spriority','normal')

%% GENERATE AND LOAD PARADIGM
%load([subCode '/paradigm_' nameExp '_' expType '.mat']); % This loads the trialInfo structure

% Generate stimuli
if expType == 1
    startStim = 5;
    maxStim = 28;
    numRoot = 2;
    rngMin = -6;
    rngMax = 6;
    rngSpc = 2;
    probability = 1;
elseif expType == 2
    startStim = 5;
    maxStim = 28;
    numRoot = 2;
    rngMin = 0;
    rngMax = 8;
    rngSpc = 1;
    probability = 0.55;
end

% % Load Paradigm
% switch taskSequence
%     case 1 % Generate a new set of stimuli
%         gen_dotMagRisk_behaviorPilot(subCode, nameSub, expType, inputTrials, startStim, numRoot, maxStim, rngMin, rngMax, rngSpc, probability, openFolder, subFolder);
%         if expType == 1
%             if subCode < 10
%                 load([openFolder subFolder '\' 'subject_0' num2str(subCode) '_' nameSub '_genParadigm_0'  num2str(expType) '_magComp' '.mat']);
%             elseif subCode >= 10
%                 load([openFolder subFolder '\' 'subject_' num2str(subCode) '_' nameSub '_genParadigm_0'  num2str(expType) '_magComp' '.mat']);
%             end
%         elseif expType == 2
%             if subCode < 10
%                 load([openFolder subFolder '\' 'subject_0' num2str(subCode) '_' nameSub '_genParadigm_0'  num2str(expType) '_riskComp' '.mat']);
%             elseif subCode >= 10
%                 load([openFolder subFolder '\' 'subject_' num2str(subCode) '_' nameSub '_genParadigm_0'  num2str(expType) '_riskComp' '.mat']);
%             end
%         end
%     case 2 % Especially for the second task, use the same set of stimuli
%         if expType == 1
%             if subCode < 10
%                 load([openFolder subFolder '\' 'subject_0' num2str(subCode) '_' nameSub '_genParadigm_0'  num2str(expType) '_magComp' '.mat']);
%             elseif subCode >= 10
%                 load([openFolder subFolder '\' 'subject_' num2str(subCode) '_' nameSub '_genParadigm_0'  num2str(expType) '_magComp' '.mat']);
%             end
%         elseif expType == 2
%             if subCode < 10
%                 load([openFolder subFolder '\' 'subject_0' num2str(subCode) '_' nameSub '_genParadigm_0'  num2str(expType) '_riskComp' '.mat']);
%             elseif subCode >= 10
%                 load([openFolder subFolder '\' 'subject_' num2str(subCode) '_' nameSub '_genParadigm_0'  num2str(expType) '_riskComp' '.mat']);
%             end
%         end
% end

switch taskSequence
    case 1 % Generate a new set of stimuli
        gen_dotMagRisk_behaviorPilot(subCode, nameSub, expType, inputTrials, startStim, numRoot, maxStim, rngMin, rngMax, rngSpc, probability, openFolder, subFolder);
        if expType == 1
            if subCode < 10
                load([openFolder subFolder '\' 'sub_0' num2str(subCode) '_' nameSub '_genPar_0'  num2str(expType) '_magComp' '.mat']);
            elseif subCode >= 10
                load([openFolder subFolder '\' 'sub_' num2str(subCode) '_' nameSub '_genPar_0'  num2str(expType) '_magComp' '.mat']);
            end
        elseif expType == 2
            if subCode < 10
                load([openFolder subFolder '\' 'sub_0' num2str(subCode) '_' nameSub '_genPar_0'  num2str(expType) '_riskComp' '.mat']);
            elseif subCode >= 10
                load([openFolder subFolder '\' 'sub_' num2str(subCode) '_' nameSub '_genPar_0'  num2str(expType) '_riskComp' '.mat']);
            end
        end
    case 2 % Especially for the second task, use the same set of stimuli
        if expType == 1
            if subCode < 10
                load([openFolder subFolder '\' 'sub_0' num2str(subCode) '_' nameSub '_genPar_0'  num2str(expType) '_magComp' '.mat']);
            elseif subCode >= 10
                load([openFolder subFolder '\' 'sub_' num2str(subCode) '_' nameSub '_genPar_0'  num2str(expType) '_magComp' '.mat']);
            end
        elseif expType == 2
            if subCode < 10
                load([openFolder subFolder '\' 'sub_0' num2str(subCode) '_' nameSub '_genPar_0'  num2str(expType) '_riskComp' '.mat']);
            elseif subCode >= 10
                load([openFolder subFolder '\' 'sub_' num2str(subCode) '_' nameSub '_genPar_0'  num2str(expType) '_riskComp' '.mat']);
            end
        end
end



%% WINDOW AND RESOLUTION PARAMETERS

%windowmode = 0;                 % 0: small window; 1: full screen
%screenRes = 3;                  % 1=640x480, 2=800x600, 3=1024x768
%bg = 0;

if screenResolution ==1  screenWidth = 640; screenHeight = 480;
elseif screenResolution ==2  screenWidth = 800; screenHeight = 600;
else   screenWidth = 1024; screenHeight = 768;
end

config_display(windowmode,screenResolution,[0 0 0], [bg bg bg]); % configure graphics window
config_log
config_keyboard;
start_cogent;

% if expType == 1
%     if subCode < 10
%         config_results([openFolder subFolder '\' 'subject_0' num2str(subCode) '_' nameSub '_resultsParadigm_0'  num2str(expType) '_magComp' '_taskSeq_0' num2str(taskSequence) '.txt']);
%     elseif subCode >= 10
%         config_results([openFolder subFolder '\' 'subject_' num2str(subCode) '_' nameSub '_resultsParadigm_0'  num2str(expType) '_magComp' '_taskSeq_0' num2str(taskSequence) '.txt']);
%     end
% elseif expType == 2
%     if subCode < 10
%         config_results([openFolder subFolder '\' 'subject_0' num2str(subCode) '_' nameSub '_resultsParadigm_0'  num2str(expType) '_riskComp_0' '_taskSeq_0' num2str(taskSequence) '.txt']);
%     elseif subCode >= 10
%         config_results([openFolder subFolder '\' 'subject_' num2str(subCode) '_' nameSub '_resultsParadigm_0'  num2str(expType) '_riskComp_0' num2str(riskExpStim) '_taskSeq_0' num2str(taskSequence) '.txt']);
%     end
% end

if expType == 1
    if subCode < 10
        config_results([openFolder subFolder '\' 'sub_0' num2str(subCode) '_' nameSub '_resPar_0'  num2str(expType) '_magComp' '_taskSeq_0' num2str(taskSequence) '.txt']);
    elseif subCode >= 10
        config_results([openFolder subFolder '\' 'sub_' num2str(subCode) '_' nameSub '_resPar_0'  num2str(expType) '_magComp' '_taskSeq_0' num2str(taskSequence) '.txt']);
    end
elseif expType == 2
    if subCode < 10
        config_results([openFolder subFolder '\' 'sub_0' num2str(subCode) '_' nameSub '_resPar_0'  num2str(expType) '_riskComp_0' '_taskSeq_0' num2str(taskSequence) '.txt']);
    elseif subCode >= 10
        config_results([openFolder subFolder '\' 'sub_' num2str(subCode) '_' nameSub '_resPar_0'  num2str(expType) '_riskComp_0' num2str(riskExpStim) '_taskSeq_0' num2str(taskSequence) '.txt']);
    end
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

%% MAGNITUDE COMPARISON AND RISKY CHOICE DISPLAY PARAMETERS

switch expType
    case 1 % Magnitude Comparison Task
        fixationResponseDuration = 2500;                                                    % Max duration for response
        fixationStartDuration = 1500*ones(1,magRiskTrial.nTrials);                          % Duration of the red fixation cross
        fixationCueResponseDuration = 500*ones(1,magRiskTrial.nTrials);                     % Duration of the coins
        
        upperLimFixTime2 = 9000;                                                            % Upper bound of the ITI
        lowerLimFixTime2 = 6000;                                                            % Lower bound of the ITI
        fixDurations2 = randsample(lowerLimFixTime2:upperLimFixTime2,magRiskTrial.nTrials); % Duration of the ITI (jittered)
        
        rewardDurations = 500*ones(1,magRiskTrial.nTrials);                                 % Duration of the green arrows
        
        sessionBreaks = 5; % Includes a break before the start of the second task
        startInterval = 30;
        for i = 1:sessionBreaks
            breakPeriods(i) = startInterval + startInterval*(i-1) ;
        end
        
    case 2
        % Define Display Parameters
        fixationResponseDuration = 3000;                                                    % Max duration for response
        fixDurations = 750*ones(1,magRiskTrial.nTrials);
        rewardDurations = 500*ones(1,magRiskTrial.nTrials);                                 % Duration of the green cross
        transitDurations = 600;
        
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
            case 1
                xShift = 180;
            case 2
                xShift = 180;
            case 3
                xShift = 270;
        end
        
        %%% Bar stimuli
        bar_width1 = 90;        %%% Outer lining
        bar_height1 = 190;
        
        bar_width2 = 80;        %%% For sure bet
        bar_height2 = 180;
        
        bar_width3 = 80;        %%% Probabilistic Bet
        bar_height3 = 81;
        
        %%% Pie Stimuli
        pie_size = 150;
        number_shift = 35;
        
        %%% Coins Stimuli
        yShift = -40;
        yshift_pie = 215;
        
end

%% FONT AND KEYBOARD PARAMETERS
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

%% TRIAL LOOP

if expType == 2                 % Only in the risky choice task that we need this.
    reset = magRiskTrial.reset;
end
sure_bet = magRiskTrial.s1_perm;
prob_bet = magRiskTrial.s2_perm;

%%% Version 1: Create random numbers following a given interval.
rad = zeros(magRiskTrial.nTrials,1);
switch expType
    case 1
        for i = 1:magRiskTrial.nTrials
            radInterval = 150:10:210;
            radSequence = randperm(length(radInterval));
            rad(i) = radInterval(:,radSequence(:,1));
        end
    case 2
        for i = 1:magRiskTrial.nTrials
            radInterval = 150:10:210;
            radSequence = randperm(length(radInterval));
            rad(i) = radInterval(:,radSequence(:,1));
        end
end

%% SPRITES

% Fixation start trial (Sprite 1)
w = 0.7;
cgmakesprite(1,100,100,bg,bg,bg)
cgsetsprite(1)
cgpencol(155/255, 16/255, 16/255)                   % Draw a red cross
cgrect(0,0,4*w,20*w)
cgrect(0,0,20*w,4*w)
cgtrncol(1,'n')

switch expType
    case 1
        cgtrncol(2,'n')
        cgsetsprite(2)
        resize = 0.030; %0.015;
        %resize = 0.0140; %0.015;
        I = imresize(imread('1franc_new2.png'),resize);
        %I = imadjust(I, [0.01 0.8], [0.6 1.0]);
        imwrite(I, 'coin2.png');
        loadpict('coin2.png',2,0,0);
    case 2
        switch riskExpStim
            case 1 % Probabilities as Bars
                % Sure Bet
                cgmakesprite(20,bar_width1,bar_height1,bg,bg,bg)
                cgsetsprite(20)
                cgpencol(0.65,0.65,0.65)
                cgrect(0,0,bar_width1,bar_height1)
                cgpencol(0.85,0.85,0.85)
                cgrect(0,0,bar_width2,bar_height2)
                
                %Probabilistic Bet
                cgmakesprite(21,bar_width1,bar_height1,bg,bg,bg)
                cgsetsprite(21)
                cgpencol(0.65,0.65,0.65)
                cgrect(0,0,bar_width1,bar_height1)
                cgpencol(0.85,0.85,0.85)
                cgrect(0,0,bar_width2,bar_height2)
                % 45 Percent
                cgpencol(0.45,0.45,0.45)
                cgrect(0,50,bar_width3,bar_height3)
                
            case 2 % Probabilities as Pies
                % Sure Bet
                cgmakesprite(20,pie_size,pie_size,bg,bg,bg)
                cgsetsprite(20)
                cgpencol(0.85,0.85,0.85)
                cgellipse(0,0,pie_size,pie_size,'f')
                
                % Probabilsitic Bet
                % draw the points for the constant points
                % 55 percent
                cgmakesprite(211,pie_size,pie_size,bg,bg,bg)
                cgsetsprite(211)
                cgpencol(0.85,0.85,0.85)
                cgarc(0,0,pie_size,pie_size,252,90,'S')
                % 45 percent
                cgpencol(0.60,0.60,0.60)
                cgarc(0,0,pie_size,pie_size,90,252,'S')
                
                % Probabilsitic Bet
                % draw the points for the constant points
                % 45 percent
                cgmakesprite(212,pie_size,pie_size,bg,bg,bg)
                cgsetsprite(212)
                cgpencol(0.60,0.60,0.60)
                cgarc(0,0,pie_size,pie_size,288,90,'S')
                % 55 percent
                cgpencol(0.85,0.85,0.85)
                cgarc(0,0,pie_size,pie_size,90,288,'S')
                
            case 3 % Coins
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
                
                % Sure Bet
                cgmakesprite(20,60,60,bg,bg,bg)
                cgsetsprite(20)
                cgpencol(0.85,0.85,0.85)
                cgellipse(0,0,60,60,'f')
                
                % Probabilistic Bet
                cgmakesprite(211,60,60,bg,bg,bg)
                cgsetsprite(211)
                cgpencol(0.85,0.85,0.85)
                cgarc(0,0,60,60,252,90,'S')
                % 45 percent
                cgpencol(0.45,0.45,0.45)
                cgarc(0,0,60,60,90,252,'S')
                
                % Probabilistic Bet
                cgmakesprite(212,60,60,bg,bg,bg)
                cgsetsprite(212)
                cgpencol(0.45,0.45,0.45)
                cgarc(0,0,60,60,288,90,'S')
                % 45 percent
                cgpencol(0.85,0.85,0.85)
                cgarc(0,0,60,60,90,288,'S')
        end
end

% Fixation go trial (Sprite 3)
cgmakesprite(3,100,100,bg,bg,bg)
cgsetsprite(3)
cgpencol(49/255, 135/255, 39/255)                     % Draw a green cross
cgrect(0,0,4*w,20*w)
cgrect(0,0,20*w,4*w)
cgtrncol(3,'n')

cgmakesprite(6,50,50,bg,bg,bg)
cgsetsprite(6)
cgfont('Times',30)
cgpencol(49/255, 135/255, 39/255)
cgtext('r',0,3)

cgmakesprite(7,50,50,bg,bg,bg)
cgsetsprite(7)
cgfont('Times',30)
cgpencol(49/255, 135/255, 39/255)
cgtext('l',0,0)

%%% Alternatives: 
% switch expType
%     case 1
%         w = 0.4; % Add a weihting function to determine the size of the Roman Numbers
%         cgmakesprite(6,50,50,0,0,0)
%         cgtrncol(6,'n')
%         cgsetsprite(6)
%         cgpencol(49/255, 135/255, 39/255)
%         cgrect(-10*w,0*w,10*w,40*w)
%         cgrect(10*w,0*w,10*w,40*w)
%         cgrect(0*w,20*w,45*w,10*w)
%         cgrect(0*w,-20*w,45*w,10*w)
%         
%         cgmakesprite(7,50,50,0,0,0)
%         cgtrncol(7,'n')
%         cgsetsprite(7)
%         cgpencol(49/255, 135/255, 39/255)
%         cgrect(0*w,0*w,10*w,40*w)
%         cgrect(0*w,20*w,25*w,10*w)
%         cgrect(0*w,-20*w,25*w,10*w)
%                      
%     case 2
%         % Arrow Right Alternative
%         xArrow = [ 0 20   0];                                 % Size of the arrow
%         yArrow = [10  0 -10];
%         cgmakesprite(6,50,50,0,0,0)
%         cgtrncol(6,'n')
%         cgsetsprite(6)
%         cgpencol(49/255, 135/255, 39/255)
%         cgpolygon(xArrow, yArrow)
%         
%         % Arrow Left Alternative
%         xArrow = [ 0 -20 0];                                   % Size of the arrow
%         yArrow = [10 0 -10];
%         cgmakesprite(7,50,50,0,0,0)
%         cgtrncol(7,'n')
%         cgsetsprite(7)
%         cgpencol(49/255, 135/255, 39/255)
%         cgpolygon(xArrow, yArrow)
% end


% Rest Periods - Becuase we are merciful motherfuckers
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
%
cgsetsprite(0)
cgpencol(1,1,1)
%*************************************************************

%% TRIAL LOOP
%%%%%%%%%%%%%%%%%%%%%%%%
%%% BEHAVARIOAL TASK %%%
%%%%%%%%%%%%%%%%%%%%%%%%

%%%% INTRODUCTION

cgflip(bg,bg,bg)
cgfont('Arial',25)
cgpencol(1,1,1)
cgtext(['TASK ' num2str(taskSeqNum)],0,25)

cgtext(['Press Enter to start'],0,-25)
cgflip(bg,bg,bg);
waitkeydown(inf, enterKey);
cgflip(bg,bg,bg)
wait(2000)

switch expType
    case 1
        cgflip(bg,bg,bg)
        cgfont('Arial',25)
        cgpencol(1,1,1)
        cgtext(['TASK ' num2str(taskSeqNum) ' INSTRUCTIONS:'],0,25)
        cgtext(['Press the LEFT ARROW if the first pile of coins is greater.'],0,-25)
        cgtext(['Press the RIGHT ARROW if the second pile of coins is greater.'],0,-75)
        cgtext(['Press ENTER to start.'],0,-175)
        cgflip(bg,bg,bg);
        
        start_t0 = time;
        waitkeydown(inf, enterKey);
        cgflip(bg,bg,bg)
        wait(2000)
        
        startDuration = time - start_t0;
        magRiskTrial.startDuration = startDuration;
        
    case 2
        cgflip(bg,bg,bg)
        cgfont('Arial',25)
        cgpencol(1,1,1)
        cgtext(['TASK ' num2str(taskSeqNum) ' INSTRUCTIONS:'],0,50)
        cgtext(['Press the LEFT arrow if you choose the option on the left.'],0,0)
        cgtext(['Press the RIGHT arrow if you choose the option on the right.'],0,-50)
        cgtext(['By the end of the experiment, we will pay you based on the option you chose.'],0,-100)
        cgtext(['Press ENTER to start.'],0,-175)
        cgflip(bg,bg,bg);
        
        instruct_t0 = time;
        waitkeydown(inf, enterKey);
        cgflip(bg,bg,bg)
        wait(2000)
        
        instructDuration = time - instruct_t0;
        magRiskTrial.instructDuration = instructDuration;
end

% %%% Version 2: Create random numbers with incremental intervals.
% switch expType
%     case 1
%         rad = randi([140 210], 1, magRiskTrial.nTrials); %randi([210 210], 1, magRiskTrial.nTrials);
%     case 2
%         rad = randi([140 210], 1, magRiskTrial.nTrials); %randi([210 210], 1, magRiskTrial.nTrials);
% end

for randTrial = 1:magRiskTrial.nTrials
    
    tic;
    i = randTrial;
    
    %-------------------------------
    % Set the keypad responses
    
    correct = magRiskTrial.correct_perm;
    
    switch expType
        case 1
            if correct(i) == 1
                targetKey = itemLeftKey;
            elseif correct(i) == -1
                targetKey = itemRightKey;
            elseif correct(i) == 0
                targetKey = itemRightKey;
            elseif correct(i) == 0
                targetKey = itemLeftKey;
            end
        case 2
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
    end
    
    switch expType
        case 1 % Magnitude Comparison Task
            cgdrawsprite(1,0,0);
            cgflip(bg,bg,bg);
            fixed_t0 = time;
            wait(fixationStartDuration(randTrial));
            
            fixedDuration = time - fixed_t0;
            magRiskTrial.fixedDuration(i) = fixedDuration;
            
        case 2
            switch riskExpStim
                case 1 % Probabilities as Bars
                    cgdrawsprite(20,-xShift*reset(i),0); % Sure Bet Sprite
                    cgdrawsprite(21,xShift*reset(i),0);  % Probabilistic Sprite
                    cgdrawsprite(1,0,0);
                    cgflip(bg,bg,bg);
                    fixed_t0 = time;
                    wait(fixDurations(randTrial));
                    
                    cgdrawsprite(20,-xShift*reset(i),0);
                    cgdrawsprite(21,xShift*reset(i),0);
                    cgdrawsprite(3,0,0);
                    cgflip(bg,bg,bg);
                    wait(transitDurations);
                    
                    fixedDuration = time - fixed_t0;
                    magRiskTrial.fixedDuration(i) = fixedDuration;
                    
                case 2 % Probabilities as Pies
                    if reset(i) == -1
                        cgdrawsprite(20,-xShift*reset(i),0);
                        cgdrawsprite(211,xShift*reset(i),0);
                    elseif reset(i) == 1
                        cgdrawsprite(20,-xShift*reset(i),0);
                        cgdrawsprite(212,xShift*reset(i),0);
                    end
                    
                    cgdrawsprite(1,0,0);
                    cgflip(bg,bg,bg);
                    fixed_t0 = time;
                    firstCue_t0 = fixed_t0;
                    wait(fixDurations(randTrial));
                    
                    firstCueDuration = time - firstCue_t0;
                    magRiskTrial.firstCueDuration(i) = firstCueDuration;
                    if reset(i) == -1
                        cgdrawsprite(20,-xShift*reset(i),0);
                        cgdrawsprite(211,xShift*reset(i),0);
                    elseif reset(i) == 1
                        cgdrawsprite(20,-xShift*reset(i),0);
                        cgdrawsprite(212,xShift*reset(i),0);
                    end
                    cgdrawsprite(3,0,0);
                    cgflip(bg,bg,bg);
                    
                    secondCue_t0 = time;
                    wait(transitDurations);
                    
                    secondCueDuration = time - secondCue_t0;
                    magRiskTrial.secondCueDuration(i) = secondCueDuration;
                    
                    fixedDuration = time - fixed_t0;
                    magRiskTrial.fixedDuration(i) = fixedDuration;
                    
                case 3 % Coins
                    if reset(i) == -1
                        cgdrawsprite(20,-xShift*reset(i),yshift_pie);
                        cgdrawsprite(211,xShift*reset(i),yshift_pie);
                    elseif reset(i) == 1
                        cgdrawsprite(20,-xShift*reset(i),yshift_pie);
                        cgdrawsprite(212,xShift*reset(i),yshift_pie);
                    end
                    cgdrawsprite(1,0,0);
                    cgflip(bg,bg,bg);
                    fixed_t0 = time;
                    firstCue_t0 = fixed_t0;
                    wait(fixDurations(randTrial));
                    
                    firstCueDuration = time - firstCue_t0;
                    magRiskTrial.firstCueDuration(i) = firstCueDuration;
                    
                    if reset(i) == -1
                        cgdrawsprite(20,-xShift*reset(i),yshift_pie);
                        cgdrawsprite(211,xShift*reset(i),yshift_pie);
                    elseif reset(i) == 1
                        cgdrawsprite(20,-xShift*reset(i),yshift_pie);
                        cgdrawsprite(212,xShift*reset(i),yshift_pie);
                    end
                    cgdrawsprite(3,0,0);
                    cgflip(bg,bg,bg);
                    
                    secondCue_t0 = time;
                    wait(transitDurations);
                    
                    secondCueDuration = time - secondCue_t0;
                    magRiskTrial.secondCueDuration(i) = secondCueDuration;
                    
                    fixedDuration = time - fixed_t0;
                    magRiskTrial.fixedDuration(i) = fixedDuration;
                    
            end
    end
    
    % draw the points for the constant points
    switch expType
        case 1
            [xConst,yConst] = rand_grid2(magRiskTrial.s1_perm(i), 8, 0, 0, rad(i), expType);
            
            %cgflip(bg,bg,bg);
            cgdrawsprite(1,0,0);
            % draw the points for the constant points
            for s = 1:magRiskTrial.s1_perm(i);  
                cgdrawsprite(2,xConst(s),yConst(s));
                %cgpencol(1,1,1)
                %cgfont(Font,FontSize)
                %cgtext(num2str(sure_bet(i)), 0, 0)
            end
            %cgdrawsprite(1,0,0);
            cgflip(bg,bg,bg);
            cgdrawsprite(1,0,0);
            firstStim_t0 = time;
            wait(fixationCueResponseDuration(randTrial));
            cgflip(bg,bg,bg);
            firstStimDuration = time - firstStim_t0;
            magRiskTrial.firstStimDuration(i) = firstStimDuration;
            
            itiStim_t0 = time;
            wait(fixDurations2(randTrial));
            %cgflip(bg,bg,bg);
            itimStimDuration = time - itiStim_t0;
            magRiskTrial.itimStimDuration(i) = itimStimDuration;
            
            [xStim,yStim] = rand_grid2(magRiskTrial.s2_perm(i), 8, 0, 0, rad(i), expType);
            %cgflip(bg,bg,bg);
            cgdrawsprite(1,0,0);
            % draw the points for the constant points
            for s = 1:magRiskTrial.s2_perm(i);
                cgdrawsprite(2,xStim(s),yStim(s));
                %cgpencol(1,1,1)
                %cgfont(Font,FontSize)
                %cgtext(num2str(prob_bet(i)), 0, 0)
            end
            %cgdrawsprite(1,0,0);
            cgflip(bg,bg,bg);
            secondStim_t0 = time;
            wait(fixationCueResponseDuration(randTrial));
            %cgflip(bg,bg,bg);
            
            cgdrawsprite(1,0,0);
            cgflip(bg,bg,bg);
            wait(100);
            
            secondStimDuration = time - secondStim_t0;
            magRiskTrial.secondStimDuration(i) = secondStimDuration;
                        
        case 2
            switch riskExpStim
                case 1 % Probabilities as Bars
                    cgdrawsprite(20,-xShift*reset(i),0);                                    % Sure Bet Sprite
                    cgdrawsprite(21,xShift*reset(i),0);                                     % Probabilistic Sprite
                    % Sure Bet Text
                    cgpencol(0.45,0.45,0.45)
                    cgfont(Font,FontSize)
                    cgtext(num2str(sure_bet(i)), -xShift*reset(i), 0)
                    %cgtext(num2str(sure_bet(i)), -xShift*reset(i), 120)
                    %cgfont(Font,FontSize*0.8)
                    %cgtext([num2str(100) ['%']],-xShift*reset(i), 0)
                    % Probabilistic Bet Text
                    cgpencol(0.45,0.45,0.45)
                    cgfont(Font,FontSize)
                    cgtext(num2str(prob_bet(i)), xShift*reset(i), -37)
                    cgpencol(0.85,0.85,0.85)
                    cgfont(Font,FontSize)
                    cgtext(num2str(0), xShift*reset(i), 47)
                    %cgfont(Font,FontSize*0.8)
                    %cgtext([num2str(55) ['%']], xShift*reset(i), -37)
                    %cgfont(Font,FontSize*0.8)
                    %cgtext([num2str(45) ['%']], xShift*reset(i), 47)
                    
                case 2 % Probabilities as Pies
                    if reset(i) == -1
                        cgdrawsprite(20,-xShift*reset(i),0);
                        cgdrawsprite(211,xShift*reset(i),0);
                        
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
                    
                    
                case 3 % Coins
                    [xConst,yConst] = rand_grid2(sure_bet(i), 8, -xShift*reset(i), yShift, rad(i), expType); %rand_grid2(172, 8, -xShift*reset(i), yShift, rad(i));
                    [xStim,yStim] = rand_grid2(prob_bet(i), 8, xShift*reset(i), yShift , rad(i), expType);   %rand_grid2(172, 8, xShift*reset(i), yShift , rad(i));
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
    end
    
    % Do not remove dots when all stimuli are drawn
    % Draw go cross


    
    cgdrawsprite(3,0,0);
    cgflip(bg,bg,bg);
    
    %% RESPONSE
    
    [kd]=cgkeymap;
    kd(itemLeftKey) = 0;
    kd(itemRightKey) = 0;
    t0 = time;
    
    while ~kd(itemLeftKey) && ~kd(itemRightKey)
        
        if time-t0>fixationResponseDuration % subject did not choose before fixationResponseDuration
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
                    switch expType
                        case 1
                            cgdrawsprite(6,0,0)
                        case 2
                            switch riskExpStim
                                case 1
                                    cgdrawsprite(20,-xShift*reset(i),0);                % Sure Bet Sprite
                                    cgdrawsprite(21,xShift*reset(i),0);                 % Probabilistic Bet Sprite
                                    % Sure Bet Text
                                    cgpencol(0,0,0)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(sure_bet(i)), -xShift*reset(i), 0)
                                    %cgtext(num2str(sure_bet(i)), -xShift*reset(i), 120)
                                    %cgfont(Font,FontSize*0.8)
                                    %cgtext([num2str(100) ['%']],-xShift*reset(i), 0)
                                    % Probabilistic Bet Text
                                    cgpencol(0,0,0)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(prob_bet(i)), xShift*reset(i), -37)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(0), xShift*reset(i), 47)
                                    %cgfont(Font,FontSize*0.8)
                                    %cgtext([num2str(55) ['%']], xShift*reset(i), -37)
                                    %cgfont(Font,FontSize*0.8)
                                    %cgtext([num2str(45) ['%']], xShift*reset(i), 47)
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
                                    end                                    % Sure Bet Text
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
                    end
                    
                else
                    switch expType
                        case 1
                            cgdrawsprite(7,0,0)
                        case 2
                            switch riskExpStim
                                case 1
                                    cgdrawsprite(20,-xShift*reset(i),0);                    % Sure Bet Sprite
                                    cgdrawsprite(21,xShift*reset(i),0);                     % Probabilistic Bet Sprite
                                    % Sure Bet Text
                                    cgpencol(0,0,0)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(sure_bet(i)), -xShift*reset(i), 0)
                                    %cgtext(num2str(sure_bet(i)), -xShift*reset(i), 120)
                                    %cgfont(Font,FontSize*0.8)
                                    %cgtext([num2str(100) ['%']],-xShift*reset(i), 0)
                                    % Probabilistic Bet Text
                                    cgpencol(0,0,0)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(prob_bet(i)), xShift*reset(i), -37)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(0), xShift*reset(i), 47)
                                    %cgfont(Font,FontSize*0.8)
                                    %cgtext([num2str(55) ['%']], xShift*reset(i), -37)
                                    %cgfont(Font,FontSize*0.8)
                                    %cgtext([num2str(45) ['%']], xShift*reset(i), 47)
                                case 2
                                    if reset(i) == -1
                                        cgdrawsprite(20,-xShift*reset(i),0);
                                        cgdrawsprite(211,xShift*reset(i),0);
                                        
                                        % Probabilistic Bet
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
                                        
                                        % Probabilistic Bet
                                        % 55 percent
                                        cgpencol(0.60,0.60,0.60)
                                        cgfont(Font,FontSize)
                                        cgtext(num2str(prob_bet(i)), xShift*reset(i) - number_shift, 0)
                                        cgpencol(0.85,0.85,0.85)
                                        cgfont(Font,FontSize)
                                        cgtext(num2str(0), xShift*reset(i) + number_shift, 0)
                                    end
                                    % Sure Bet
                                    cgpencol(0.60,0.60,0.60)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(sure_bet(i)), -xShift*reset(i), 0)
                                    
                                case 3
                                    % Sure Bet
                                    for s = 1:sure_bet(i); % 1:172;
                                        cgdrawsprite(2,xConst(s),yConst(s));
                                    end
                                    % Probabilistic Bet
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
                    end
                end
                cgflip(bg,bg,bg);
                
                wait(rewardDurations(randTrial))
                
            else
                magRiskTrial.accuracy(i) = 0;
                outMissHit = 'incorr';
                
                % Show the selected option
                if kp(1) == itemRightKey
                    switch expType
                        case 1
                            cgdrawsprite(6,0,0)
                        case 2
                            switch riskExpStim
                                case 1
                                    cgdrawsprite(20,-xShift*reset(i),0);                            % Sure Bet Sprite
                                    cgdrawsprite(21,xShift*reset(i),0);                             % Probabilistic Bet Sprite
                                    % Sure Bet Text
                                    cgpencol(0,0,0)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(sure_bet(i)), -xShift*reset(i), 0)
                                    %cgtext(num2str(sure_bet(i)), -xShift*reset(i), 120)
                                    %cgfont(Font,FontSize*0.8)
                                    %cgtext([num2str(100) ['%']],-xShift*reset(i), 0)
                                    % Probabilistic Bet Text
                                    cgpencol(0,0,0)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(prob_bet(i)), xShift*reset(i), -37)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(0), xShift*reset(i), 47)
                                    %cgfont(Font,FontSize*0.8)
                                    %cgtext([num2str(55) ['%']], xShift*reset(i), -37)
                                    %cgfont(Font,FontSize*0.8)
                                    %cgtext([num2str(45) ['%']], xShift*reset(i), 47)
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
                    end
                else
                    switch expType
                        case 1
                            cgdrawsprite(7,0,0)
                        case 2
                            switch riskExpStim
                                case 1
                                    cgdrawsprite(20,-xShift*reset(i),0);
                                    cgdrawsprite(21,xShift*reset(i),0);
                                    % Sure Bet Text
                                    cgpencol(0,0,0)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(sure_bet(i)), -xShift*reset(i),0)
                                    %cgtext(num2str(sure_bet(i)), -xShift*reset(i), 120)
                                    %cgfont(Font,FontSize*0.8)
                                    %cgtext([num2str(100) ['%']],-xShift*reset(i), 0)
                                    % Probabilistic Bet Text
                                    cgpencol(0,0,0)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(prob_bet(i)), xShift*reset(i), -37)
                                    cgfont(Font,FontSize)
                                    cgtext(num2str(0), xShift*reset(i), 47)
                                    %cgfont(Font,FontSize*0.8)
                                    %cgtext([num2str(55) ['%']], xShift*reset(i), -37)
                                    %cgfont(Font,FontSize*0.8)
                                    %cgtext([num2str(45) ['%']], xShift*reset(i), 47)
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
                            cgdrawsprite(7,0,0)
                    end
                end
                cgflip(bg,bg,bg);
                
                wait(rewardDurations(randTrial))
                
            end
            addresults(i, outMissHit, rt, kp);
            % After decision is made draw red frame over chosen item
        end
    end
    magRiskTrial.trialDuration(i) = toc;
    
    magRiskTrial.rad(i) = rad(i);
    %magRiskTrial.trialAccumulation = cumsum([magRiskTrial.trialAccumulation, magRiskTrial.trialDuration(i)]);
    
    if  length(find(breakPeriods==randTrial))==1    % force subjects to rest after a certain number of trials
        cgflip(bg,bg,bg)
        cgdrawsprite(40,0,0)
        cgflip
        
        tic;
        wait(20000);
        cgflip(bg,bg,bg);
        cgdrawsprite(41,0,0)
        cgflip(bg,bg,bg);
        waitkeydown(inf, enterKey);
        wait(250)
        
        breakDuration(randTrial) = toc;
        
        breakDuration = find(breakDuration > 1);
        magRiskTrial.breakDuration = breakDuration;
        
    end
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

if expType == 1
    magRiskTrial.dataFile = [magRiskTrial.trialAccumulation magRiskTrial.trialDuration...
        magRiskTrial.rt/1000 magRiskTrial.accuracy sure_bet prob_bet...
        magRiskTrial.s2Prob_perm magRiskTrial.diffVal_perm magRiskTrial.rad'...
        magRiskTrial.correct_perm magRiskTrial.leftRight];
elseif expType == 2
    magRiskTrial.dataFile = [magRiskTrial.trialAccumulation magRiskTrial.trialDuration...
        magRiskTrial.rt/1000 magRiskTrial.accuracy sure_bet prob_bet...
        magRiskTrial.s2Prob_perm magRiskTrial.diffVal_perm magRiskTrial.rad'...
        magRiskTrial.correct_perm magRiskTrial.reset magRiskTrial.leftRight];
end

%% SAVE FILES

% Naming:
% subject_01_MG_resultsParadigm_01_magComp.mat (if expType = 1)
% subject_01_MG_resultsParadigm_02_riskComp_stim_01.mat (if expType = 2)

% if expType == 1
%     if subCode < 10
%         save([openFolder subFolder '\' 'subject_0' num2str(subCode) '_' nameSub '_resultsParadigm_0'  num2str(expType) '_magComp' '_taskSeq_0' num2str(taskSequence) '.mat'],'magRiskTrial');
%     elseif subCode >= 10
%         save([openFolder subFolder '\' 'subject_' num2str(subCode) '_' nameSub '_resultsParadigm_0'  num2str(expType) '_magComp' '_taskSeq_0' num2str(taskSequence) '.mat'],'magRiskTrial');
%     end
% elseif expType == 2
%     if subCode < 10
%         save([openFolder subFolder '\' 'subject_0' num2str(subCode) '_' nameSub '_resultsParadigm_0'  num2str(expType) '_riskComp_0' num2str(riskExpStim) '_taskSeq_0' num2str(taskSequence) '.mat'],'magRiskTrial');
%     elseif subCode >= 10
%         save([openFolder subFolder '\' 'subject_' num2str(subCode) '_' nameSub '_resultsParadigm_0'  num2str(expType) '_riskComp_0' num2str(riskExpStim) '_taskSeq_0' num2str(taskSequence) '.mat'],'magRiskTrial');
%     end
% end

if expType == 1
    if subCode < 10
        save([openFolder subFolder '\' 'sub_0' num2str(subCode) '_' nameSub '_resPar_0'  num2str(expType) '_magComp' '_taskSeq_0' num2str(taskSequence) '.mat'],'magRiskTrial');
    elseif subCode >= 10
        save([openFolder subFolder '\' 'sub_' num2str(subCode) '_' nameSub '_resPar_0'  num2str(expType) '_magComp' '_taskSeq_0' num2str(taskSequence) '.mat'],'magRiskTrial');
    end
elseif expType == 2
    if subCode < 10
        save([openFolder subFolder '\' 'sub_0' num2str(subCode) '_' nameSub '_resPar_0'  num2str(expType) '_riskComp_0' num2str(riskExpStim) '_taskSeq_0' num2str(taskSequence) '.mat'],'magRiskTrial');
    elseif subCode >= 10
        save([openFolder subFolder '\' 'sub_' num2str(subCode) '_' nameSub '_resPar_0'  num2str(expType) '_riskComp_0' num2str(riskExpStim) '_taskSeq_0' num2str(taskSequence) '.mat'],'magRiskTrial');
    end
end

stop_cogent;
cgshut

return

%%% Things to add:
% A matrix that merges together all the timing, accuracy, rt, and input
% results.

%%% Draw graphical results
%%% Accuracy results across difference values.
%%% RT distributions

