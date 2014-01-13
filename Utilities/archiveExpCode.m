%%
%   archiveExpCode.m
%
%
%%
function archiveExpCode(expNum)

    % Make a copy of the the source m-file
    dNum = datestr(now,'YYmmDD');
    if ~isdir(['~/Desktop/Data/',dNum])
        mkdir(['~/Desktop/Data/',dNum]);
    end
    expName = ['~/Desktop/Data/',dNum,'/Exp',dNum,'_',num2str(expNum),'.m'];
    [ST,I] = dbstack();   
    copyfile(ST(2).file,expName);
    disp(['Archived ',ST(2).file,' to ',expName]);