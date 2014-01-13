%%
%   dataStorage.m
%
%   Returns a fileName in which to store data.
%
%   JSB 3/22/2013
%%
function fileName = dataStorage(expNum)
  
    % Come up with the next file name in the sequence
    dNum = datestr(now,'YYmmDD');
    dataPreamble = ['~/Desktop/Data/',dNum,...
        '/RL',dNum,'_',num2str(expNum,'%03d'),'_'];
    trialN = 1;
    while( size(dir([dataPreamble,num2str(trialN,'%03d'),'.mat']),1) > 0)
        trialN = trialN + 1;
    end
    
    fileName = [dataPreamble,num2str(trialN,'%03d'),'.mat'];