function classification(timeSeriesData, labels, keywords)
    save('INP_test.mat','timeSeriesData','labels','keywords');
    TS_Init('INP_test.mat');
    TS_Compute
    TS_Normalize('mixedSigmoid', [0.4,1]) % use mixedSigmoid
    TS_Cluster()
    TS_PlotDataMatrix('norm') % save this

    TS_LabelGroups('norm')
    TS_PlotDataMatrix('norm','colorGroups', true) % save this
end