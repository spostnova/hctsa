%% Compare Classification

% pvt.mat required
C1 = [pvt.C1].';
C2 = [pvt.C2].';
C3 = [pvt.C3].';
C4 = [pvt.C4].';
C5 = [pvt.C5].';

[B,BG] = groupcounts(C1); % 81 R, 200 I, 80 V
[B,BG] = groupcounts(C2); % 80 R, 161 I, 80 V
[B,BG] = groupcounts(C3); % 80 R, 161 I, 80 V
[B,BG] = groupcounts(C4); % 80 R, 161 I, 80 V
[B,BG] = groupcounts(C5); % 80 R, 161 I, 80 V
%%
C1 = [pvt.C1].';
C2 = [pvt.C2].';
C3 = [pvt.C3].';
C4 = [pvt.C4].';
C5 = [pvt.C5].';
R = 0;
I = 0;
V = 0;
for i = 1:length(pvt)
    if (C1(i) == C2(i)) && (C2(i) == C3(i)) && (C3(i) == C4(i)) && (C4(i) == C5(i))
        if C1(i) == "Resilient"
            R = R + 1;
        elseif C1(i) == "Intermediate"
            I = I + 1;
        elseif C1(i) == "Vulnerable"
            V = V + 1;
        else 
            disp("Error")
        end
    end
end 
total = ['Total Number of Classification: ',num2str(length(pvt))];
disp(total)
Rdisp = ['Total Agreeance for Resiliant: ',num2str(R)];
disp(Rdisp);

Idisp = ['Total Agreeance for Intermediate: ',num2str(I)];
disp(Idisp)

Vdisp = ['Total Agreeance for Vulnerable: ',num2str(V)];
disp(Vdisp)

undecided = 100*(length(pvt) - (R + I + V))/(length(pvt));
Udisp = ['Non-Unanimous Classification: ',num2str(undecided), '%'];
disp(Udisp)


RMatrix = zeros(5,5)
label = {'C1';'C2';'C3';'C4';'C5'};
RTable = array2table(RMatrix,'RowNames',label,'VariableNames',label);


R = 0;
I = 0;
V = 0;
for i = 1:length(pvt)
    if (C1(i) == C2(i))
        if C1(i) == "Resilient"
            R = R + 1;
        elseif C1(i) == "Intermediate"
            I = I + 1;
        elseif C1(i) == "Vulnerable"
            V = V + 1;
        else 
            disp("Error")
        end
    end
end 



%%





a = [C1,C2,C3,C4,C5];
R = 0;
I = 0;
V = 0;
RMatrix = zeros(5,5);
VMatrix = zeros(5,5);
IMatrix = zeros(5,5);
compcount = 1;
for j = 1:5
    for compcount = 1:5
        for i = 1:size(a,1)
            if j <= 5 && compcount <= 5
                if (a(i,j) == a(i,compcount))
                    if a(i,j) == "Resilient"
                        R = R + 1;
                    elseif a(i,j) == "Intermediate"
                        I = I + 1;
                    elseif a(i,j) == "Vulnerable"
                        V = V + 1;
                    else 
                        disp("Error")
                    end
                end

            elseif compcount == 5
                RMatrix(5,5) = 0;
            end 
        end
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

