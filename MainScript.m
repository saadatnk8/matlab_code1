clear; clc;
load cube;
angles = [0 0 0];
targetAngles = [pi/3 pi/2 pi/4];
h = 0;

figure
myAxes = axes('xlim', [-2 2], 'ylim', [-2 2], 'zlim', [-2 2]);
view(3)
grid on
axis equal
hold on
xlabel('x')
ylabel('y')
zlabel('z')

for j = 1:100
    if h ~= 0
        delete(h);
    end
    
    rotMat = rot(angles);
    angles = angles + targetAngles/100;
    
    y = p*rotMat;
    
    h = patch('Faces',faces,'Vertices',y,'FaceColor','r');
    set(gca,'CLim',[0 200])
    cdata = [110 2 110 2 50 50];
    set(h,'FaceColor','flat',...
        'CData',cdata,...
        'CDataMapping','direct')
    pause(0.1)
end
