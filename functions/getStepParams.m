
%% Define colors/answers
function [color, respTime, x, c] = getStepParams(step)

% c = 150; % to test
% x = 200; % to test
x = randperm(2000, 1);
c = randperm(400, 1);
          
switch step
    case 0 % grey (random value) -- total time grey circle: between 1000-3000ms 
        color = [0.5 0.5 0.5];
        respTime = 1000 + x;
        
    case 1 % yellow1 -- total time yellow circle: 800ms
        color = [1.0 1.0 0];
        respTime = 400;
        
    case 2 % TMS stimulus (random) between 400-800ms
        color = [1.0 1.0 0];
        respTime = c; 

%         TMS setup
%         ioObj = io64;
%         data_out=255; % turn all on
%         status = io64(ioObj);
%         address = hex2dec('378');
%         io64(ioObj,address,255);   %in
%         io64(ioObj,address,0);   %out

    case 3 % yellow2 remaining time yellow circle
        color = [1.0 1.0 0];
        respTime = 400 - c;

    case 4 % green1 (SetPeriod): acquisition time - total time green circle: 600ms 
        color = [0 1.0 0];
        respTime = 140;
        
    case 5 % green2: remaining time green circle
        color = [0 1.0 0];
        respTime = 460;
        
    case 6 % white -- transition total time white circle: 1000ms
        color = [1 1 1];
        respTime = 1000;
 
          
end