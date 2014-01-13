function data = recLaser(expNum, stimulus)

    import jDAQmx.*;

    rigConfig();
    data.inputSampleRate = 10000;
      
    %% Get telegraph data, fail if not set to I=0
    [mode, Vgain, Igain] = getTelegraphs();
    if (~strcmp(mode, 'I=0'))
        disp('Set Amplifier to ''I = 0'' mode and try again.');
        return;
    end
    data.amplifierMode = mode;
    data.voltageScale = Vgain;
    
    %% Setup AI
    AI = analogInput(devName);
    AI.addChannel(recordingInputs);
    stimLength = size(stimulus.waveform,1)./stimulus.outputSampleRate;
    NsampPerChan = round(stimLength*data.inputSampleRate);
    AI.setSampleRate(data.inputSampleRate,NsampPerChan);
    
    %% Setup AO
    AO = analogOutput(devName);
    AO.addChannel(stimulus.channels);
    AO.setSampleRate(stimulus.outputSampleRate,size(stimulus.waveform,1));
    AO.putData(stimulus.waveform);  % NsampPerChan x length(channelList)
    AO.start();                     % AO is triggered off of AI
    
    %% Start acquisition
    AI.start();
    
    %% Wait for playback/recording to finish
    fprintf('     Recording.');
    tic();
    while (toc < stimLength)
        pause(.25);
        fprintf('.');
    end 
    disp('.');
    AI.wait();
    disp('     Stopped recording.');
    
    %% Get data from DAC
    dataStream = AI.getData;
    data.V = 1000*dataStream(:,find(recordingInputs == scaledInput))/data.voltageScale;
    stimulus.waveform = [];
    data.stimulus = stimulus;
    data.sampleRate = data.inputSampleRate;
    
    %% Write data to disk
    if (expNum > 0)
        fileName = dataStorage(expNum); 
        save(fileName,'data');
        disp(['Wrote to: ',fileName]);
    end
    
    %% Stop and clear objects
    AI.stop();
    AI.clear();
    AO.stop();
    AO.clear();