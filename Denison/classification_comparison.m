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



