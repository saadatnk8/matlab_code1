%% Realtime visualization of quadcopter IMU orientation data
function rnetStart
    update = draw();

    controller = rnet;
    
    controller.receive(@rnetFunction);
    function ret = rnetFunction(data)
        
        angles = [data.phi data.theta data.psi];
        rotMat = rotationMatrix(angles);
        
        update(rotMat);
        drawnow;
        
        ret = 0;
    end

end