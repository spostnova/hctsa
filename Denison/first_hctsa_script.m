% create structure
pvt = struct('id', {pvtSD_acti_overlap.id}, 'lapses', {pvtSD_acti_overlap.lapses},'act', {acti1_cropped_overlap.act}, 'sample_CRtime', {pvtSD_acti_overlap.sample_CRtime}, 'lapses_mean_CR', {pvtSD_acti_overlap.lapses_mean_CR}, 'PVT', {pvtSD_acti_overlap.lapses_mean_CR});

% classifying vulnerability.
for i = 1:length(pvt)
    if pvt(i).lapses_mean_CR <= 5 && pvt(i).lapses_mean_CR >= 0
        pvt(i).PVT = "Resilient";
    elseif pvt(i).lapses_mean_CR  <= 18 && pvt(i).lapses_mean_CR > 5
        pvt(i).PVT = "Intermediate";
    elseif pvt(i).lapses_mean_CR  > 18
        pvt(i).PVT = "Vulnerable";
    else
        pvt(i).PVT = "NaN";
    end
end 

% save('pvt.mat', 'pvt')

%% 
% down sampling to reduce computation time. Later we can use the original
% pvt data


down_sample_pvt = datasample(pvt, 50, 'Replace',false);


%% Keywords and Labels setup
labels = {pvt.id};
keywords = {pvt.PVT};

%% FOR USING ACT
% convert act to double from integer.
A = repelem("placeholder", length(down_sample_pvt));
timeSeriesData = cellstr(A);

for j = 1:length(down_sample_pvt)
    timeSeriesData{j} = double(down_sample_pvt(j).act);
end

%% FOR USING PVT
timeSeriesData = {pvt.lapses};



%% Start Init and Computations
save('INP_test.mat','timeSeriesData','labels','keywords');
TS_Init('INP_test.mat');
TS_Compute

%% 
TS_InspectQuality % look at the errors produced by various computation

TS_Normalize('zscore', [0.4,1])  % of those "bad" time series, we take the ones with minimum 40% good features


% from here if you want to use the normalised data, call "norm" 
TS_LabelGroups('norm') % this groups each time series by the keywords

TS_Cluster()
TS_PlotDataMatrix('norm','colorGroups', true)

% svm
TS_Classify('norm')

TS_CompareFeatureSets

TS_TopFeatures % Plot the top features% % 
