
%% Path
datadir = pwd;  % current script folder
path_functions = 'functions';
addpath(genpath(path_functions)); % add folder with functions 

%% Set the rendering engine for MATLAB
set(0, 'DefaultFigureRenderer', 'opengl'); % 'painters' or 'opengl' 

%% Starting GUI 
        
% Create a figure
f = figure('Position', [300, 300, 400, 300], 'MenuBar', 'none', 'NumberTitle', 'off', 'Name', 'Input');

% Create radio buttons in a button group
bg = uibuttongroup(f, 'Position', [0.05 0.7 0.9 0.25]);
radio_fixed = uicontrol(bg, 'Style', 'radiobutton', 'String', 'Fixed', 'Units', 'normalized', 'Position', [0.1 0.5 0.4 0.5]);
radio_random = uicontrol(bg, 'Style', 'radiobutton', 'String', 'Random', 'Units', 'normalized', 'Position', [0.6 0.5 0.4 0.5]);

% Create and hide grey and yellow checkboxes
checkbox_grey = uicontrol('Style', 'checkbox', 'String', 'Grey Circle', 'Position', [50, 180, 100, 30], 'Visible', 'off');
checkbox_yellow = uicontrol('Style', 'checkbox', 'String', 'Yellow Circle', 'Position', [200, 180, 100, 30], 'Visible', 'off');

% Set the SelectionChangedFcn for the uibuttongroup
bg.SelectionChangedFcn = @(src, event) updateCheckboxes(event, checkbox_grey, checkbox_yellow, radio_random);

% Create input fields and labels
uicontrol('Style', 'text', 'Position', [20, 135, 130, 20], 'String', 'Enter subject number:');
edit_subj = uicontrol('Style', 'edit', 'Position', [150, 135, 180, 25], 'String', '01');

uicontrol('Style', 'text', 'Position', [20, 90, 130, 20], 'String', 'Enter run number:');
edit_runnum = uicontrol('Style', 'edit', 'Position', [150, 90, 180, 25], 'String', '001');

uicontrol('Style', 'text', 'Position', [20, 45, 150, 20], 'String', 'Enter number of trials:');
edit_nTrials = uicontrol('Style', 'edit', 'Position', [150, 45, 180, 25], 'String', '40');

% Create a 'Confirm' button
btn = uicontrol('Style', 'pushbutton', 'String', 'Confirm', 'Position', [150, 10, 100, 30], 'Callback', 'uiresume(gcbf)');

% Wait for the figure to close
uiwait(f);

%% Variables

greyChecked = checkbox_grey.Value;
yellowChecked = checkbox_yellow.Value;

% Default values 
x = 0;
c = 0;

if ishandle(f)
    % Retrieve input values
    subj = str2double(edit_subj.String);
    runnum = str2double(edit_runnum.String);
    nTrials = str2double(edit_nTrials.String);
    
    % Get the radio button values
    if radio_fixed.Value == 1
        condition = 'fixed';
        x = 0;
        c = 0;
    else
        condition = 'random';
        
        % Check if neither checkbox is checked when "Random" is selected
        if greyChecked == 0 && yellowChecked == 0
            close(f); % Close the figure
            error('You must select at least one of the Grey or Yellow circle checkboxes.');
        end
        
    end
    
    % Close the figure now that we've retrieved all data
    close(f);
else
    error('The figure was closed before input values could be retrieved.');
end

% Radius of the circles 
circleRadius = 50;

% Define color names for the second column 
colorNames = {'grey', 'yellow', 'yellow', 'yellow', 'green(SetPeriod)', 'green', 'white'};

% Get the keycode for the spacebar and 'q' key
spaceKey = KbName('space');
qKey = KbName('q');

% % Initialization parallel port 
% ioObj = io64; 
% status = io64(ioObj);
% if status ~= 0
%   error('Failed to initialize io64');
% end

%% Run 

% Skip sync tests
Screen('Preference', 'SkipSyncTests', 1);

% Open a new window with a white background
[window, rect] = Screen('OpenWindow', 0, [255 255 255], [0 0 400 300]); % small window 
% [window, rect] = Screen('OpenWindow', 0, [255 255 255]);

% Define the circle's center
[xCenter, yCenter] = RectCenter(rect);
circleCenter = [xCenter, yCenter];

% Initialize the trial structure
trial_struct = cell(nTrials, 6);

% Run the trials
for i = 1:nTrials
    WaitSecs(1);
        
    % Generate new random values for x and c for every trial if the condition is 'random'
    if strcmp(condition, 'random')
        if greyChecked == 1
            x = randi([1 2000]);
        end
        if yellowChecked == 1
            c = randi([200, 1400]);
        end
    end
    
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
        
        [color, respTime, x, c] = getStepParams(j, condition, x, c);
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
                    % Save data 
                    saveTrialData(datadir, subj, runnum, trial_struct);
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

% Save data 
saveTrialData(datadir, subj, runnum, trial_struct); 

% Close the window
Screen('CloseAll');
