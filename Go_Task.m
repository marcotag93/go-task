
%% Path for the functions folder 
datadir = '.';  % current script folder
path_functions = 'functions';
addpath(genpath(path_functions)); % add folder with functions 

%% Variables 
nTrials = 4;
prompt = {'Enter subject number:','Enter run number:'};
dlgtitle = 'Input';
dims = [1 35];
definput = {'01','001'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
subj = str2double(answer{1});
runnum = str2double(answer{2});
circleRadius = 50;

% Define color names for the second column 
colorNames = {'grey', 'yellow', 'yellow', 'yellow', 'green(SetPeriod)', 'green', 'white'};

% Get the keycode for the spacebar and 'q' key
spaceKey = KbName('space');
qKey = KbName('q');

%% Run 

% Skip sync tests
Screen('Preference', 'SkipSyncTests', 1);

% Open a new window with a white background
[window, rect] = Screen('OpenWindow', 0, [255 255 255]);

% Define the circle's center
[xCenter, yCenter] = RectCenter(rect);
circleCenter = [xCenter, yCenter];

% Initialize the trial structure
trial_struct = cell(nTrials, 6);

% Run the trials
for i = 1:nTrials
    WaitSecs(1);
    
    % Initialize trialType and responseTime to NaN (will be replaced if a key press is detected)
    trialType = NaN;
    responseTime = NaN;
    msg = NaN; 

    % Initialize trialStart to the current time
    trialStart = GetSecs;
    
    % Draw the circles and wait for a random interval between each
    for j = 0:6
        % Start time of the step
        stepStart = GetSecs;
        
        [color, respTime, x, c] = getStepParams(j);
        Screen('FillOval', window, color * 255, ...
               [circleCenter - circleRadius, circleCenter + circleRadius]);
        Screen('Flip', window);
        
        % Wait for the specified time while checking for key press
        while GetSecs - stepStart < respTime / 1000
            [keyIsDown, secs, keyCode] = KbCheck;
            if keyIsDown
                if keyCode(spaceKey)
                    responseTime = secs - stepStart;
                    trialType = j;
                    break;
                elseif keyCode(qKey)
                    % Close all windows and end the script
                    Screen('CloseAll');
                    return;
                end
            end
        end
        
        if ~isnan(trialType)
            % If a key press was detected, break the loop
            break;
        end
    end

    % Display a message based on when the key was pressed
    if isnan(trialType)
        msg = 'No key press detected';
    elseif trialType < 4
        msg = 'Too early!';
    elseif trialType == 4
        msg = '';
    elseif trialType == 5
        msg = '';
    elseif trialType == 6
        msg = 'Too late!';
    end
    DrawFormattedText(window, msg, 'center', 'center');
    Screen('Flip', window);
    
    % Record the trial information
    trial_struct{i, 1} = i; % Trial number
    trial_struct{i, 2} = NaN; % Initialize as NaN
    if ~isnan(trialType)
        trial_struct{i, 2} = colorNames{trialType + 1}; % Trial type (color name where key was pressed)
    end
    trial_struct{i, 3} = responseTime; % Reaction time
    trial_struct{i, 4} = secs - trialStart; % Total trial time
    trial_struct{i, 5} = x; % Variable value of the grey circle
    trial_struct{i, 6} = c; % Variable value of the yellow circle
end

% Save the trial structure to a .mat file
filename = fullfile(datadir, sprintf('sub%02d_ses%02d.mat', subj, runnum));

% Check if the file already exists
if isfile(filename)
    % If the file already exists, append a number to the filename
    counter = 1;
    while isfile(filename)
        filename = fullfile(datadir, sprintf('sub%02d_ses%02d_%d.mat', subj, runnum, counter));
        counter = counter + 1;
    end
end

% Save the file
save(filename, 'trial_struct');

% Close the window
Screen('CloseAll');





