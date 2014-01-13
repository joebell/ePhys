function aimLaser()

    rigConfig;
    
    stimulus.name = 'aimLaser.m';
    stimulus.channels = [blueLaser];
    stimulus.length = 10;               % sec
    stimulus.repRate     = 20; % Hz
    stimulus.dutyCycle   = 1;  % percent  
    stimulus.outputSampleRate = 200000;
    
    stimT = (1/stimulus.outputSampleRate):(1/stimulus.outputSampleRate):stimulus.length;
    stimulus.waveform = 5/2*(square(2*pi*stimulus.repRate*stimT,stimulus.dutyCycle)+1)';
    stimulus.waveform(end) = 0;
    
    %% Record the data
    data = recLaser(0, stimulus);