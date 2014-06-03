function MainScriptOde(Is,torque)
    
    omegaInit = [0; 0; 0]; %Initial angular velocities
    AInit = eye(3); %Initial orientation    
    stateInit = [omegaInit; reshape(AInit, 9, 1)];

    % Derivatives for ode45
    function d = dstate(t, state)
        torq = torque(t);
        
        omegas = state(1:3);
        domegas = [torq(1) - ((Is(3) - Is(2))*omegas(2)*omegas(3))/Is(1);
                   torq(2) - ((Is(1) - Is(3))*omegas(3)*omegas(1))/Is(2);
                   torq(3) - ((Is(2) - Is(1))*omegas(1)*omegas(2))/Is(3)];
        W = [0 -omegas(3) omegas(2);
             omegas(3) 0 -omegas(1);
            -omegas(2) omegas(1) 0];
        
        A = reshape(state(4:12), 3, 3); 
        
        dA = W*A;
               
        d = [domegas; reshape(dA, 9, 1)];
    end

    update = draw();

    tlast = 0;
    function status = OFcn(t,state,flag)
        status = 0;
        
        if strcmp(flag,'init')
            
        elseif strcmp(flag, 'done')
            
        else
            
            dt = t - tlast;
            tlast = t;
            
            if dt > 1e-3
                pause(dt);
            else
                return
            end
            
            
            if length(state) > 0
                A = reshape(state(4:12), 3, 3);
                update(A);
            end
            
        end
    end
    
    global running;
    running = 1;
    
    
    while running == 1
        options = odeset('OutputFcn',@OFcn,'RelTol',1e-5,'AbsTol',1e-5);
        [times states] = ode45(@dstate, [0 0.5], stateInit, options);
        stateInit = states(size(states,1),:)';
    end

end