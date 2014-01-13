function recLaser(expNum, stimulus)

    rigConfig();
      
    %% Get telegraph data
    [mode, Vgain, Igain] = getTelegraphs();
    if (~strcmp(mode, 'I=0'))
        disp('Set Amplifier to ''I = 0'' mode and try again.');
        return;
    end
    data.amplifierMode = mode;
    data.voltageScale = Vgain;
    
    %% Setup AI
    AI.analogInput(devName);
    AI.addChannel(channelList);  
    AI.setSampleRate(sampleRate,NsampPerChan);
    
    %% Setup AO
    AO.analogOutput(devName);
    AO.addChannel(channelList);
    AO.setSampleRate(sampleRate,NsampPerChan);
    AO.putData(someData);                          % NsampPerChan x length(channelList)
    AO.start();     % AO is triggered off of AI
    

    %% Put data to DAC
    putdata(AO, stimulus.waveform);
    start([AI AO]);
    trigger([AI AO]);
    
    % wait for playback/recording to finish
    fprintf('     Recording.');
    totalSamples = length(stimulus.waveform);
    inputSamples = round(totalSamples*inputSampleRate*overSample/outputSampleRate);
    nsampout = AO.SamplesOutput;
    while (nsampout < totalSamples)
        nsampout = AO.SamplesOutput;
        pause(1);
        fprintf('.');
    end 
    disp('.');
    % stop playback
    stop([AI AO]);
    disp('     Stopped recording.');
    
    %% Get data from DAC
    dataStream = getdata(AI,inputSamples);
    V = 1000*dataStream(:,find(inputList == axoScaledInput))/data.voltageScale;
    data.V = decimate(V,overSample); 
    stimulus.waveform = [];
    data.stimulus = stimulus;
    data.sampleRate = inputSampleRate;
    
    %% Write data to disk
    fileName = dataStorage(expNum); 
    save(fileName,'data');
    disp(['Wrote to: ',fileName]);