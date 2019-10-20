clc 
clear all
close all
Dataset = xlsread("Part1_WisconsinDiagnosticBreastCancer.xlsx","Sheet1","A1:J570");
TargetValue = xlsread("Part1_WisconsinDiagnosticBreastCancer.xlsx","Sheet1","K1:K570");
NormalizedData= normalize(Dataset);
Shuffle = randperm(569); 
%% 1st ITERATION
Trainset_1 = NormalizedData(Shuffle(1:456),:);
TrainLabel_1 = TargetValue(Shuffle(1:456),:);
ValidationSet_1 = NormalizedData(Shuffle(457:end),:);
ValidLabel_1 = TargetValue (Shuffle(457:end),:);

% DISTANCE CALCULATION 

for i=1:113  
    for n=1:456
    DistArray(i,n)=sqrt((ValidationSet_1(i,:)-Trainset_1(n,:))*transpose((ValidationSet_1(i,:)-Trainset_1(n,:)))); 

    end
end

% Fuzzy KNN 
for k=1:50
    for i=1:113 
        [Min, Idx] = mink(DistArray(i,:), k);
        for w=1:k
            neighbor = Idx;
            if TrainLabel_1(neighbor(w))== 0
                membership(1,neighbor(w))= 1;
                membership(2,neighbor(w))= 0;
            else
                membership(1,neighbor(w))= 0;
                membership(2,neighbor(w))= 1;
            end
            
        end
        h=0;
        Mu0pay = 0;
        Mu1pay = 0;
        Mu0payda = 0;
        Mu1payda = 0;
        for w=1:k 
            Mu0pay = Mu0pay + membership(1,neighbor(w))*((1/DistArray(i,neighbor(w))).^2);
            Mu0payda = Mu0payda + ((1/DistArray(i,neighbor(w))).^2);   
            Mu1pay = Mu1pay + membership(2,neighbor(w))*((1/DistArray(i,neighbor(w))).^2);
            Mu1payda = Mu1payda + ((1/DistArray(i,neighbor(w))).^2);
        end
        Mu0=Mu0pay/Mu0payda;
        Mu1=Mu1pay/Mu1payda;
        if Mu0 > Mu1
            PredictFuzzy(i)=0;
        else
            PredictFuzzy(i)=1;
        end
    end
    fuzzyerror_1(k) = immse(ValidLabel_1,transpose(PredictFuzzy(1:113)));
end
[Min,Idx] = min(fuzzyerror_1); 
kval(1)= Idx; % k value of the 1st iteration with minimum error rate.
minval(1)= Min; % minimum error rate for 1st iteration.
fprintf('1st Iteration: Best k value is %d with minimum error of %f.\n',Idx,Min)

%% 2nd ITERATION

Trainset_2 = NormalizedData(Shuffle(115:569),:);
TrainLabel_2 = TargetValue(Shuffle(115:569),:);
ValidationSet_2 = NormalizedData(Shuffle(1:114),:);
ValidLabel_2 = TargetValue (Shuffle(1:114),:);

% DISTANCE CALCULATION 

for i=1:114  
    for n=1:455
    DistArray_2(i,n)=sqrt((ValidationSet_2(i,:)-Trainset_2(n,:))*transpose((ValidationSet_2(i,:)-Trainset_2(n,:)))); 

    end
end

% Fuzzy KNN 
for k=1:50
    for i=1:114 
        [Min, Idx] = mink(DistArray_2(i,:), k);
        for w=1:k
            neighbor = Idx;
            if TrainLabel_2(neighbor(w))== 0
                membership(1,neighbor(w))= 1;
                membership(2,neighbor(w))= 0;
            else
                membership(1,neighbor(w))= 0;
                membership(2,neighbor(w))= 1;
            end
            
        end
        h=0;
        Mu0pay = 0;
        Mu1pay = 0;
        Mu0payda = 0;
        Mu1payda = 0;
        for w=1:k 
            Mu0pay = Mu0pay + membership(1,neighbor(w))*((1/DistArray_2(i,neighbor(w))).^2);
            Mu0payda = Mu0payda + ((1/DistArray_2(i,neighbor(w))).^2);   
            Mu1pay = Mu1pay + membership(2,neighbor(w))*((1/DistArray_2(i,neighbor(w))).^2);
            Mu1payda = Mu1payda + ((1/DistArray_2(i,neighbor(w))).^2);
        end
        Mu0=Mu0pay/Mu0payda;
        Mu1=Mu1pay/Mu1payda;
        if Mu0 > Mu1
            PredictFuzzy(i)=0;
        else
            PredictFuzzy(i)=1;
        end
    end
    fuzzyerror_2(k) = immse(ValidLabel_2,transpose(PredictFuzzy(1:114)));
end
[Min,Idx] = min(fuzzyerror_2); 
kval(2)= Idx; % k value of the 2nd iteration with minimum error rate.
minval(2)= Min; % minimum error rate for 2nd iteration.
fprintf('2nd Iteration: Best k value is %d with minimum error of %f.\n',Idx,Min)

%% 3rd ITERATION
A=Shuffle(1:342);
B=Shuffle(457:569);
AB=cat(2,A,B);

Trainset_3 = NormalizedData(AB,:);
TrainLabel_3 = TargetValue(AB,:);
ValidationSet_3 = NormalizedData(Shuffle(343:456),:);
ValidLabel_3 = TargetValue (Shuffle(343:456),:);

% DISTANCE CALCULATION 

for i=1:114  
    for n=1:455
    DistArray_3(i,n)=sqrt((ValidationSet_3(i,:)-Trainset_3(n,:))*transpose((ValidationSet_3(i,:)-Trainset_3(n,:)))); 

    end
end

% Fuzzy KNN 
for k=1:50
    for i=1:114 
        [Min, Idx] = mink(DistArray_3(i,:), k);
        for w=1:k
            neighbor = Idx;
            if TrainLabel_3(neighbor(w))== 0
                membership(1,neighbor(w))= 1;
                membership(2,neighbor(w))= 0;
            else
                membership(1,neighbor(w))= 0;
                membership(2,neighbor(w))= 1;
            end
            
        end
        h=0;
        Mu0pay = 0;
        Mu1pay = 0;
        Mu0payda = 0;
        Mu1payda = 0;
        for w=1:k 
            Mu0pay = Mu0pay + membership(1,neighbor(w))*((1/DistArray_3(i,neighbor(w))).^2);
            Mu0payda = Mu0payda + ((1/DistArray_3(i,neighbor(w))).^2);   
            Mu1pay = Mu1pay + membership(2,neighbor(w))*((1/DistArray_3(i,neighbor(w))).^2);
            Mu1payda = Mu1payda + ((1/DistArray_3(i,neighbor(w))).^2);
        end
        Mu0=Mu0pay/Mu0payda;
        Mu1=Mu1pay/Mu1payda;
        if Mu0 > Mu1
            PredictFuzzy(i)=0;
        else
            PredictFuzzy(i)=1;
        end
    end
    fuzzyerror_3(k) = immse(ValidLabel_3,transpose(PredictFuzzy(1:114)));
end
[Min,Idx] = min(fuzzyerror_3); 
kval(3)= Idx; % k value of the 3rd iteration with minimum error rate.
minval(3)= Min; % minimum error rate for 3rd iteration.
fprintf('3rd Iteration: Best k value is %d with minimum error of %f.\n',Idx,Min)

%% 4th ITERATION

C=Shuffle(1:228);
D=Shuffle(343:569);
CD=cat(2,C,D);

Trainset_4 = NormalizedData(CD,:);
TrainLabel_4 = TargetValue(CD,:);
ValidationSet_4 = NormalizedData(Shuffle(229:342),:);
ValidLabel_4 = TargetValue (Shuffle(229:342),:);

% DISTANCE CALCULATION 

for i=1:114  
    for n=1:455
    DistArray_4(i,n)=sqrt((ValidationSet_4(i,:)-Trainset_4(n,:))*transpose((ValidationSet_4(i,:)-Trainset_4(n,:)))); 

    end
end

% Fuzzy KNN 
for k=1:50
    for i=1:114 
        [Min, Idx] = mink(DistArray_4(i,:), k);
        for w=1:k
            neighbor = Idx;
            if TrainLabel_4(neighbor(w))== 0
                membership(1,neighbor(w))= 1;
                membership(2,neighbor(w))= 0;
            else
                membership(1,neighbor(w))= 0;
                membership(2,neighbor(w))= 1;
            end
            
        end
        h=0;
        Mu0pay = 0;
        Mu1pay = 0;
        Mu0payda = 0;
        Mu1payda = 0;
        for w=1:k 
            Mu0pay = Mu0pay + membership(1,neighbor(w))*((1/DistArray_4(i,neighbor(w))).^2);
            Mu0payda = Mu0payda + ((1/DistArray_4(i,neighbor(w))).^2);   
            Mu1pay = Mu1pay + membership(2,neighbor(w))*((1/DistArray_4(i,neighbor(w))).^2);
            Mu1payda = Mu1payda + ((1/DistArray_4(i,neighbor(w))).^2);
        end
        Mu0=Mu0pay/Mu0payda;
        Mu1=Mu1pay/Mu1payda;
        if Mu0 > Mu1
            PredictFuzzy(i)=0;
        else
            PredictFuzzy(i)=1;
        end
    end
    fuzzyerror_4(k) = immse(ValidLabel_4,transpose(PredictFuzzy(1:114)));
end

[Min,Idx] = min(fuzzyerror_4); 
kval(4)= Idx; % k value of the 4th iteration with minimum error rate.
minval(4)= Min; % minimum error rate for 4th iteration.
fprintf('4th Iteration: Best k value is %d with minimum error of %f.\n',Idx,Min)

%% 5th ITERATION

E=Shuffle(1:114);
F=Shuffle(229:569);
EF=cat(2,E,F);

Trainset_5 = NormalizedData(EF,:);
TrainLabel_5 = TargetValue(EF,:);
ValidationSet_5 = NormalizedData(Shuffle(115:228),:);
ValidLabel_5 = TargetValue (Shuffle(115:228),:);

% DISTANCE CALCULATION 

for i=1:114  
    for n=1:455
    DistArray_5(i,n)=sqrt((ValidationSet_5(i,:)-Trainset_5(n,:))*transpose((ValidationSet_5(i,:)-Trainset_5(n,:)))); 

    end
end

% Fuzzy KNN 
for k=1:50
    for i=1:114 
        [Min, Idx] = mink(DistArray_5(i,:), k);
        for w=1:k
            neighbor = Idx;
            if TrainLabel_5(neighbor(w))== 0
                membership(1,neighbor(w))= 1;
                membership(2,neighbor(w))= 0;
            else
                membership(1,neighbor(w))= 0;
                membership(2,neighbor(w))= 1;
            end
            
        end
        h=0;
        Mu0pay = 0;
        Mu1pay = 0;
        Mu0payda = 0;
        Mu1payda = 0;
        for w=1:k 
            Mu0pay = Mu0pay + membership(1,neighbor(w))*((1/DistArray_5(i,neighbor(w))).^2);
            Mu0payda = Mu0payda + ((1/DistArray_5(i,neighbor(w))).^2);   
            Mu1pay = Mu1pay + membership(2,neighbor(w))*((1/DistArray_5(i,neighbor(w))).^2);
            Mu1payda = Mu1payda + ((1/DistArray_5(i,neighbor(w))).^2);
        end
        Mu0=Mu0pay/Mu0payda;
        Mu1=Mu1pay/Mu1payda;
        if Mu0 > Mu1
            PredictFuzzy(i)=0;
        else
            PredictFuzzy(i)=1;
        end
    end
    fuzzyerror_5(k) = immse(ValidLabel_5,transpose(PredictFuzzy(1:114)));
end
[Min,Idx] = min(fuzzyerror_5); 
kval(5)= Idx;  % k value of the 5th iteration with minimum error rate.
minval(5)= Min; % minimum error rate for 5th iteration.
fprintf('5th Iteration: Best k value is %d with minimum error of %f.\n',Idx,Min)

%% RESULT OF 5 ITERATION

TotalAveragedError=(fuzzyerror_1+fuzzyerror_2+fuzzyerror_3+fuzzyerror_4+fuzzyerror_5)/5;
[Min,Idx] = min(TotalAveragedError);
figure(1);
plot(1:50,TotalAveragedError);

fprintf("According to the 5 fold cross validation, best k value is %d with the error rate of %f.\n",Idx,Min);