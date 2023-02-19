function awake_plot()
labels = {awake_acti.id};
keywords = {awake_acti.C4};
timeSeriesData = {awake_acti.act};

save('INP_test.mat','timeSeriesData','labels','keywords');
TS_Init('INP_test.mat','catch22',false,'HCTSA.mat');
TS_Compute(false);
TS_Normalize()
TS_LabelGroups('norm')

TS_Cluster()
TS_PlotDataMatrix('norm','colorGroups', true) % save this
TS_PlotLowDim('norm','pca')
TS_TopFeatures('norm','classification') % figure 2, there should be clear differences 
end