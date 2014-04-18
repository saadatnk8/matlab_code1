function y = rotationY(angle)
y = [
    cos(angle) 0 sin(angle);
    0 1 0;                   %Rotation matrix along the Y axis
    -sin(angle) 0 cos(angle)
    ];
end