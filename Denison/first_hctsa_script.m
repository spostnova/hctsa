%% Start Init and Computations

%% C1
rng(1)
down_sample_pvt = datasample(pvt, 50, 'Replace',false);

labels = {down_sample_pvt.id};
keywords = {down_sample_pvt.C1};
timeSeriesData = {down_sample_pvt.lapses};
classification(timeSeriesData, labels, keywords)

%% C2
labels = {down_sample_pvt.id};
keywords = {down_sample_pvt.C2};
timeSeriesData = {down_sample_pvt.lapses};
classification(timeSeriesData, labels, keywords)


%% C3
labels = {down_sample_pvt.id};
keywords = {down_sample_pvt.C3};
timeSeriesData = {down_sample_pvt.lapses};
classification(timeSeriesData, labels, keywords)

%% C4
labels = {down_sample_pvt.id};
keywords = {down_sample_pvt.C4};
timeSeriesData = {down_sample_pvt.lapses};
classification(timeSeriesData, labels, keywords)

%% C5
labels = {down_sample_pvt.id};
keywords = {down_sample_pvt.C5};
timeSeriesData = {down_sample_pvt.lapses};
classification(timeSeriesData, labels, keywords)

% 
% save('INP_test.mat','timeSeriesData','labels','keywords');
% TS_Init('INP_test.mat');
% TS_Compute
% TS_Normalize('mixedSigmoid', [0.4,1]) % use mixedSigmoid
% TS_Cluster()
% TS_PlotDataMatrix('norm') % save this
% 
% TS_LabelGroups('norm')
% TS_PlotDataMatrix('norm','colorGroups', true) % save this





