function run_magComp_mgarcia()

% runs a matlab experiment together with the LabControl Software
%   You can use the same function on every client, or
%   use the same function on every client, but with different arguments, or
%   use an individual function on every client
%
%   Consider to use a random function as an input argument
%
%   If you intent to save the subjects reslut files back to the network 
%   drive, N:\client_write\, 
%   consider to write individual file names from every computer. Othewise,
%   files will be overwriten without warning and you will have a massive data loss!


%     %% Use one of the Setups (1) or (2) or (3)
%     SETUP = 1; %% indicate which setup you want to use (1), (2) or (3)
%     
%     %% Lab specific, SNS 13, BLU 36
%     % COMPUTER_NAME_PREFIX = 'snslab'; % snslab for sns
%     COMPUTER_NAME_PREFIX = 'econblulab'; % blu lab
    
    %copyfile('N:\sessions\copy_to_client\Anjali\BanditTask_rtfMRI_behav_AN', 'C:\ExpFiles\Anjali')
    addpath('C:\ExpFiles\'); % do not change this line
    % cd 'C:\ExpFiles\';  % do not change this line
    disp('Welcome to the Matlab Experiment!');
    addpath(genpath('C:\ExpFiles\mgarcia\'))
	%cd 'C:\ExpFiles\jschaffner\food-choice-task-master';  % do not change this line
    
    [subCode ,nameSub] = system('hostname'); % do not change this line
    
    nameSub = nameSub(1:(length(nameSub)-1));    
    
    inputTrials1 = 6;
    inputTrials2 = 6;
    
    rafasMother_behaviorPilot(subCode, nameSub, inputTrials1, inputTrials2)

end
