
%% NORMALIZING
clc 
clear all
close all
Dataset = xlsread("Part1_WisconsinDiagnosticBreastCancer.xlsx","Sheet1","A1:J570");
TargetValue = xlsread("Part1_WisconsinDiagnosticBreastCancer.xlsx","Sheet1","K1:K570");
NormalizedData= normalize(Dataset);

%% PARTITIONING 
rng(0); 
Shuffle = randperm(569); 
Trainset = NormalizedData(Shuffle(1:456),:);
TrainLabel = TargetValue(Shuffle(1:456),:);
ValidationSet = NormalizedData(Shuffle(457:end),:);
ValidLabel = TargetValue (Shuffle(457:end),:);

%% DISTANCE CALCULATION

for i=1:113  
    for n=1:456
    DistArray(i,n)=sqrt((ValidationSet(i,:)-Trainset(n,:))*transpose((ValidationSet(i,:)-Trainset(n,:)))); 

    end
end

for i=1:456  
    for n=1:456  
        DistArray(i+113,n)=sqrt((Trainset(i,:)-Trainset(n,:))*transpose((Trainset(i,:)-Trainset(n,:)))); %%
    end  
end  

DistArray(DistArray == 0) = 1e-5; 


%% R radius KNN
ind = 1;
for d=0.3:0.05:13 
    for i=1:569 
   
    A = find(DistArray(i,:)<=d);
    [row,col]=size(A);
        numof0=0;
        numof1=0;
    for b=1:col

        if TrainLabel(A(b))==0
            numof0=numof0+1;
        else
            numof1=numof1+1;
        end
    end
    if numof0 > numof1
        rPredict(i)= 0;
    else
        rPredict(i)= 1;
    end   
    end
    rerror(ind) = immse(ValidLabel,transpose(rPredict(1:113)));
    rerrorTrain(ind) = immse(TrainLabel,transpose(rPredict(114:end))); 
    ind = ind + 1;
end
figure(3);
plot(0.3:0.05:13, rerror,0.3:0.05:13,rerrorTrain),legend('Validation Set', 'Training Set');
title('Error vs r radius');
xlabel('r radius');
ylabel('Error(MSE)');

[Min,Idx] = min(rerror); 
d=0.3+(Idx*0.05);
fprintf('According to the plot, best r radius is %4.2f with minimum error of %f.\n',d,Min)

