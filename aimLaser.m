function aimLaser(varargin)

    rigConfig;
    
    if nargin == 0
        stimulus.length = 60;           % sec
        stimulus.dutyCycle = .01;
    elseif nargin == 1
        stimulus.length = varargin{1};
        stimulus.dutyCycle = .01;
    elseif nargin == 2
        stimulus.length = varargin{1};
        stimulus.dutyCycle = varargin{2};
    end
    
    stimulus.name = 'aimLaser.m';
    stimulus.channels = [redLaser, blueLaser];
    stimulus.repRate     = 20; % Hz
    stimulus.outputSampleRate = 200000;
    
    stimT = (1/stimulus.outputSampleRate):(1/stimulus.outputSampleRate):stimulus.length;
    stimulus.waveform = 5/2*(square(2*pi*stimulus.repRate*stimT,stimulus.dutyCycle*100)+1)';
    stimulus.waveform(end) = 0;
    modulationR = (1/2).*square(2*pi*stimulus.repRate/20.*stimT,50)' + .5;
    modulationB = 1 - modulationR;
    stimulus.waveform = [1.*modulationR.*stimulus.waveform,1.*modulationB.*stimulus.waveform];
    %stimulus.waveform = [1.*stimulus.waveform,0.*stimulus.waveform];
    
    %% Record the data
    data = recLaser(0, stimulus);