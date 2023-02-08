load('Data/clean_act.mat')


% seed = RandStream("twister");
% data = datasample(seed, downsample_act, 15, 'Replace',false);

labels = {downsample_act.id};
keywords = {downsample_act.C4};
timeSeriesData = {downsample_act.act};

save('INP_test.mat','timeSeriesData','labels','keywords');
% go to Toolboxes/catch22 and run mexAll()  
mexAll() 
% https://github.com/benfulcher/hctsaTutorial_BonnEEG (control + F catch22)
TS_Init('INP_test.mat','catch22',false,'HCTSA.mat');
TS_Compute(false);
TS_Normalize()
TS_LabelGroups('norm')
TS_Cluster()
TS_PlotDataMatrix('norm');
TS_PlotDataMatrix('norm','colorGroups', true) % save this
TS_PlotLowDim('norm','pca')


TS_TopFeatures()
