%%
function awake_sleep_setup(pvt, acti1_cropped_overlap)
load('Data/pvt.mat')
load('Data/acti1_cropped_overlap.mat')
%% acti pre processing
a = struct('id', {pvt.id}, 'time_datetime',{acti1_cropped_overlap.time_datetime},...
           'act', {acti1_cropped_overlap.act},'duration_days', {acti1_cropped_overlap.duration_days},...
           'C4', {pvt.C4})
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

%%
awake_acti = downsample_act;
% split from awake 8:00am - 7:59pm and sleep 8pm - 7:59am
start = [];
index = 481; % 8*60 + 1
for i = 1:10
    start(i) = index;
    index = index + 720*2;
end

endd = [];
index = 1200; % 480 + 720;
for i = 1:10
    endd(i) = index;
    index = index + 720*2;
end


for i = 1:length(awake_acti)
    awake_acti(i).time_datetime = awake_acti(i).time_datetime([start(1):endd(1), start(2):endd(2), ...
                                                           start(3):endd(3), start(4):endd(4), ...
                                                           start(5):endd(5), start(6):endd(6), ...
                                                           start(7):endd(7), start(8):endd(8), ...
                                                           start(9):endd(9), start(10):endd(10)])  
    awake_acti(i).act = awake_acti(i).act([start(1):endd(1), start(2):endd(2), ...
                                                           start(3):endd(3), start(4):endd(4), ...
                                                           start(5):endd(5), start(6):endd(6), ...
                                                           start(7):endd(7), start(8):endd(8), ...
                                                           start(9):endd(9), start(10):endd(10)])  
end
        


save('awake_acti', 'awake_acti')
%%

% sleep data
sleep_acti = downsample_act;
% split from awake 8:00am - 7:59pm and sleep 8pm - 7:59am
start_sleep = endd(1:end-1) + 1;
end_sleep = start(2:end) - 1;

for i = 1:length(sleep_acti)
    sleep_acti(i).time_datetime = sleep_acti(i).time_datetime([start_sleep(1):end_sleep(1), start_sleep(2):end_sleep(2), ...
                                                           start_sleep(3):end_sleep(3), start_sleep(4):end_sleep(4), ...
                                                           start_sleep(5):end_sleep(5), start_sleep(6):end_sleep(6), ...
                                                           start_sleep(7):end_sleep(7), start_sleep(8):end_sleep(8), ...
                                                           start_sleep(9):end_sleep(9)])  
    sleep_acti(i).act = sleep_acti(i).act([start_sleep(1):end_sleep(1), start_sleep(2):end_sleep(2), ...
                                                           start_sleep(3):end_sleep(3), start_sleep(4):end_sleep(4), ...
                                                           start_sleep(5):end_sleep(5), start_sleep(6):end_sleep(6), ...
                                                           start_sleep(7):end_sleep(7), start_sleep(8):end_sleep(8), ...
                                                           start_sleep(9):end_sleep(9)])  
end
        


save('sleep_acti', 'sleep_acti')

end


