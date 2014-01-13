function [mode, Vgain, Igain] = getTelegraphs()

    rigConfig();
    
    AI = analogInput(devName);
    AI.addChannel(telegraphInputs);
    sampleRate = 1000; NsampPerChan = 5;
    AI.setSampleRate(sampleRate,NsampPerChan);    
    
	AI.start(); 
    
	AI.wait();                                      
	dataIn = AI.getData(); 
    
    AI.stop();
    AI.clear();
    
    aSample = dataIn(1,:);   
    gainIX = dsearchn(gainTelegraphSettings(:,1),aSample(telegraphInputs == telegraphGainInput));
    modeIX = dsearchn(         modeTelegraphV(:),aSample(telegraphInputs == telegraphModeInput));
    
    mode = modeTelegraphSettings{modeIX};
    Vgain = gainTelegraphSettings(gainIX,2);
    Igain = gainTelegraphSettings(gainIX,3);