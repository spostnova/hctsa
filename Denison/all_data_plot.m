function all_data()
load('Data/clean_act.mat')
labels = {downsample_act.id};
keywords = {downsample_act.C4};
timeSeriesData = {downsample_act.act};

save('INP_test.mat','timeSeriesData','labels','keywords');
TS_Init('INP_test.mat','catch22',false,'HCTSA.mat');
TS_Compute(false);
TS_Normalize()
TS_LabelGroups('norm')

TS_Cluster()
TS_PlotDataMatrix('norm','colorGroups', true)
TS_PlotLowDim('norm','pca')

TS_TopFeatures('norm','classification') 
end