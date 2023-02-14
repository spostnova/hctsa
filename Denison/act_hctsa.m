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


TS_TopFeatures('norm','classification') % figure 2, there should be clear differences 
help("MD_hrv_classic")
TS_FeatureSummary(12,'raw',true);

TS_Classify('norm')

%%
% seed = RandStream("twister");
% data = datasample(seed, downsample_act, 100, 'Replace',false);



labels = {downsample_act.id};
keywords = {downsample_act.C4};
timeSeriesData = {downsample_act.act};

save('INP_test.mat','timeSeriesData','labels','keywords');
TS_Init('INP_test.mat');
TS_Compute(false)

%% Trying again but with the subset of awake and sleeping data.
load('Data/awake_acti.mat')
load('Data/sleep_acti.mat')

labels = {awake_acti.id};
keywords = {awake_acti.C4};
timeSeriesData = {awake_acti.act};

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
TS_TopFeatures('norm','classification') % figure 2, there should be clear differences 
TS_Classify('norm')

%% Now try sleeping data

labels = {sleep_acti.id};
keywords = {sleep_acti.C4};
timeSeriesData = {sleep_acti.act};

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
TS_TopFeatures('norm','classification') % figure 2, there should be clear differences 
TS_Classify('norm')
