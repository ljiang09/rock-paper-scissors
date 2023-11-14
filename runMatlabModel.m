function res = runMatlabModel(data)
    %%%
    % This is starter code for where you should add your MATLAB model.
    % You can place this wherever you want, but keep the function name
    % This function should take in a bunch of data from the EMG sensor
    % and return rock, paper, and scissors, based on what your model
    % predicts. 
    %%%
    
    numCh = 4;
    
    model = load('classifier.mat');
    
    filter_data = zeros(size(data,1),numCh);
    for ch = 1:numCh
        filter_data(:,ch) = highpass(data(:,1+ch), 5,1000);
    end
    
    features = extractTrainedFeatures(filter_data',1:4,1000);
   
    res = model.predict(features);
end
