function [feature_table] = extractTrainedFeatures(dataChTimeTr,includedFeatures, Fs)
    
    % List of channels to include (can change to only use some)
    includedChannels = 1:size(dataChTimeTr,1);
    
    % Empty feature table
    feature_table = table();

    
    for f = 1:length(includedFeatures)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Calcuate feature values for 
        % fvalues should have rows = number of trials
        % usually fvales will have coluns = number of channels (but not if
        % it is some comparison between channels)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Check the name of each feature and hop down to that part of the
        % code ("case" is like... in the case that it is this thing.. do
        % this code)
        switch includedFeatures{f}
            % Variance  
            % variance represents the average squared deviation of the
            % signal from the mean. In this case, the signal is all of the
            % timepoints for a single channel and trial.
            %(fvalues = trials x channels)
            case 'var'
                fvalues = squeeze(var(train_data,0,2))';
             
            % Write your own options here by using case 'option name'
            % 'myawesomefeature'
                % my awesome feature code that outputs fvalues
            
            % Mean Absoluate Deviation
            % mean absolute deviation represents the mean of the absolute
            % value of the EMG signal amplitude. In this case, the signal
            % is all of the timepoints for a single channel and trial.
            % https://link.springer.com/article/10.1007/s00779-019-01285-2#Sec6
            case 'mad'
                fvalues = transpose(squeeze(mad(train_data,0,2)));

            % Root mean square
            % root mean square represents the power or energy of the EMG
            % signal. In this case, the signal is all of the timepoints for
            % a single channel and trial.
            % https://link.springer.com/article/10.1007/s00779-019-01285-2#Sec6
            case 'rms'
                fvalues = transpose(squeeze(rms(train_data,2)));
            
            % Standard deviation
            % standard deviation represents the how close each EMG value is
            % to the average value line of the EMG signal. In this case,
            % the signal is all of the timpeoints for a single channel and
            % trial.
            % https://link.springer.com/article/10.1007/s00779-019-01285-2#Sec6
            case 'std'
                fvalues = transpose(squeeze(std(train_data,0,2)));
               
            % Mean frequency
            % mean frequency represents the ratio of the sum of the product
            % of the EMG signal power spectrum and the frequency to the sum
            % of the spectral intensities. In this case, the signal is all
            % of the values within a single channel.
            % https://link.springer.com/article/10.1007/s00779-019-01285-2#Sec6
            case 'meanf'
                fvalues = transpose([meanfreq(squeeze(train_data(1,:,:)),Fs) ; meanfreq(squeeze(train_data(2,:,:)),Fs) ; meanfreq(squeeze(train_data(3,:,:)),Fs) ; meanfreq(squeeze(train_data(4,:,:)),Fs)]);
               
            % Median Frequency
            % median frequency represents the half of the TTP feature,
            % which divides the spectrum into two regional frequencies of
            % the same magnitude.
            % https://link.springer.com/article/10.1007/s00779-019-01285-2#Sec6
            case 'medf'
                fvalues = transpose([medfreq(squeeze(train_data(1,:,:)),Fs) ; medfreq(squeeze(train_data(2,:,:)),Fs) ; medfreq(squeeze(train_data(3,:,:)),Fs) ; medfreq(squeeze(train_data(4,:,:)),Fs)]);

            % Integreated EMG
            % integrated EMG represents the starting point detection index
            % associated with the EMG signal sequence emission point. In
            % this case, the signal is all of the values within a single
            % channel.
            % https://link.springer.com/article/10.1007/s00779-019-01285-2#Sec6
            case 'i_emg'
                fvalues = transpose([sum(abs(squeeze(train_data(1,:,:)))) ; sum(abs(squeeze(train_data(2,:,:)))) ; sum(abs(squeeze(train_data(3,:,:)))) ; sum(abs(squeeze(train_data(4,:,:))))]);

            otherwise
                % If you don't recognize the feature name in the cases
                % above
                disp(strcat('unknown feature: ', includedFeatures{f},', skipping....'))
                break % This breaks out of this round of the for loop, skipping the code below that's in the loop so you don't include this unknown feature
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Put feature values (fvalues) into a table with appropriate names
        % fvalues should have rows = number of trials
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % If there is only one feature, just name it the feature name
        if size(fvalues,2) == 1
            feature_table = [feature_table table(fvalues,...
                'VariableNames',string(strcat(includedFeatures{f})))];
        
        % If the number of features matches the number of included
        % channels, then assume each column is a channel
        elseif size(fvalues,2) == length(includedChannels)
            %Put data into a table with the feature name and channel number
            for  ch = includedChannels
                feature_table = [feature_table table(fvalues(:,ch),...
                    'VariableNames',string(strcat(includedFeatures{f}, '_' ,'Ch',num2str(ch))))]; %#ok<AGROW>
            end
        
        
        else
        % Otherwise, loop through each one and give a number name 
            for  v = 1:size(fvalues,2)
                feature_table = [feature_table table(fvalues(:,v),...
                    'VariableNames',string(strcat(includedFeatures{f}, '_' ,'val',num2str(v))))]; %#ok<AGROW>
            end
        end
    end    

end