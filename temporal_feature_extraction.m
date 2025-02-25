% Load EEG data from an EDF file
edfFile = 'Subject01_1.edf';
edfData = edfread(edfFile);

% Extract EEG data for each channel and process it
for channelName = fieldnames(edfData)'
    % Skip non-EEG fields, such as 'Properties', 'Record Time', etc.
    if ~startsWith(channelName{1}, 'EEG')
        continue;
    end
    
    % Extract EEG data for the current channel
    channelData = edfData.(channelName{1});
    
    % Check if the channel data is a cell and convert it to a double if needed
    if iscell(channelData)
        channelData = cell2mat(channelData);
    end

    % Perform feature extraction for the current channel
    % Example: Calculate RMS amplitude
    amplitude = rms(channelData);
    
    % Example: Calculate AR parameters
    order_AR = 16; % AR order
    ar_parameters = aryule(channelData, order_AR);
    
    % Example: Calculate Hjorth parameters
    hjorth_activity = var(channelData); % Activity
    hjorth_mobility = std(diff(channelData)); % Mobility
    hjorth_complexity = std(diff(diff(channelData))); % Complexity
    
    % Display or store the extracted features
    fprintf('Channel: %s\n', channelName{1});
    fprintf('RMS Amplitude: %.4f\n', amplitude);
    fprintf('AR Parameters: ');
    disp(ar_parameters);
    fprintf('Hjorth Parameters: [Activity=%.4f, Mobility=%.4f, Complexity=%.4f]\n', ...
            hjorth_activity, hjorth_mobility, hjorth_complexity);
    
    % Plot the EEG data for the current channel
    figure;
    plot(channelData);
    title(['EEG Signal for ', channelName{1}]);

    % Perform further processing or analysis for the current channel here
end

% Find the number of channels in the EEG data structure
numChannels = length(fieldnames(edfData));

fprintf('Number of channels: %d\n', numChannels);
