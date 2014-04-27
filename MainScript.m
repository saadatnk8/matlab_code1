function MainScript

    data = load('cube');         %Loading the cube from the data file
    h = 0;       %Reference to the cube object
    T = 10;     %Time
    dt = 0.1;   %Change in time
    nSteps = ceil(T/dt);

    figure
    myAxes = axes('xlim', [-2 2], 'ylim', [-2 2], 'zlim', [-2 2]);
    view(3)
    grid on
    axis equal
    hold on
    xlabel('x')
    ylabel('y')
    zlabel('z')

    function a = phi(t)
        a = t*(pi/3)/10;    %pi/3 is target phi
    end
    
    function b = theta(t)
        b = t*(pi/2)/10;    %pi/2 is target theta
    end

    function c = psi(t)
        c = t*(pi/4)/10;    %pi/4 is target psi
    end

    for j = 0:nSteps
        if h ~= 0
            delete(h);
        end
        
        t = j*dt;
        angles = [phi(t) theta(t) psi(t)];
        rotMat = rotationMatrix(angles);  %Getting rotation matrix from the function
        
        %data.p gets points of cube from data file and data.faces gets the
        %faces
        
        y = (rotMat*data.p')'; %Correct order: rotMat*data.p' but entire thing transposed to make 'patch' work

        h = patch('Faces',data.faces,'Vertices',y,'FaceColor','r');
        set(gca,'CLim',[0 200])          %Plotting cube and its rotations using patch
        cdata = [110 2 110 2 50 50];
        set(h,'FaceColor','flat',...
            'CData',cdata,...
            'CDataMapping','direct')
        pause(0.1)
        
        changeAngles = [phi((j+1)*dt) theta((j+1)*dt) psi((j+1)*dt)]; %calculating angles for get d(rotMat)/dt
        changeRotMat = (rotationMatrix(changeAngles)-rotMat)/dt; %calculating d(rotMat)/dt
        
        q = rotMat*changeRotMat; %rotMat*d(rotMat)/dt
        
    end

end
