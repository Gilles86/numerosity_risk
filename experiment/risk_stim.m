function risk_stim(nTrial)

xShift = 180;
yShift = -20;
yshift_pie = 0;
rad = 130;
%%% For sure bet
bar_width1 = 90;
bar_height1 = 190;

bar_width2 = 80;
bar_height2 = 180;

bar_width3 = 80;
bar_height3 = 81;

    % draw the points for the constant points
    cgpencol(0.65,0.65,0.65)
    cgrect(-xShift*reset(nTrial),0,bar_width1,bar_height1)
    cgpencol(0.85,0.85,0.85)
    cgrect(-xShift*reset(nTrial),0,bar_width2,bar_height2)
    % Sure Bet Text
    cgpencol(0,0,0)
    cgfont(Font,FontSize)
    cgtext(num2str(sure_bet(nTrial)), -xShift*reset(nTrial), -120)
    cgtext(num2str(sure_bet(nTrial)), -xShift*reset(nTrial), 120)
    cgfont(Font,FontSize*0.8)
    cgtext([num2str(100) ['%']], -xShift*reset(nTrial), 0)
    
    % draw the points for the constant points
    cgpencol(0.65,0.65,0.65)
    cgrect(xShift*reset(nTrial),0,bar_width1,bar_height1)
    cgpencol(0.85,0.85,0.85)
    cgrect(xShift*reset(nTrial),0,bar_width2,bar_height2)
   
    cgpencol(0.45,0.45,0.45)
    cgrect(xShift*reset(nTrial),50,bar_width3,bar_height3)
    
    % Probabilistic Bet Text
    cgpencol(0,0,0)
    cgfont(Font,FontSize)
    cgtext(num2str(prob_bet(nTrial)), xShift*reset(nTrial), -120)
    
    cgfont(Font,FontSize)
    cgtext(num2str(0), xShift*reset(nTrial), 120)

    cgfont(Font,FontSize*0.8)
    cgtext([num2str(55) ['%']], xShift*reset(nTrial), -37)
    cgfont(Font,FontSize*0.8)
    cgtext([num2str(45) ['%']], xShift*reset(nTrial), 47)