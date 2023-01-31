% Required mat files - pvtSD_acti_overlap and acti1_cropped_overlap
function data_setup(pvtSD_acti_overlap,acti1_cropped_overlap)
% create structure
pvt = struct('id', {pvtSD_acti_overlap.id}, 'lapses', ...
    {pvtSD_acti_overlap.lapses},'act', {acti1_cropped_overlap.act}, ...
    'sample_CRtime', {pvtSD_acti_overlap.sample_CRtime}, ...
    'C1', {pvtSD_acti_overlap.lapses_mean_CR}, ...
    'C2', {pvtSD_acti_overlap.RT_rm_anti_mean_CR}, ...
    'C3', {pvtSD_acti_overlap.RT_rm_anti_mean_SD_relative_baseline}, ...
    'C4', {pvtSD_acti_overlap.rRT_rm_anti_mean_CR}, ...
    'C5', {pvtSD_acti_overlap.rRT_rm_anti_mean_SD_relative_baseline});

% C1 classifying vulnerability - base classification
C1 = [pvt.C1].';
lower = quantile(C1, 0.25);
upper = quantile(C1, 0.75);

for i = 1:length(pvt)
    if pvt(i).C1 <= lower
        pvt(i).C1 = "Resilient";
    elseif pvt(i).C1  <= upper && pvt(i).C1 > lower
        pvt(i).C1 = "Intermediate";
    elseif pvt(i).C1 > upper
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

end