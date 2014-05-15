%% rnet - receiver script for realtime quadcopter euler angles
% run as 'rnet(@somefunction)' where 'somefunction' takes one argument
% 'obj' that will contain the angles as 'obj.phi', 'obj.theta', and
% 'obj.psi'
function rnet(callback)
    CONTROL_PORT = 8888;

    u = udp('192.168.8.1','LocalPort', CONTROL_PORT, 'ByteOrder', 'littleEndian');
    fopen(u);
    c = onCleanup(@() fclose(u));

    while 1
        %magic = char(fread(u, 4, 'char')');
        if  1 %strcmp(magic, 'RNET')
            obj = struct;
            data = fread(u, 3, 'float32');
            obj.phi = data(1);
            obj.theta = data(2);
            obj.psi = data(3);
            
            callback(obj);
        else
            fprintf('Invalid packet received'); 
        end
    end
end