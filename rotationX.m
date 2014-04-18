function y = rotationX(angle)
y = [
    1 0 0;
    0 cos(angle) -sin(angle);      %rotation matrix along the x-axis
    0 sin(angle) cos(angle)
    ];
end