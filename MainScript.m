data = load('copter');         %Loading the cube from the data file
h = 0;       %Reference to the cube object
T = 10;     %Time
dt = 0.1;   %Change in time
nSteps = ceil(T/dt);

update = draw();

b = 0;
k = 0;

 
phi = @(t) 0*t*(pi/3); %2*t;   %pi/3 is target phi
theta = @(t) 0*t*(pi/2); %pi/6 + 0*t*(pi/2); %pi/2 is target theta
psi = @(t) (pi/4)*t + 0*t*(pi/4);   %pi/4 is target psi
figure(gcf)

for j = 0:nSteps

    t = j*dt;
    angles = [phi(t) theta(t) psi(t)];
    rotMat = rotationMatrix(angles);  %Getting rotation matrix from the function
    
    %data.p gets points of cube from data file and data.faces gets the
    %faces
    
    y = (rotMat*data.p')'; %Correct order: rotMat*data.p' but entire thing transposed to make 'patch' work
        
    %TODO: Does this work?
    dx = 1e-6;
    changeAngles = [phi(t+dx) theta(t + dx) psi(t + dx)]; %calculating angles for get d(rotMat)/dt
    changeRotMat = (rotationMatrix(changeAngles)-rotMat)/dx; %calculating d(rotMat)/dt
    
    c = rotMat'*changeRotMat; %rotMat*d(rotMat)/dt
    
    wX = c(3,2);
    wY = -c(3,1);    %Extracting Angular Velocities from q
    wZ = c(2,1);
    
    w = [wX; wY; wZ];
    u = rotMat*w;
    
    update(rotMat);
    
    if b~= 0
        delete(b);
    end
    b = plot3([0 u(1)], [0 u(2)], [0 u(3)], 'k-', 'LineWidth', 2);
    
    invRotMat = rotMat';
    angVelTensor = changeRotMat*invRotMat;

    if k~= 0
        delete(k);
    end
    q = (rotMat*data.p(1,:)')';
    vel =(changeRotMat*q')';
    norm(vel);
    r = q + 5*vel;
   
    k = plot3([q(1) r(1)],[q(2) r(2)],[q(3) r(3)],'b--','LineWidth',2);
    pause(0.05)
end