function vid = setupVideo()
   
    imaqreset;
	warning('off','MATLAB:JavaEDTAutoDelegation');
    warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    
    vid = videoinput('dcam',1,'Y8_640x480');
    set(vid.Source,'BusSpeed','S400');
    
    triggerconfig(vid, 'manual')
    set(vid,'FramesPerTrigger',Inf);
	set(vid,'TriggerRepeat',0);
	set(vid,'FrameGrabInterval', 1); 
    
    % Shutter is 1:796, Gain is 16:64 
    vcam(vid, 796, 32);
    % set(vid,'Logging','off');
    start(vid); 
    
    
function vcam(vid, varargin)
    
    brightness = 1;

    if (nargin == 1)
    	shutter = 5000;
    	gain = 80;   
    elseif (nargin == 2)
    	shutter = varargin{1};
    	gain = 80;  
    elseif (nargin == 3)
    	shutter = varargin{1};
    	gain    = varargin{2};
    end
        
    runningFlag = false;
    if strcmp(vid.Running,'on')
        runningFlag = true;
        stop(vid);
    end
    
    % Gain 16-64 
    %   16 = 0 dB
    %   23 = 3.15 dB
    %   32 = 6.02 dB
    %   45 = 8.98 dB
    %   64 = 12.04 dB
    %
    % Shutter 1:798
    %   798 = 49.8 ms
    %   
    %  FrameRate = 960 for 20 Hz
    set(vid.Source,...
        'Exposure',7,...
        'Brightness',brightness,...
        'Gain', gain,...
        'Shutter', shutter,...
        'ShutterMode','manual');
    
    if runningFlag
        start(vid);
    end
    