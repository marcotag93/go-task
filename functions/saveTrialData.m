% Define a function for saving data
function saveTrialData(datadir, subj, runnum, trial_struct)
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
end