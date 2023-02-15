clear all

% load data
load('Data/data_GWA_mat/Actigraphy/acti2_cropped_overlap.mat');
acti = acti2_cropped_overlap;
points_per_day = 1440; % 1-min resolution

% cut off incomplete days
for i = 1:length(acti)
    startday = ceil(acti(i).time_datenum(1));
    endday = floor(acti(i).time_datenum(end));
    alldays = acti(i).time_datenum;
    acti_clean(i).id = acti(i).id;
    acti_clean(i).time_raw = acti(i).time_raw([alldays>=startday & alldays <endday]);
    acti_clean(i).time_datetime = acti(i).time_datetime([alldays>=startday & alldays <endday]);
    acti_clean(i).time_datenum = acti(i).time_datenum([alldays>=startday & alldays <endday]);
    acti_clean(i).act = acti(i).act([alldays>=startday & alldays <endday]);
    acti_clean(i).duration = length(acti_clean(i).act)/points_per_day;
    acti_clean(i).weekday = weekday(acti_clean(i).time_datetime); % week start on Sunday, so 1=Sunday etc.
    acti_clean(i).day1_weekday = weekday(acti_clean(i).time_datetime(1)); % week start on Sunday, so 1=Sunday etc.
    
    clear startday endday alldays
end


% choose all participants with recording start on Friday

acti_clean_Fri = acti_clean([acti_clean.day1_weekday]==6);

% choose data with set number of days
Ndays = 7;
acti_clean_Fri_cut = acti_clean_Fri([acti_clean_Fri.duration] >= Ndays);



for i = 1:length(acti_clean_Fri_cut)
    
    acti_clean_Fri_week(i).id = acti_clean_Fri_cut(i).id;
    acti_clean_Fri_week(i).time_raw = acti_clean_Fri_cut(i).time_raw(1:Ndays*points_per_day);
    acti_clean_Fri_week(i).time_datetime = acti_clean_Fri_cut(i).time_datetime(1:Ndays*points_per_day);
    acti_clean_Fri_week(i).time_datenum = acti_clean_Fri_cut(i).time_datenum(1:Ndays*points_per_day);
    acti_clean_Fri_week(i).act = double(acti_clean_Fri_cut(i).act(1:Ndays*points_per_day));
    acti_clean_Fri_week(i).weekday = acti_clean_Fri_cut(i).weekday(1:Ndays*points_per_day);
    acti_clean_Fri_week(i).month = month(acti_clean_Fri_week(i).time_datetime);
    acti_clean_Fri_week(i).day1_month = acti_clean_Fri_week(i).month(1);
    acti_clean_Fri_week(i).day4_month = acti_clean_Fri_week(i).month(4*points_per_day);
    acti_clean_Fri_week(i).day7_month = acti_clean_Fri_week(i).month(end);
    acti_clean_Fri_week(i).day1_weekday = acti_clean_Fri_week(i).weekday(1);
    acti_clean_Fri_week(i).duration = length(acti_clean_Fri_week(i).act)/points_per_day;    
    acti_clean_Fri_week(i).NaNs = sum([acti_clean_Fri_week(i).act] == NaN);  
end



save('Data/data_GWA_mat/Actigraphy/acti2_clean_Fri_week.mat', 'acti_clean_Fri_week')





