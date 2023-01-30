% create structure
pvt = struct('id', {pvtSD_acti_overlap.id}, 'lapses', ...
    {pvtSD_acti_overlap.lapses},'act', {acti1_cropped_overlap.act}, ...
    'sample_CRtime', {pvtSD_acti_overlap.sample_CRtime}, ...
    'lapses_mean_CR', {pvtSD_acti_overlap.lapses_mean_CR}, ...
    'C1', {pvtSD_acti_overlap.lapses_mean_CR}, ...
    'C2', {pvtSD_acti_overlap.RT_rm_anti_mean_CR}, ...
    'C3', {pvtSD_acti_overlap.RT_rm_anti_mean_SD_relative_baseline}, ...
    'C4', {pvtSD_acti_overlap.rRT_rm_anti_mean_CR}, ...
    'C5', {pvtSD_acti_overlap.rRT_rm_anti_mean_SD_relative_baseline});

% C1 classifying vulnerability - base classification
for i = 1:length(pvt)
    if pvt(i).lapses_mean_CR <= 5 && pvt(i).lapses_mean_CR >= 0
        pvt(i).C1 = "Resilient";
    elseif pvt(i).lapses_mean_CR  <= 18 && pvt(i).lapses_mean_CR > 5
        pvt(i).C1 = "Intermediate";
    elseif pvt(i).lapses_mean_CR  > 18
        pvt(i).C1 = "Vulnerable";
    else
        pvt(i).C1 = "NaN";
    end
end 

% C2 - by mean reaction time (pvtSD.RT_rm_anti_mean_CR). 
% Upper 25% should be classified as vulnerable, bottom 25% as resilient, the rest as intermediate.
C2 = [pvt.C2].';
lower = quantile(C2, 0.25);
upper = quantile(C2, 0.75);

for i = 1:length(pvt)
    if pvt(i).C2 <= lower
        pvt(i).C2 = "Resilient";
    elseif pvt(i).C2  <= upper && pvt(i).C2 > lower
        pvt(i).C2 = "Intermediate";
    elseif pvt(i).C2 > upper
        pvt(i).C2 = "Vulnerable";
    else
        pvt(i).C2 = "NaN";
    end
end 

% C3 mean reaction time relative to baseline  - same baseline as C2 
C3 = [pvt.C3].';
lower = quantile(C3, 0.25);
upper = quantile(C3, 0.75);
for i = 1:length(pvt)
    if pvt(i).C3 <= lower
        pvt(i).C3 = "Resilient";
    elseif pvt(i).C3  <= upper && pvt(i).C3 > lower
        pvt(i).C3 = "Intermediate";
    elseif pvt(i).C3 > upper
        pvt(i).C3 = "Vulnerable";
    else
        pvt(i).C3 = "NaN";
    end
end 

% C4 mean reaction speed
C4 = [pvt.C4].';
lower = quantile(C4, 0.25);
upper = quantile(C4, 0.75);
for i = 1:length(pvt)
    if pvt(i).C4 <= lower
        pvt(i).C4 = "Vulnerable";
    elseif pvt(i).C4  <= upper && pvt(i).C4 > lower
        pvt(i).C4 = "Intermediate";
    elseif pvt(i).C4 > upper
        pvt(i).C4 = "Resilient";
    else
        pvt(i).C4 = "NaN";
    end
end 


% C5  mean reaction speed relative to baseline
C5 = [pvt.C5].';
lower = quantile(C5, 0.25);
upper = quantile(C5, 0.75);
for i = 1:length(pvt)
    if pvt(i).C5 <= lower
        pvt(i).C5 = "Vulnerable";
    elseif pvt(i).C5  <= upper && pvt(i).C5 > lower
        pvt(i).C5 = "Intermediate";
    elseif pvt(i).C5 > upper
        pvt(i).C5 = "Resilient";
    else
        pvt(i).C5 = "NaN";
    end
end 
save('pvt.mat', 'pvt')

%% Compare Classification
C1 = [pvt.C1].';
C2 = [pvt.C2].';
C3 = [pvt.C3].';
C4 = [pvt.C4].';
C5 = [pvt.C5].';

[B,BG] = groupcounts(C1); % 58 R, 200 I, 63 V
[B,BG] = groupcounts(C2); % 80 R, 161 I, 80 V
[B,BG] = groupcounts(C3); % 80 R, 161 I, 80 V
[B,BG] = groupcounts(C4); % 80 R, 161 I, 80 V
[B,BG] = groupcounts(C5); % 80 R, 161 I, 80 V

%% Start Init and Computations
%% C1
down_sample_pvt = datasample(pvt, 50, 'Replace',false);

labels = {down_sample_pvt.id};
keywords = {down_sample_pvt.C1};
timeSeriesData = {down_sample_pvt.lapses};
save('INP_test.mat','timeSeriesData','labels','keywords');
TS_Init('INP_test.mat');
TS_Compute
TS_Cluster()
TS_PlotDataMatrix
%% C2
labels = {down_sample_pvt.id};
keywords = {down_sample_pvt.C2};
timeSeriesData = {down_sample_pvt.lapses};
save('INP_test.mat','timeSeriesData','labels','keywords');
TS_Init('INP_test.mat');
TS_Compute
TS_Cluster()
TS_PlotDataMatrix
%% C3
labels = {down_sample_pvt.id};
keywords = {down_sample_pvt.C3};
timeSeriesData = {down_sample_pvt.lapses};
save('INP_test.mat','timeSeriesData','labels','keywords');
TS_Init('INP_test.mat');
TS_Compute
TS_Cluster()
TS_PlotDataMatrix
%% C4
labels = {down_sample_pvt.id};
keywords = {down_sample_pvt.C4};
timeSeriesData = {down_sample_pvt.lapses};
save('INP_test.mat','timeSeriesData','labels','keywords');
TS_Init('INP_test.mat');
TS_Compute
TS_Cluster()
TS_PlotDataMatrix
%% C5
labels = {down_sample_pvt.id};
keywords = {down_sample_pvt.C5};
timeSeriesData = {down_sample_pvt.lapses};
save('INP_test.mat','timeSeriesData','labels','keywords');
TS_Init('INP_test.mat');
TS_Compute
TS_Cluster()
TS_PlotDataMatrix






%% misc
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

%% FOR USING ACT
% convert act to double from integer.
A = repelem("placeholder", length(down_sample_pvt));
timeSeriesData = cellstr(A);

for j = 1:length(down_sample_pvt)
    timeSeriesData{j} = double(down_sample_pvt(j).act);
end