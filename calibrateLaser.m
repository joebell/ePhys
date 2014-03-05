function calibrateLaser()

    global aFrame;
   
    dutyCyclesToTest = [16,32,64,128]./5000;
    centerPoint = [320,240];
    centerSize  = 50;


    for n=1:length(dutyCyclesToTest)
        
        vid = setupVideo(); trigger(vid);
        dC = dutyCyclesToTest(n);
        
        frameTimer = timer('ExecutionMode','singleShot','StartDelay',1,...
                        'TimerFcn',{@grabFrame,vid});
        start(frameTimer);
        aimLaser(2,dC);
        stop(frameTimer); delete(frameTimer);
        
        
        figure();
        image(aFrame,'CDataMapping','scaled'); hold on;
        axis equal; axis off;
        caxis([0 2^8]);
        colormap(jet);
        
        xRange = round(centerPoint(1) + [-.5 .5].*centerSize);
        yRange = round(centerPoint(2) + [-.5 .5].*centerSize);
        line(xRange([1 1 2 2 1]),yRange([1 2 2 1 1]),'Color','w');
        
        subImage = aFrame(yRange(1):yRange(2),xRange(1):xRange(2));
        meanVal(n) = mean(subImage(:))
        
    end
    
    stop(vid);

        
function grabFrame(obj,event,vid)

    global aFrame;
    aFrame = peekdata(vid,1);
    
    