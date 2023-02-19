% required dataset is pvt.mat which can be constructed from data_setup.m
load('Data/pvtSD_acti_overlap.mat')
load('Data/acti1_cropped_overlap.mat')
data_setup(pvtSD_acti_overlap, acti1_cropped_overlap)
load('Data/pvt.mat')
% init matrices
C1 = [pvt.C1].';
C2 = [pvt.C2].';
C3 = [pvt.C3].';
C4 = [pvt.C4].';
C5 = [pvt.C5].';
a = [C1,C2,C3,C4,C5];
R = 0;
I = 0;
V = 0;
RMatrix = zeros(5,5);
VMatrix = zeros(5,5);
IMatrix = zeros(5,5);
compcount = 1; % counter for inserting values into columns of matrix
for j = 1:5 % counter for inserting values into rows for matrix
    for compcount = 1:5
        for i = 1:size(a,1) % parse through all data rows (321)
            if j <= 5 && compcount <= 5 % check index limits
                if (a(i,j) == a(i,compcount)) % if values are equal, find what they are
                    if a(i,j) == "Resilient"
                        R = R + 1; % counter for resilient
                    elseif a(i,j) == "Intermediate"
                        I = I + 1; % intermediate
                    elseif a(i,j) == "Vulnerable"
                        V = V + 1;
                    else 
                        disp("Error")
                    end
                end

            elseif compcount == 5
                RMatrix(5,5) = 0;
            end 
        end % add values to respective matrix
        RMatrix(j, compcount) = RMatrix(j,compcount) + R; 
        R = 0;
        VMatrix(j, compcount) = VMatrix(j,compcount) + V;
        V = 0;
        IMatrix(j, compcount) = IMatrix(j,compcount) + I;
        I = 0;
    end
end
label = {'lapses_mean'
    ;'RT_rm_anti_mean'
    ;'RT_rm_anti_mean_SD_rb'
    ;'rRT_rm_anti_mean'
    ;'rRT_rm_anti_mean_SD_rb'};
Resilience_Table = array2table(RMatrix,'RowNames',label,'VariableNames',label);
Vulnerable_Table = array2table(VMatrix,'RowNames',label,'VariableNames',label);
Intermediate_Table = array2table(IMatrix,'RowNames',label,'VariableNames',label);

Resilience_Table
Intermediate_Table
Vulnerable_Table



%% check if the algorithm above is right or not.
% C5 and C2
comp_matrix = [C2,C5];
counter = 0;
for i = 1:size(C2,1)
    if (comp_matrix(i,1) == comp_matrix(i,2)) 
        if comp_matrix(i,1) == "Resilient"
            counter = counter + 1;
        end
    end
end
dd = ['Number of Agreed Resilient between RT_rm_anti_mean and rRT_rm_anti_mean_SD_rb is: ', num2str(counter)];
disp(dd);


%%
y = [pvtSD_acti_overlap.rRT_rm_anti_mean_SD_relative_baseline].';
y = normalize(y,'range');
[sortedY, sortOrder] = sort(y, 'ascend');
figure(1),bar(sortedY)
lower = quantile(y, 0.25);
upper = quantile(y, 0.75);
yline(lower, '-r',{'Vulnerable'})
yline(upper, '-g' ,{'Resilient'})


y1 =  [pvtSD_acti_overlap.RT_rm_anti_mean_CR].';
y1 = normalize(y1, 'range');
[sortedY, sortOrder] = sort(y1, 'ascend');
figure(2),bar(sortedY)
lower = quantile(y1, 0.25);
upper = quantile(y1, 0.75);
yline(lower, '-r',{'Vulnerable'})
yline(upper, '-g' ,{'Resilient'})

