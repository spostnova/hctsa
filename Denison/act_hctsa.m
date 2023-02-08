load('Data/clean_act.mat')


seed = RandStream("twister");
data = datasample(seed, downsample_act, 15, 'Replace',false);

labels = {data.id};
keywords = {data.C1};
timeSeriesData = {data.act};

save('INP_test.mat','timeSeriesData','labels','keywords');
% go to Toolboxes/catch22 and run mexAll()  
mexAll() 
% https://github.com/benfulcher/hctsaTutorial_BonnEEG (control + F catch22)
TS_Init('INP_test.mat','catch22',false,'HCTSA.mat');
TS_Compute(false);
TS_Normalize()


TS_Cluster()
TS_LabelGroups('norm')
TS_PlotDataMatrix('norm','colorGroups', true) % save this
TS_PlotLowDim('norm','pca')


