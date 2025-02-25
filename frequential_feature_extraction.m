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

    % Perform feature extraction for the current channel in frequency domain
    % Example: Compute Power Spectral Density (PSD) using Welch's method
    fs = 256; % Sampling frequency (assuming 256 Hz)
    [psd, freq] = pwelch(channelData, hamming(256), 128, 1024, fs); % Adjust window size and overlap as needed
    
    % Example: Calculate total power in the frequency band of interest
    freqBand = [8 12]; % Frequency band of interest (e.g., alpha band)
    idxFreqBand = freq >= freqBand(1) & freq <= freqBand(2);
    totalPower = trapz(psd(idxFreqBand)); % Total power within the specified frequency band
    
    % Display or store the extracted features
    fprintf('Channel: %s\n', channelName{1});
    fprintf('Total Power in Alpha Band: %.4f\n', totalPower);
    
    % Plot the PSD
    figure;
    plot(freq, 10*log10(psd));
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');
    title(['Power Spectral Density for ', channelName{1}]);

    % Perform further processing or analysis for the current channel here
end

% Find the number of channels in the EEG data structure
numChannels = length(fieldnames(edfData));

fprintf('Number of channels: %d\n', numChannels);
