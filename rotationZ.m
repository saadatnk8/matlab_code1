function y = rotationZ(angle)
y = [
    cos(angle) -sin(angle) 0;
    sin(angle) cos(angle) 0;       %Rotation matrix along the Z axis
    0 0 1
    ];
end