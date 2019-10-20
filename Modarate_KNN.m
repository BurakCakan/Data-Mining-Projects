
%% NORMALIZING
clc 
clear all
close all

Dataset = xlsread("Part1_WisconsinDiagnosticBreastCancer.xlsx","Sheet1","A1:J570");
TargetValue = xlsread("Part1_WisconsinDiagnosticBreastCancer.xlsx","Sheet1","K1:K570");
figure(1) ;
plotmatrix(Dataset); 
NormalizedData= normalize(Dataset);

%% PARTITIONING (PART A)

rng(0); 
Shuffle = randperm(569); 
Trainset = NormalizedData(Shuffle(1:456),:);
TrainLabel = TargetValue(Shuffle(1:456),:);
ValidationSet = NormalizedData(Shuffle(457:end),:);
ValidLabel = TargetValue (Shuffle(457:end),:);


%% KNN ALGORITHM AND PREDICTION (PART D)
k=1;
for k=1:100
    Mdl = fitcknn(Trainset,TrainLabel,'NumNeighbors',k,'Distance','euclidean');
    PredictedLabelVal = predict(Mdl,ValidationSet);
    error(k) = immse(ValidLabel,PredictedLabelVal);
    PredictedLabelTrain = predict(Mdl, Trainset);
    error_train(k) = immse(TrainLabel, PredictedLabelTrain);

 end
%% PLOT OF ERROR RATE AND K VALUES (PART E)
figure(2);
plot(1:100, error, 1:100, error_train), legend('Validation Set', 'Training Set');
title('Error vs K values');
xlabel('K values');
ylabel('Error(MSE)');
%% PART F
[Min,Idx] = min(error); 
fprintf('According to the plot, best k value is %d with minimum error of %f.\n',Idx,Min)




