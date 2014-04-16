function y = rot(angles)

rot1 = rotationZ(angles(1));
rot2 = rotationY(angles(2));
rot3 = rotationZ(angles(3));
    
y = rot1*rot2*rot3;
end