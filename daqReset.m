function daqReset()

    devName = 'Dev1';
    
    import jDAQmx.*;
 
    jDAQmxReset(devName);
