%%

%% acti pre processing
a = acti1_cropped_overlap;
days = [a.duration_days].';
sum(days>floor(mean(days)));
idx = days > floor(mean(days));
reduced_a = a(idx,:);
s = [reduced_a(1).time_datetime.'];
timeofday(s(1))

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


% my attempt
date = {reduced_a(1).time_datetime}.';
delete_date = date{1, 1}(1,[1:length(date{1,1})]);
delete_date.Format = 'yyyy-MM-dd';
cell_table_dates = table2cell(c(:,1));
segment(delete_date == datetime(cell_table_dates(1),:)=[];





