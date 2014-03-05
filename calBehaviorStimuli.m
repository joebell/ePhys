function calBehaviorStimuli(expNum)

    % Make a copy of this experiment's code
    archiveExpCode(expNum);
 
    rigConfig();

    sR = 200000;
    stimulus.channels = [redLaser, blueLaser];
    stimulus.outputSampleRate = sR; 
    stimulus.useStim = [1:8];
    stimulus.behaviorCMDBlue      = [0,2,4,8,12,16,32,64];   
    stimulus.redMultiplier = 2.5;
    stimulus.behaviorCMDRed = (max(stimulus.behaviorCMDBlue) - ...
                    stimulus.behaviorCMDBlue).*stimulus.redMultiplier;
    %stimulus.behaviorCMDRed = 0.*stimulus.behaviorCMDRed;
    stimulus.repRate          = [20, 20, 20, 20, 20, 20, 20, 20];
    stimulus.nReps            = [10, 10,  9,  8,  7,  6,  5,  4];
    stimulus.rigIdealDCBlue = blueRigDC(stimulus.behaviorCMDBlue);
    stimulus.rigIdealDCRed  = redRigDC(stimulus.behaviorCMDRed);
    stimulus.rigCMDBlue = round(stimulus.rigIdealDCBlue.*sR./stimulus.repRate);
    stimulus.rigCMDRed  = round(stimulus.rigIdealDCRed.*sR./stimulus.repRate);
    
    % Parameters for pulses
    stimulus.redBG.onset      = 3;
    stimulus.redBG.duration   = 22 - stimulus.redBG.onset;
    stimulus.pulse(1).onset = 5;
    stimulus.pulse(1).duration = .05;
    stimulus.pulse(2).onset = 5.5;
    stimulus.pulse(2).duration = .1;
    stimulus.pulse(3).onset = 6;
    stimulus.pulse(3).duration = .2;
    stimulus.pulse(4).onset = 6.5;
    stimulus.pulse(4).duration = .5;
    stimulus.pulse(5).onset = 7.5;
    stimulus.pulse(5).duration = 1;
    stimulus.pulse(6).onset = 9.5;
    stimulus.pulse(6).duration = 2;
    stimulus.pulse(7).onset = 13.5;
    stimulus.pulse(7).duration = 5;
    stimulus.end        = 25;
    stimulus.interTrialInterval = 30;
    
    stimulus
    
    % Put parameters in a random order
    stimNumbers = [];
    for stimN = stimulus.useStim
        stimNumbers = [stimNumbers;stimN*ones(stimulus.nReps(stimN),1)];
    end
    aPerm = randperm(length(stimNumbers));
    stimulus.stimNumbers = stimNumbers(aPerm);
    
    % Record a trace for each stimulus
    for n = 1:length(stimulus.stimNumbers)
        
        stimN = stimulus.stimNumbers(n);
        disp(' ');
        disp(['Running stimulus #',num2str(stimN),'...']);
        stimulus.stimNumber = stimN;
           
        rigCMDBlue = stimulus.rigCMDBlue(stimN);
        rigCMDRed = stimulus.rigCMDRed(stimN);
        rigRedBG = stimulus.rigCMDRed(1);
        pFreq  = stimulus.repRate(stimN);  
        cycleLength = sR/pFreq;
        
        % Create the red BG starting at red onset
        onset = stimulus.redBG.onset;
        duration = stimulus.redBG.duration;
        redBGWaveform = zeros(stimulus.end*sR,1);
        stSamp = round(onset*sR);
        for cycleN = 1:(duration*pFreq)
        	redBGWaveform(stSamp + cycleLength*(cycleN - 1) + ...
                    [1:cycleLength] - 1) = 5*sqPulse(rigRedBG,cycleLength);
        end        
        
        stimulus.waveform = [redBGWaveform,zeros(stimulus.end*sR,1)];

        % For each pulse in the list make a train
        for pulseN = 1:size(stimulus.pulse,2)
            
            onset = stimulus.pulse(pulseN).onset;
            duration = stimulus.pulse(pulseN).duration;
        
            stSamp = round(onset*sR);
            for cycleN = 1:(duration*pFreq)
                stimulus.waveform(stSamp + cycleLength*(cycleN - 1) + ...
                    [1:cycleLength] - 1,1) = 5*sqPulse(rigCMDRed,cycleLength);
                stimulus.waveform(stSamp + cycleLength*(cycleN - 1) + ...
                    [1:cycleLength] - 1,2) = 5*sqPulse(rigCMDBlue,cycleLength);
            end
        end
                
        recLaser(expNum, stimulus);
        
%         subplot(1,1,1);
%         plot([1:length(stimulus.waveform(:,1))]./sR,stimulus.waveform(:,1),'r'); hold on;
%         plot([1:length(stimulus.waveform(:,2))]./sR,stimulus.waveform(:,2)+6,'b'); hold on;
%         return;
        
        fprintf('     Delaying for inter-trial interval... ');
        pause(stimulus.interTrialInterval);
        disp('done.');
    end
    
    
    
function out = sqPulse(samplesOn,totalSamples)

    out = zeros(totalSamples,1);
    out(1:samplesOn) = 1;