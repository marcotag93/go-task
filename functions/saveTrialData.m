% Define a function for saving data
function saveTrialData(datadir, subj, runnum, trial_struct, condition)
    filename = fullfile(datadir, sprintf('sub%02d_ses%02d_%s.mat', subj, runnum, condition));

    % Check if the file already exists
    if isfile(filename)
        % If the file already exists, append a number to the filename
        counter = 1;
        while isfile(filename)
            filename = fullfile(datadir, sprintf('sub%02d_ses%02d_%s_%d.mat', subj, runnum, condition, counter));
            counter = counter + 1;
        end
    end

    % Save the file
    save(filename, 'trial_struct');
end