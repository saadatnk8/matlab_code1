%% rnet - networking/control script for realtime quadcopter communication
% Usage:
% controller = rnet;
% controller.ctllock(); % Arms the copter and locks it to current computer
% controller.ctlrelease(); % Disarms the copter (opposite of ctllock)
% controller.ctlkill(); % Turns off the program and control board
% controller.throttleset(0-1);
% controller.eulerset(phi, theta, psi);
% controller.videolock(); % Open video stream in a separate window
% controller.videorelease(); % Terminate the video stream
% controller.receive(callback); % For receiving realtime data from copter

function controller = rnet
    CONTROL_PORT = 8888;
    VIDEO_PORT = 8181;
    CONTROL_ADDR = '192.168.8.1';
    MAGIC = ['R', 'N', 'E', 'T'];
    
    COMMANDS = { ...
        {'null', 0}, ...
        {'ctllock', 1}, ...
        {'ctlrelease', 2}, ...
        {'ctlkeepalive', 3}, ...
        {'ctlkill', 4}, ...
        ...%{'rtdata', 5, 'single', 'phi', 'single', 'theta', 'single', 'psi'}, ...
        {'throttleset', 6, 'single', 'thrust'}, ...
        {'eulerset', 7, 'single', 'phi', 'single', 'theta', 'single', 'psi'}, ...
        {'aVideolock', 8}, ...
        {'videorelease', 9} ...
    };
    
    controller = struct;
    
    controller.receive = @receive;
    controller.videolock = @video;
    
    for i = 1:length(COMMANDS)
       c = COMMANDS{i};
       controller.(c{1}) = makecmd(c);
    end
    
    
    function h = makecmd(cmd)
        h = @cmdfunc;
        
        function cmdfunc(varargin)
            send(cmd, varargin);
        end
    end
    

    % run as 'rnet(@somefunction)' where 'somefunction' takes one argument
    % 'obj' that will contain the angles as 'obj.phi', 'obj.theta', and
    % 'obj.psi'. The object also contains 'obj.ax', 'obj.ay', and 'obj.az', the
    % acceleration of the body with gravity subtracted.
    function receive(callback)
        u = udp(CONTROL_ADDR, 'LocalPort', CONTROL_PORT, 'ByteOrder', 'littleEndian' );
        fopen(u);
        c = onCleanup(@() fclose(u));

        while 1
            [raw, count] = fread(u, 4*4, 'uint8');
            if count == 0 || length(raw) < 8
                fprintf('Reading timed out!\n');
            	continue
            end
            
            msg = uint8(raw);
            
            magic = char(msg(1:4));
            cmd = typecast(msg(5:8), 'uint32');
            
            if strcmp(magic', MAGIC)
                obj = struct;
                
                if cmd == 5 % rtdata
                    data = typecast(msg(9:end), 'single')

                    obj.phi = data(1);
                    obj.theta = data(2);
                    obj.psi = data(3);

                    obj.ax = data(4);
                    obj.ay = data(5);
                    obj.az = data(6);
                end
                
                
                ret = callback(obj);
                if ret ~= 0
                    break;
                end
            else
                fprintf('Invalid packet received\n'); 
            end
        end
    end

    function send(cmd, args)
        
        buf = [];
        
        buf = [buf MAGIC];
        buf = [buf typecast(uint32(cmd{2}), 'uint8')]; % The integer identifier of the command
        
        % e.g. get binary chars as such: typecast(single(1), 'uint8')
        
        icmd = 3; % Start of arg descriptions
        for iarg = 1:length(args)
            if icmd > length(cmd) - 3
               fprintf('Too many arguments\n');
               return;
            end
        
            arg = args{iarg};
            type = str2func(cmd{icmd});
            buf = [buf typecast(type(arg), 'uint8')];
            
            
            icmd = icmd + 2;
            
        end
        
        if icmd ~= length(cmd)
           fprintf('Too few arguments\n');
           return;
        end
        
        
        u = udp(CONTROL_ADDR, CONTROL_PORT);
        fopen(u);
        c = onCleanup(@() fclose(u));
        
        fwrite(u, buf, 'uint8');
    end

    % Request a video feed from the quadcopter and display it
    % Note: This requires netcat and mplayer to be installed
    function video()
        if ispc
            system(['nc.exe -L -p ' num2str(VIDEO_PORT) ' | mplayer.exe -fps 31 -cache 1024 - &']);
        elseif isunix
            system(['nc -l -p ' num2str(VIDEO_PORT) ' | mplayer -fps 31 -cache 1024 - &']);
        end
        
        controller.aVideolock();
    end



end