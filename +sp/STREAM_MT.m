clear all

load('Data/data_GWA_mat/MT/melSD.mat')

% define number of participants to test
N = length(melSD);

% timeSeriesData = {melSD(1:N).MT_interp};
labels = {melSD(1:N).id};
keywords_double = {melSD(1:N).month};

for i = 1:N
    timeSeriesData{i} = melSD(i).MT_interp(1:10:end);
    if keywords_double{i}== 12 || keywords_double{i}== 1 || keywords_double{i}== 2
        keywords{i} = 'winter';
    elseif keywords_double{i}== 3 || keywords_double{i}== 4 || keywords_double{i}== 5
        keywords{i} = 'spring';
    elseif keywords_double{i}== 6 || keywords_double{i}== 7 || keywords_double{i}== 8
        keywords{i} = 'summer';
    elseif keywords_double{i}== 9 || keywords_double{i}== 10 || keywords_double{i}== 11
        keywords{i} = 'autumn';
        
    end
end

% Save these variables out to INP_test.mat:
save('INP_test.mat','timeSeriesData','labels','keywords');

% Initialize a new hctsa analysis using these data and the default feature library:
TS_Init('INP_test.mat','catch22')


% Compute all missing values in HCTSA.mat:
TS_Compute();

% Inspect for problems
% TS_InspectQuality('summary')
% TS_InspectQuality('full')

% Label the data
TS_LabelGroups('')

% normalize the outputs
TS_Normalize('mixedSigmoid',[0.8,1.0]);

% cluster rows and columns
distanceMetricRow = 'euclidean'; % time-series feature distance
linkageMethodRow = 'average'; % linkage method
distanceMetricCol = 'corr_fast'; % a (poor) approximation of correlations with NaNs
linkageMethodCol = 'average'; % linkage method

TS_Cluster(distanceMetricRow, linkageMethodRow, distanceMetricCol, linkageMethodCol);

% Incorporate group information
TS_PlotDataMatrix('norm'); % don't color according to group labels
TS_PlotDataMatrix('norm','colorGroups',true); % color according to group labels

% Low-dimensional representation
TS_PlotLowDim('norm','pca');

% pairwise similarity matrix of neighbours
TS_SimSearch('whatPlots',{'matrix'});
%TS_SimSearch(1,'whatPlots',{'network'}); % gives an error
TS_SimSearch(1,'whatPlots',{'scatter'});

% specific features
% TS_FeatureSummary(1) % change argument to output different features

% Classify labeled groups
TS_Classify

% Finding informative features
TS_TopFeatures()