
%% misc
TS_InspectQuality % look at the errors produced by various computation

TS_Normalize('zscore', [0.4,1])  % of those "bad" time series, we take the ones with minimum 40% good features


% from here if you want to use the normalised data, call "norm" 
TS_LabelGroups('norm') % this groups each time series by the keywords

TS_Cluster()
TS_PlotDataMatrix('colorGroups', true)

% svm
TS_Classify('norm')

TS_CompareFeatureSets

TS_TopFeatures % Plot the top features% % 

%% FOR USING ACT
% convert act to double from integer.
A = repelem("placeholder", length(down_sample_pvt));
timeSeriesData = cellstr(A);

for j = 1:length(down_sample_pvt)
    timeSeriesData{j} = double(down_sample_pvt(j).act);
end