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


% down sampling to reduce computation time. Later we can use the original
% pvt data

down_sample_pvt = datasample(pvt, 5, 'Replace',false);

% convert act to double from integer.
A = repelem("placeholder", length(down_sample_pvt));
timeSeriesData = cellstr(A);

for j = 1:length(down_sample_pvt)
    timeSeriesData{j} = double(down_sample_pvt(j).act);
end




% ok this initialises and saves all the variables into INP_test.mat
% so dont need to redo these variables, as long as you don't touch the
% INP_Test matrix file then it should b ok !


save('INP_test.mat','timeSeriesData','labels','keywords');
TS_Init('INP_test.mat');
TS_Compute


TS_InspectQuality % look at the missing data etc
% for our downsample, the best threshold we can take is 40%, but of course
% we should increase this if we can. maybe for the whole dataset.
% also normalises using the mixed sigmoid normalisation for range [0,1]
TS_Normalize('mixedSigmoid', [0.4,1.0])  % of those "bad" time series, we take the ones with minimum 40% good features


% from here if you want to use the normalised data, call "norm" 
TS_LabelGroups('norm') % this groups each time series by the keywords, but in our case we only have one keyword "A" because 
% im not sure what to cluster them manually as. Can look too change

