
%% PART A - Converting Categorical Variables to Binary 
clc 
clear all
close all
rng(3)
[num,txt,raw] = xlsread("FlightDelays.xls","Sheet1","A2:M2202");
b = categorical(txt(:,1));
D=dummyvar(b);
% D matrix: Carrier_CO,Carrier_DH, Carrier_DL, Carrier_MQ, Carrier_OH,
% Carrier_RU, Carrier_UA, Carrier_US

b=categorical(txt(:,3));
K=dummyvar(b);
% K Matrix: Dest_EWR, Dest_JFK, Dest_LGA

b=categorical(txt(:,5));
B=dummyvar(b);
% B Matrix: FL_DATE_1, FL_DATE_10, FL_DATE_11, FL_DATE_12, FL_DATE_13,
% FL_DATE_14, FL_DATE_15, FL_DATE_16, FL_DATE_17, FL_DATE_18, FL_DATE_19,
% FL_DATE_2, FL_DATE_20, FL_DATE_21, FL_DATE_22, FL_DATE_23, FL_DATE_24,
% FL_DATE_25, FL_DATE_26, FL_DATE_27, FL_DATE_28, FL_DATE_29, FL_DATE_3,
% FL_DATE_30, FL_DATE_31, FL_DATE_4, FL_DATE_5, FL_DATE_6, FL_DATE_7,
% FL_DATE_8, FL_DATE_9

b=categorical(txt(:,7));
C=dummyvar(b);
% C Matrix: ORIGIN_BWI, ORIGIN_DCA, ORIGIN_IAD

b=raw(:,10);
b=cell2mat(b);
E=dummyvar(b);
% E Matrix: Day_Week_1, Day_Week_2, Day_Week_3, Day_Week_4, Day_Week_5, Day_Week_6, Day_Week_7 

% Fligh number and Tail number are excluded because they can not affect flight status.
% FL_DATE and DAY_OF_MONTH are the same columns and give the same
% information. So I only included one of them FL_DATE. 

Target= txt(:,12);
c = categorical(Target);
n = grp2idx(c);
n(n==2)=0; % 1 is delayed,0 is ontime: n is target label 

% Converting Clock Columns 
% I scaled them into 24 hours slice of the clock.
CRSDEP=raw(:,1);
CRSDEP=cell2mat(CRSDEP);
CRSDEP(:,1) = CRSDEP(:,1)./100;
CRSDEP=round(CRSDEP);

% Total Arranged Data

FullData=cat(2,CRSDEP,D,K,cell2mat(raw(:,5)),B,C,cell2mat(raw(:,9)),E,n);
filename="ArrangedFlightDelays.xlsx";
xlRange="A2:BD2202";
xlswrite(filename,FullData,xlRange);

% I will go on with excel file named as "ArrangedFlightDelays"

Dataset = xlsread("ArrangedFlightDelays.xlsx","Sheet1","A1:BC2202");
TargetValue = xlsread("ArrangedFlightDelays.xlsx","Sheet1","BD1:BD2202");

Shuffle = randperm(2201); 
Trainset = Dataset(Shuffle(1:1761),:);
TrainLabel = TargetValue(Shuffle(1:1761),:);
ValidationSet = Dataset(Shuffle(1762:end),:);
ValidLabel = TargetValue (Shuffle(1762:end),:);

%% B and B-i part 

tree = fitctree(Trainset,TrainLabel);
view(tree,"Mode","Graph"); % this is an overfitted full tree
PredictedLabel = predict(tree,ValidationSet);
ErrorRate = mse(ValidLabel,PredictedLabel);
fprintf("Error rate with a full tree splitting with Gini Index is %f\n",ErrorRate);

% I tried to calculate error in a different way like below, but it gave me
% the same error rate with mse function. That's why, I will use mse
% function.

%     pay=0;
%     for i=1:440
%        if ValidLabel(i)==PredictedLabel(i)   
%        else
%            pay=pay+1;
%        end
%     end
%     ErrorCalc = pay/440

%% B-ii Part 
for i=1:size(tree.PruneAlpha,1)-1
prunedTree = prune(tree, "Level",i);
PredictedLabel2 = predict(prunedTree,ValidationSet);
ErrorRate(i+1) = mse(ValidLabel,PredictedLabel2);
fprintf("The error rate at the %i level of pruning in Gini Index is %f\n",i,ErrorRate(i+1))
end
figure(1)
plot(ErrorRate)
title('Error vs Levels of Pruning(Gini Index)');
xlabel('Level of Pruning');
ylabel('Error(MSE)');
[MinGini,IdxGini] = min(ErrorRate); 
if IdxGini==1
    fprintf('According to the minimum error tree plot, best pruning is the full tree with minimum error of %f for Gini Index.\n',MinGini);
    view(tree,"Mode","Graph"); 
    PredictedLabelMinG=PredictedLabel;
else
fprintf('According to the minimum error tree plot, best pruning is at %i. level with minimum error of %f for Gini Index.\n',IdxGini,MinGini)
MinimumPrunedTree = prune(tree, "Level",IdxGini);
view(MinimumPrunedTree,"Mode","Graph"); % MinimumPrunedTree is the minimum error tree.
PredictedLabelMinG = predict(MinimumPrunedTree,ValidationSet);
end

% Confusion Matrix
c10=0;
c11=0;
c01=0;
c00=0;
for x=1:440
    if ValidLabel(x)== 1
        if PredictedLabelMinG(x)==0
            c10=c10+1;
        else
            c11=c11+1;
        end
    else
        if PredictedLabelMinG(x)==1
            c01=c01+1;
        else
            c00=c00+1;
        end
    end
end


%% B-iii and B-iv Part
    %Best prune is cancelled.
%% C PART

treeEntropy = fitctree(Trainset,TrainLabel,"SplitCriterion","deviance");
view(treeEntropy,"Mode","Graph"); % this is an overfitted full tree of entropy
PredictedLabelEntropy = predict(treeEntropy,ValidationSet);
ErrorRateEntropy = mse(ValidLabel,PredictedLabelEntropy);
fprintf("Error rate with a full tree splitting with Entropy is %f\n ",ErrorRateEntropy);

for i=1:size(treeEntropy.PruneAlpha,1)-1
prunedTree = prune(treeEntropy,"Level",i);
PredictedLabel3 = predict(prunedTree,ValidationSet);
ErrorRateEntropy(i+1) = mse(ValidLabel,PredictedLabel3);
fprintf("The error rate at the %i level of pruning in Entropy is %f\n",i,ErrorRateEntropy(i+1))
end

figure(2)
plot(ErrorRateEntropy)
title('Error vs Levels of Pruning(Entropy)');
xlabel('Level of Pruning');
ylabel('Error(MSE)');
[MinEnt,IdxEnt] = min(ErrorRateEntropy); 
if IdxEnt==1
    fprintf('According to the minimum error tree plot, best pruning is the full tree with minimum error of %f for Entropy.\n',MinEnt);
    view(treeEntropy,"Mode","Graph"); 
    PredictedLabelMinE=PredictedLabelEntropy;
else
fprintf('According to the minimum error tree plot, best pruning is at %i. level with minimum error of %f for Entropy.\n',IdxEnt,MinEnt);
MinimumPrunedTree2 = prune(treeEntropy, "Level",IdxEnt);
view(MinimumPrunedTree2,"Mode","Graph"); % MinimumPrunedTree is the minimum error tree.
PredictedLabelMinE = predict(MinimumPrunedTree2,ValidationSet);
end


% Confusion Matrix
d10=0;
d11=0;
d01=0;
d00=0;
for x=1:440
    if ValidLabel(x)== 1
        if PredictedLabelMinE(x)==0
            d10=d10+1;
        else
            d11=d11+1;
        end
    else
        if PredictedLabelMinE(x)==1
            d01=d01+1;
        else
            d00=d00+1;
        end
    end
end


%% PART D
MDL = fitctree(Trainset,TrainLabel,"ClassNames",[0;1],"Cost",[0 5;50 0]);
PredictedLabelGM= predict(MDL,ValidationSet);
ErrorRateMisclass = mse(ValidLabel,PredictedLabelGM);
view(MDL,"Mode","Graph");

for i=1:size(MDL.PruneAlpha,1)-1
prunedTree = prune(MDL, "Level",i);
PredictedLabel4 = predict(prunedTree,ValidationSet);
ErrorRateMisclass(i+1) = mse(ValidLabel,PredictedLabel4);
end

figure(3)
plot(ErrorRateMisclass)
title('Error vs Levels of Pruning(Gini Index) with Misclassification Cost');
xlabel('Level of Pruning');
ylabel('Error(MSE)');
[MinGiniMis,IdxGiniMis] = min(ErrorRateMisclass); 

if IdxGiniMis==1
    fprintf('According to the minimum error tree plot, best pruning is the full tree with minimum error of %f for Gini Index with Misclassification cost.\n',MinGiniMis);
    view(MDL,"Mode","Graph"); 
    PredictedLabelGini=PredictedLabelGM;
else
fprintf('According to the minimum error tree plot, best pruning is at %i. level with minimum error of %f for Gini Index with Misclassification cost.\n',IdxGiniMis,MinGiniMis);
MinimumPrunedTree3 = prune(MDL, "Level",IdxGiniMis);
view(MinimumPrunedTree3,"Mode","Graph"); % MinimumPrunedTree is the minimum error tree.
end

cost50=0;
cost5=0;
for x=1:440
    if ValidLabel(x)== 1
        if PredictedLabelGini(x)==0
            cost50=cost50+1;
        else
        end
    else
        if PredictedLabelGini(x)==1
            cost5=cost5+1;
        else
        end
    end
end

Misclassification_Cost = cost50*50 + cost5*5;

fprintf("The Misclassification Cost equals to $%i",Misclassification_Cost)

% Confusion Matrix
e10=0;
e11=0;
e01=0;
e00=0;
for x=1:440
    if ValidLabel(x)== 1
        if PredictedLabelGini(x)==0
            e10=e10+1;
        else
            e11=e11+1;
        end
    else
        if PredictedLabelGini(x)==1
            e01=e01+1;
        else
            e00=e00+1;
        end
    end
end

