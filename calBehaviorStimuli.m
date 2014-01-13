function calBehaviorStimuli(expNum)

    % Make a copy of this experiment's code
    archiveExpCode(expNum);
    
    sR = 200000;
    stimulus.outputSampleRate = sR; 
    stimulus.useStim = [1:8];
    stimulus.behaviorCMD      = [ 0,  4,  8, 16, 32, 64, 128, 240];   
    stimulus.repRate          = [20, 20, 20, 20, 20, 20, 20, 20];
    stimulus.nReps            = [ 4, 10,  9,  8,  7,  6,  5,  4];
    stimulus.rigIdealDC = rigDCfromBCMD(stimulus.behaviorCMD);
    stimulus.rigCMD = round(stimulus.rigIdealDC.*sR.*.01);
 
    
    % Parameters for pulses
    stimulus.pulse(1).onset = 2;
    stimulus.pulse(1).duration = .5;
    stimulus.pulse(2).onset = 3;
    stimulus.pulse(2).duration = 1;
    stimulus.pulse(3).onset = 5;
    stimulus.pulse(3).duration = 2;
    stimulus.pulse(4).onset = 8;
    stimulus.pulse(4).duration = 5;
    stimulus.end        = 15;
    stimulus.interTrialInterval = 30;
    
    % Put parameters in a random order
    stimNumbers = [];
    for stimN = stimulus.useStim
        stimNumbers = [stimNumbers;stimN*ones(stimulus.nReps(stimN),1)];
    end
    aPerm = randperm(length(stimNumbers));
    stimulus.stimNumbers = stimNumbers(aPerm);
    
    % Record a trace for each stimulus
    for n = 1:length(stimulus.stimNumbers)
        
        stimN = stimulus.stimNumbers(n)
        stimulus.stimNumber = stimN;
           
        rigCMD = stimulus.rigCMD(stimN);
        pFreq  = stimulus.repRate(stimN);  
        cycleLength = sR/pFreq;
        stimulus.waveform = zeros(stimulus.end*sR,1);

        % For each pulse in the list make a train
        for pulseN = 1:size(stimulus.pulse,2)
            
            onset = stimulus.pulse(pulseN).onset;
            duration = stimulus.pulse(pulseN).duration;
        
            stSamp = round(onset*sR);
            for cycleN = 1:(duration*pFreq)
                stimulus.waveform(stSamp + cycleLength*(cycleN - 1) + ...
                    [1:cycleLength] - 1) = 5*sqPulse(rigCMD,cycleLength);
            end
        end
                
        recLaser(expNum, stimulus);
        
        pause(stimulus.interTrialInterval);
    end
    
    
    
function out = sqPulse(samplesOn,totalSamples)

    out = zeros(totalSamples,1);
    out(1:samplesOn) = 1;