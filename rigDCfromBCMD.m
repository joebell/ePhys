function rDC = rigDCfromBCMD(bCMD)

    bPD = .01076*bCMD - .02437;
    % rDC = (bPD+.05598)/194.2;   % Old Cal
    rDC = (bPD-.1744)/104.9;     % High Cal Use 
    %rDC = (bPD+.0514)/179.4;     % Low Cal

    
    % Enforce zero = zero
    zIX = find(bCMD <= 0);
    rDC(zIX) = 0;
    
    