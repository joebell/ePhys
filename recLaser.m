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
    
    %% Setup a dummy AO object outputing zeros, so DO can take its clock
    AO = analogOutput(devName);
    AO.addChannel(0);
    AO.setSampleRate(stimulus.outputSampleRate,size(stimulus.waveform,1));
    AO.putData(zeros(size(stimulus.waveform,1),1));
    AO.start();                     % AO is triggered off of AI
    
    %% Setup DO
    DO = digitalOutput(devName);
    DO.addChannel(stimulus.channels);
    DO.setSampleRate(stimulus.outputSampleRate,size(stimulus.waveform,1));
    DO.putData(sign(stimulus.waveform));  % NsampPerChan x length(channelList)
    DO.start();                     % DO is triggered off of AI  
    
    %% Reset the DAQ on Exit, clean or not.
    cleanObj = onCleanup(@() jDAQmxReset(devName));
        
    %% Start acquisition
    AI.start();
    
    %% Wait for playback/recording to finish

    fprintf('     Recording |');
    tic();
    nCount = 1;
    while (toc < stimLength)
       pause(.1);
       if (mod(nCount,10) == 0)
           fprintf('|');
       else
           fprintf('.');
       end
       nCount = nCount + 1;
       if nCount > 50
           disp(' ');
           fprintf('               ');
           nCount = 0;
       end
    end
    disp('#');
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

    AI.stop();
    AI.clear();
    DO.stop();
    DO.clear();
  
