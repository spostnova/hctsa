<<<<<<< HEAD
function acti_preprocess(pvt, acti1_cropped_overlap)
load('Data/pvt.mat')
load('Data/acti1_cropped_overlap.mat')
=======
%%

load('Data/data_GWA_mat/pvt/pvtSD_acti_overlap.mat')
load('Data/data_GWA_mat/acti1_cropped_overlap.mat')
>>>>>>> 13512b44ba783c17e35069d40541cb4d056e4de7
%% acti pre processing
a = struct('id', {pvt.id}, 'time_datetime',{acti1_cropped_overlap.time_datetime},...
           'act', {acti1_cropped_overlap.act},'duration_days', {acti1_cropped_overlap.duration_days},...
           'C1', {pvt.C1}, 'C2', {pvt.C2}, 'C3', {pvt.C3},'C4', {pvt.C4}, 'C5', {pvt.C5})
days = [a.duration_days].';
idx = days > floor(mean(days));
reduced_a = a(idx);

%% 

% finds out all the dates for each person who has missing data
% the next step is to use these dates and delete it off the dataset 
counter = 0;
for i = 1:length(reduced_a)
    time_datetime1 = {reduced_a.time_datetime}.';
    time_datetime1 = time_datetime1{i, 1}(1,[1:length(time_datetime1{i,1})]);
    time_datetime1.Format = 'yyyy-MM-dd';
    time_datetime1 = transpose(time_datetime1);
    time_datetime1 = cellstr(time_datetime1);
    grouped_table = groupsummary(table(time_datetime1),1);
    for j = 1:size(grouped_table,1)
        if table2array(grouped_table(j,2)) ~= 1440 %60 minutes for 24 hours
            if height(grouped_table) - j == 0 | j == 1 % find where the non-full days are, it should be the first day or the last
                % this shows all entries do not have full days on both the
                % very first day and the very last day.
                counter = counter + 1; % this should equal 440 which is 2*length(reduced_a) or 220
            end
        end
    end
end
disp(counter)
%%
b = reduced_a



% we know that the very first day/month and last day/month are the non-full
% days. So lets find them and delete them

for i = 1:length(b)
    months = month(b(i).time_datetime); 
    days = day(b(i).time_datetime);
    first_month = months(1); % get first month
    first_day = days(1); % get first day
    %
    last_month = months(end); % last month
    last_day = days(end); % last day
    b(i).act = double(b(i).act); % convert to double
    for j = 1:length(b(i).time_datetime)
        % change to NaT if either in the very first month and day, or the
        % very last month and day
        if (day(b(i).time_datetime(j)) == first_day) && (month(b(i).time_datetime(j)) == first_month)
            b(i).time_datetime(j) = NaT; % convert to NaT and NaN so we can remove
            b(i).act(j) = NaN;
        elseif (day(b(i).time_datetime(j)) == last_day) && (month(b(i).time_datetime(j)) == last_month)
            b(i).time_datetime(j) = NaT;
            b(i).act(j) = NaN;
        end
    end
    % remove all entries with NaN and NaT
    b(i).time_datetime = rmmissing(b(i).time_datetime);
    b(i).act = rmmissing(b(i).act);
    disp(i)
end

% find the particpant with the lowest amount of days
minimum = 0;
for i = 1:length(b)
    if i == 1
        minimum = length(b(i).act);
    elseif length(b(i).act) < minimum
        minimum = length(b(i).act);
    end
end
disp(minimum) % 14400 10 days, 14400/60*24


% find how many entries are difference between the smallest dataset
% simply start from the difference + 1 index, so that each participant has
% the same amount of data.
downsample_act = b;
for i = 1:length(downsample_act)
    difference = length(downsample_act(i).act) - minimum;
    if difference ~= 0
        downsample_act(i).act = downsample_act(i).act(difference + 1:end);
        downsample_act(i).time_datetime = downsample_act(i).time_datetime(difference + 1:end);
    end
end

save('clean_act', 'downsample_act')
end
       




