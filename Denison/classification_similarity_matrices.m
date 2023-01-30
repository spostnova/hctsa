% required dataset is pvt.mat which can be constructed from data_setup.m

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
label = {'C1';'C2';'C3';'C4';'C5'};
Resilience_Table = array2table(RMatrix,'RowNames',label,'VariableNames',label);
Vulnerable_Table = array2table(VMatrix,'RowNames',label,'VariableNames',label);
Intermediate_Table = array2table(IMatrix,'RowNames',label,'VariableNames',label);

Resilience_Table
Intermediate_Table
Vulnerable_Table

