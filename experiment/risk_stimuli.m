function risk_stimuli(coord)

%% Stimulus Parameters
load('MG_M.mat');
xShift = 180;
yshift_pie = 180;


%% Sure Bet Coins
for s = 1:magRiskTrial.s1_perm(coord);
    cgdrawsprite(2,xConst(s),yConst(s));
    cgpencol(0,0,0)
    cgellipse(-xShift*magRiskTrial.reset(coord),180,30,30,'f')
end

%% Probabilistic Bet Coins
for s = 1:magRiskTrial.s2_perm(coord);
    cgdrawsprite(2,xStim(s),yStim(s)); %% Change this... you need to add
    % 55 percent
    cgpencol(0,0,0)
    cgarc(xShift*magRiskTrial.reset(coord),yshift_pie,30,30,252,90,'S')
    % 45 percent
    cgpencol(1,1,1)
    cgarc(xShift*magRiskTrial.reset(coord),yshift_pie,30,30,90,252,'S')
end