function stimulus = quickPulse()

    rigConfig;

    %% Stimulus parameters
    stimulus.name = 'quickPulse.m';
    stimulus.channels = [blueLaser];
    stimulus.preLength = .5; % sec
    stimulus.postLength = .4; % sec
    stimulus.pulseLength = .1; % sec 
    stimulus.length = stimulus.preLength + stimulus.postLength + stimulus.pulseLength;
    stimulus.repRate     = 100; % Hz
    stimulus.dutyCycle   = 2;  % percent  
    stimulus.outputSampleRate = 50000;
 
    %% Construct the stimulus waveform
    preStim  = zeros(stimulus.preLength*stimulus.outputSampleRate,1);
    postStim = zeros(stimulus.postLength*stimulus.outputSampleRate,1);
    stimT = (1/stimulus.outputSampleRate):(1/stimulus.outputSampleRate):stimulus.pulseLength;
    stimPulses = 5/2*(square(2*pi*stimulus.repRate*stimT,stimulus.dutyCycle)+1)';
    stimulus.waveform = [preStim;stimPulses;postStim];
    
    %% Record the data
    data = recLaser(0, stimulus);
       
    %% Filter and display the data
    h1 = fdesign.lowpass('N,F3dB',4,2000/(data.sampleRate/2));
    d1 = design(h1,'butter');
    lpV = filtfilt(d1.sosMatrix,d1.ScaleValues,data.V);
    h2 = fdesign.highpass('N,F3dB',4,10/(data.sampleRate/2));
    d2 = design(h2,'butter');
    lphpV = filtfilt(d2.sosMatrix,d2.ScaleValues,lpV);
      
    t = [1:length(data.V)]./data.sampleRate;
    subplot(2,1,1);
    cla;
    plot(t,lphpV); hold on;
    fill([0 0 stimulus.pulseLength stimulus.pulseLength]+stimulus.preLength,[ylim() fliplr(ylim())],...
        'c','EdgeColor','none','FaceColor','c','FaceAlpha',.5);
    plot(t,lphpV); hold on;
    xlim([0 stimulus.length]);
    xlabel('Time (s)'); ylabel('mV');
    
    subplot(2,1,2);
    cla;
    plot(t,lpV); hold on;
    fill([0 0 stimulus.pulseLength stimulus.pulseLength]+stimulus.preLength,[ylim() fliplr(ylim())],...
       'c','EdgeColor','none','FaceColor','c','FaceAlpha',.5);
    plot(t,lpV); hold on;
    xlim([0 stimulus.length]);
    xlabel('Time (s)'); ylabel('mV');
    
    set(gcf,'Position',[3 5 1020 730]);
    