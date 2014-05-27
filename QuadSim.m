function QuadSim
    
    Is = [0.0104 0.0206 0.0104]; %Moment of inertias
    r = 0.385;
    radius1 = [0; r; 0];
    radius2 = [r*sin(pi/3); -r*cos(pi/3); 0];
    radius3 = [-r*sin(pi/3); -r*cos(pi/3); 0];

    force1 = [cos(pi/4); 0; sin(pi/4)];
    force2 = rotationZ(-(2*pi/3))*force1;
    force3 = rotationZ((2*pi/3))*force1;

    forces = [force1 force2 force3];

    radii = [radius1 radius2 radius3];

    
    thrusts = [0 0 0];

    function torques = torqfunc(t)
        torques = [0; 0; 0];
        for i = 1:size(radii,2)
            torq = cross(radii(:,i),thrusts(i)*forces(:,i));
            torques = torq+torques;
        end

    end

    function KeyPress(h,evt)
        if evt.Key == 'q'
            thrusts(1) = thrusts(1) + 1;
        end
        if evt.Key == 'a'
            thrusts(1) = thrusts(1) - 1;
        end
        
        if evt.Key == 'w'
            thrusts(2) = thrusts(2) + 1;
        end
        if evt.Key == 's'
            thrusts(2) = thrusts(2) - 1;
        end
        
        if evt.Key == 'e'
            thrusts(3) = thrusts(3) + 1;
        end
        if evt.Key == 'd'
            thrusts(3) = thrusts(3) - 1;
        end
        fprintf('%s\n',evt.Key);
        
    end
    fig = figure;
    set(fig,'KeyPressFcn',@KeyPress);

    MainScriptOde(Is,@torqfunc);
end