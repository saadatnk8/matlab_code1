function y = rotationMatrix(angles)

rotZ1 = rotationZ(angles(1));  % Rotation across Z axis by phi
rotY = rotationY(angles(2));  % Rotation across Y axis by theta
rotZ2 = rotationZ(angles(3));  % Rotation across Z axis by psi
    
y = rotZ1*rotY*rotZ2;    %Output rotation matrix
end