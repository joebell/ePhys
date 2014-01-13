function aimLaser(varargin)

    rigConfig;
    
    if nargin < 1
        stimulus.length = 10;   % sec
    else
        stimulus.length = varargin{1};
    end
    
    stimulus.name = 'aimLaser.m';
    stimulus.channels = [blueLaser];
    stimulus.repRate     = 20; % Hz
    stimulus.dutyCycle   = 1;  % percent  
    stimulus.outputSampleRate = 200000;
    
    stimT = (1/stimulus.outputSampleRate):(1/stimulus.outputSampleRate):stimulus.length;
    stimulus.waveform = 5/2*(square(2*pi*stimulus.repRate*stimT,stimulus.dutyCycle)+1)';
    stimulus.waveform(end) = 0;
    
    %% Record the data
    data = recLaser(0, stimulus);