%% Realtime visualization of quadcopter IMU orientation data
function rnetStart
    update = draw();

    rnet(@rnetFunction);
    function rnetFunction(data)
        
        angles = [data.phi data.theta data.psi];
        rotMat = rotationMatrix(angles);
        
        update(rotMat);
        pause(0.01)
    end

end