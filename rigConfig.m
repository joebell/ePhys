%% rigConfig.m 

% A configuration file with constants denoting DAQ input lines.
% Also contains telegraph constants for Axopatch 200B
% JSB 1/2010

%% Driver
import jDAQmx.*

%% Board name
devName = 'Dev1';

%% Inputs to DAQ
scaledInput = 1;
telegraphGainInput = 5;
telegraphModeInput = 6;

recordingInputs = [scaledInput];
telegraphInputs = [telegraphGainInput, telegraphModeInput];

%% Outputs from DAQ
blueLaser = 0;

%% Useful Constants

%% For Axopatch 200B
% [Telegraph (V), Vm (mV/mV), I (mV/pA)]
% axoGainTelegraphSettings = [[.5,0,.05];[1,0,.1];[1.5,0,.2];...
%                          [2,.5,.5];[2.5,1,1];[3,2,2];[3.5,5,5];...
%                          [4,10,10];[4.5,20,20];[5,50,50];[5.5,100,100];...
%                          [6,200,200];[6.5,500,500]];
% % {Telegraph (V), Mode}
% axoModeTelegraphSettings = {'I-CLAMP FAST','I-CLAMP NORMAL','I = 0','TRACK','TELEGRAPH ERROR','V-CLAMP'};

%% For AM-Stystems 2400

% [Telegraph (V), Vm (mV/mV), I (mV/pA)]
gainTelegraphSettings     = [[0.0,0,.01];...
                            [0.3,0,.02];...
                            [0.8,0,.05];...
                            [1.3,0,.1];...
                            [1.8,0,.2];...
                            [2.3,0,.5];...
                            [2.8,1,1];...
                            [3.3,2,2];...
                            [3.8,5,5];...
                            [4.3,10,10];...
                            [4.8,20,20];...
                            [5.3,50,50];...
                            [5.8,100,100];...
                            [6.3,0,200];...
                            [6.8,0,500];...
                            [7.3,0,1000];...
                            [8.3,0,2000];...
                            [8.8,0,5000];];
% {Telegraph (V), Mode}
modeTelegraphV = [0;.8;1.8;2.8;3.8;4.8;5.8];
modeTelegraphSettings = {{'Vtest'};...
                            {'Vcomp'};...
                            {'Vclamp'};...
                            {'I=0'};...
                            {'Iclamp'};...
                            {'Iresist'};...
                            {'Ifollow'}};

