function rScript
    Is = [1 2 3]; %Moment of inertias

    dur = 0.05;
    amp = 2;
    torque = @(t) [ 0 0 1 ]*amp*exp( -(t - 1)^2/dur );

    
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

    function status = OFcn(t,state,flag)
        if strcmp(flag,'init')
            status = [0.1 0 0];
        else
            if length(state) > 0
                A = reshape(state(4:12), 3, 3);
                update(A);
                pause(0.1)
            end
            status = 0;
        end
    end

    options = odeset('OutputFcn',@OFcn,'RelTol',1e-10,'AbsTol',1e-10);
    [t, states] = ode45(@dstate, [0 10], stateInit, options); 

end