function update = draw()
    data = load('copter');         %Loading the cube from the data file

    
    myAxes = axes('xlim', [-1 1], 'ylim', [-1 1], 'zlim', [-1 1]);
    view(3)
    grid on
    axis equal
    hold on
    zoom(3);
    xlabel('x')
    ylabel('y')
    zlabel('z')

    camlight left; lighting phong;
    

    h(1) = patch('Faces',data.faces,'Vertices',data.p,'FaceColor','c','EdgeColor','none');
    obj = hgtransform('parent', myAxes);
    set(h,'parent',obj);
    
    function aUpdate(A)
        if size(A, 1) == 3
           A(4,4) = 1; 
        end
        
        set(obj,'matrix', A);
    end

    update = @aUpdate;
end

