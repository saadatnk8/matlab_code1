load cube;         %Loading the cube from the data file
angles = [0 0 0];  %Initial Angles
targetAngles = [pi/3 pi/2 pi/4]; %[phi theta psi] = angles to be rotated by
h = 0;       %Reference to the cube object
T = 10;     %Time
dt = 0.1;   %Change in time

figure
myAxes = axes('xlim', [-2 2], 'ylim', [-2 2], 'zlim', [-2 2]);
view(3)
grid on
axis equal
hold on
xlabel('x')
ylabel('y')
zlabel('z')

for j = 1:dt:T
    if h ~= 0
        delete(h);
    end
    
    rotMat = rotationMatrix(angles);  %Getting rotation matrix from the function
    angles = angles + targetAngles/(T/dt);  %Updating angles for next loop
    
    y = (rotMat*p')'; %Correct order: rotMat*p' but entire thing transposed to make 'patch' work
    
    h = patch('Faces',faces,'Vertices',y,'FaceColor','r');
    set(gca,'CLim',[0 200])          %Plotting cube and its rotations using patch
    cdata = [110 2 110 2 50 50];
    set(h,'FaceColor','flat',...
        'CData',cdata,...
        'CDataMapping','direct')
    pause(0.1)
end
