clc 
clear all
close all

A= xlsread("UniversalBank.xls","Data","B4:D5004");
B= xlsread("UniversalBank.xls","Data","F4:I5004");
C= xlsread("UniversalBank.xls","Data","K4:N5004");
Dataset = cat(2,A,B,C); %ID number and Zip code columns are excluded.
TargetValue = xlsread("UniversalBank.xls","Data","J4:J5004");
rng(0);
%% Binning of Age
Age=Dataset(:,1);
figure(1);
histogram(Age); % I looked at the distribution of data in age attribute.
h = 2*iqr(Age)*(5000.^(-1/3)); binwidth_Age = round((max(Age)-min(Age))/h); % "I used Freedman-Diaconis Rule" in ..
% order to predict bin width as a rule of thumb. 

Y = discretize(Age,[min(Age) min(Age)+binwidth_Age min(Age)+(2*binwidth_Age) max(Age)],'categorical',{'1','2','3'}); 
% 1:Young-Aged(23-42) , 2:Middle-Aged(42-61) , 3:Old-Aged.

%Y = discretize(X,edges, 'categorical',{'-3sigma', '-2sigma', '-sigma', 'sigma', '2sigma', '3sigma'});
Dataset(:,1)= Y; %Categorical Age columnunu Datasete att?k.

%% Binning of Exp

Exp=Dataset(:,2);
figure(2);
histogram(Exp);

% If we look at the min, max value and the histogram plot of the Exp column,
% there are negative values that are anormal for the year. As a data
% analyst, I thought that there should be a mistake during typing the value
% by writing minus accidentally. I transformed them to positive integers.

for i=1:5000 %This for loop does the process that I explained above. 
    
    if Exp(i,1)<0
        Exp(i,1)=Exp(i,1)*(-1);
    else
    end
end

h = 2*iqr(Exp)*(5000.^(-1/3)); binwidth_Exp = round((max(Exp)-min(Exp))/h); % "I used Freedman-Diaconis Rule" in ..
% order to predict bin width as a rule of thumb. 

Z = discretize(Exp,[min(Exp) min(Exp)+binwidth_Exp min(Exp)+(2*binwidth_Exp) max(Age)],'categorical',{'1','2','3'}); 
% 1:Not so experienced , 2:Experienced , 3:Very experienced
Dataset(:,2)= Z;

%% Binning of Income

Inc=Dataset(:,3);
figure(3);
histogram(Inc);
h = 2*iqr(Inc)*(5000.^(-1/3)); binwidth_Inc = round((max(Inc)-min(Inc))/h); % "I used Freedman-Diaconis Rule" in ..
% order to predict bin width as a rule of thumb. 

V = discretize(Inc,[min(Inc) min(Inc)+binwidth_Inc min(Inc)+(2*binwidth_Inc) min(Inc)+(3*binwidth_Inc) min(Inc)+(4*binwidth_Inc) min(Inc)+(5*binwidth_Inc) min(Inc)+(6*binwidth_Inc) max(Inc)],'categorical',{'1','2','3','4','5','6','7'}); 
% 1:8k-39k ,2:39k-70k ,3:70k-101k ,4:101k-132k ,5:132k-163k ,6:163k-194k,7:194k-225k
Dataset(:,3)= V;

%% Binning of Family

Fam=Dataset(:,4);
figure(4);
histogram(Fam); % According to the histogram, data is not widely distributed. So I did not use any theorem.
% order to predict bin width as a rule of thumb. 

W = discretize(Fam,[1 2 3.5 4],'categorical',{'1','2','3'}); 
% 1:Small Family(1) , 2:Middle-sized Family(2-3), 3:Big Family(4)
Dataset(:,4)= W;

%% Binning of CCAvg

CCAvg=Dataset(:,5);
figure(5);
histogram(CCAvg); % According to the histogram, data is not widely distributed. So I did not use any theorem.
% order to predict bin width as a rule of thumb. 

W = discretize(CCAvg,[0 2 5 10],'categorical',{'1','2','3'}); 
% 1:Low Expenditure(1k-3k) , 2:Middle-sized Expenditure(3k-6k), 3:High Expenditure(6k-10k)
Dataset(:,5)= W;

%% Binning of MORTGAGE

Mort=Dataset(:,7);
figure(6);
histogram(Mort); % According to the histogram, data is not widely distributed. So I did not use any theorem.

h = 2*iqr(Mort)*(5000.^(-1/3)); binwidth_Mort = round((max(Mort)-min(Mort))/h);
W = discretize(CCAvg,[min(Mort) min(Mort)+binwidth_Mort min(Mort)+3*binwidth_Mort min(Mort)+5*binwidth_Mort max(Mort)],'categorical',{'1','2','3','4'}); 
% 1:Low Mortgage Expenditure(0k-54k) , 2:Middle-sized Mortgage
% Expenditure(54k-162k), 3:High Mortgage Expenditure(162k-270k), 4:Very High Mortgage Expenditure(270k-635k)
Dataset(:,7)= W;

%Right now, all of data in dataset are categorical.

%% Naive Bayes Classification

Shuffle = randperm(5000); 
Trainset = Dataset(Shuffle(1:4000),:);
TrainLabel = TargetValue(Shuffle(1:4000),:);
ValidationSet = Dataset(Shuffle(4001:end),:);
ValidLabel = TargetValue (Shuffle(4001:end),:);

classes=unique(TrainLabel); %Which class labels we have in data.
nc=length(classes); % number of classes

for i=1:2
    PriorProb(i)=sum(TrainLabel==classes(i))/length(TrainLabel);
end
%PriorProb(1) equals the prior prob. of being 0 and another equals 1's.
TotalZeros=find(TrainLabel==0);
TotalOnes=find(TrainLabel==1);
payda0=length(TotalZeros);
payda1=length(TotalOnes);
for i=1:1000
    
    for k=1:11
          IndexOfAtt=find(Trainset(:,k)==ValidationSet(i,k));
          a=TotalZeros(ismember(TotalZeros,IndexOfAtt));
          pay0=length(a);
          b=TotalOnes(ismember(TotalOnes,IndexOfAtt));
          pay1=length(b);
          ZeroProbOfAtt(k)= pay0/payda0;
          OneProbOfAtt(k)= pay1/payda1;
         
    end
     ZeroProbOfAtt(ZeroProbOfAtt==0)=1e-5; % If the prob is zero and since it is multiplied by other probabilities,those ...
     OneProbOfAtt(OneProbOfAtt==0)=1e-5;  %...will also be zero. To avoid this, a small value is taken. Let it be 1e-5. 
     ZeroMultip=1;
        for m=1:length(ZeroProbOfAtt)
            ZeroMultip=ZeroMultip*ZeroProbOfAtt(m);
        end
        OneMultip=1;
        for m=1:length(OneProbOfAtt)
            OneMultip=OneMultip*OneProbOfAtt(m);
        end
          ZeroProb=ZeroMultip*PriorProb(1);
          OneProb=OneMultip*PriorProb(2);
          if ZeroProb>OneProb
              PredictedLabel(i)=0;
          else
                PredictedLabel(i)=1;
          end
end
NaiveBayesError(1) = immse(ValidLabel,transpose(PredictedLabel));


%% Design of Experiments

% In addition to my binning method, I also tried to bin data uniformly from
% 2 categorical binning to 6 categorical binning. 

A= xlsread("UniversalBank.xls","Data","B4:D5004");
B= xlsread("UniversalBank.xls","Data","F4:I5004");
C= xlsread("UniversalBank.xls","Data","K4:N5004");
Dataset2 = cat(2,A,B,C); 
TargetValue = xlsread("UniversalBank.xls","Data","J4:J5004");

Shuffle = randperm(5000); 

W = discretize(Fam,[1 2 3.5 4],'categorical',{'1','2','3'}); 
% 1:Small Family(1) , 2:Middle-sized Family(2-3), 3:Big Family(4)
Dataset2(:,4)= W;

for n=2:6
    Y = discretize(Age,n); %Different discreatizations
    Dataset2(:,1)= Y;
    Y= discretize(Exp,n);
    Dataset2(:,2)= Y;
    Y= discretize(Inc,n);
    Dataset2(:,3)= Y;
    Y= discretize(CCAvg,n);
    Dataset2(:,5)= Y;
    Y= discretize(Mort,n);
    Dataset2(:,7)= Y;
    
Trainset = Dataset2(Shuffle(1:4000),:);
TrainLabel = TargetValue(Shuffle(1:4000),:);
ValidationSet = Dataset2(Shuffle(4001:end),:);
ValidLabel = TargetValue (Shuffle(4001:end),:);

classes=unique(TrainLabel); %Which class labels we have in data.
nc=length(classes); % number of classes

for i=1:2
    PriorProb(i)=sum(TrainLabel==classes(i))/length(TrainLabel);
end

%PriorProb(1) equals the prior prob. of being 0 and another equals 1's.
TotalZeros=find(TrainLabel==0);
TotalOnes=find(TrainLabel==1);
payda0=length(TotalZeros);
payda1=length(TotalOnes);

    
    for i=1:1000
    
        for k=1:11
          IndexOfAtt=find(Trainset(:,k)==ValidationSet(i,k));
          a=TotalZeros(ismember(TotalZeros,IndexOfAtt));
          pay0=length(a);
          b=TotalOnes(ismember(TotalOnes,IndexOfAtt));
          pay1=length(b);
          ZeroProbOfAtt(k)= pay0/payda0;
          OneProbOfAtt(k)= pay1/payda1;
         
        end
     ZeroProbOfAtt(ZeroProbOfAtt==0)=1e-5; % If the prob is zero and since it is multiplied by other probabilities,those ...
     OneProbOfAtt(OneProbOfAtt==0)=1e-5;  %...will also be zero. To avoid this, a small value is taken. Let it be 1e-5. 
     ZeroMultip=1;
        for m=1:length(ZeroProbOfAtt)
            ZeroMultip=ZeroMultip*ZeroProbOfAtt(m);
        end
        OneMultip=1;
        for m=1:length(OneProbOfAtt)
            OneMultip=OneMultip*OneProbOfAtt(m);
        end
          ZeroProb=ZeroMultip*PriorProb(1);
          OneProb=OneMultip*PriorProb(2);
          if ZeroProb>OneProb
              PredictedLabel(i)=0;
          else
                PredictedLabel(i)=1;
          end
end
NaiveBayesError(n) = immse(ValidLabel,transpose(PredictedLabel));
 
end

plot(1:1:6,NaiveBayesError);
title('Error vs Binning Number');
xlabel('Binning Number');
ylabel('Error(MSE)');

[Min,Idx] = min(NaiveBayesError);

%% Result Of Experiments

if Idx==1 
    fprintf("We have reached the minimum error with %f by Freedman Diaconis Rule in binning .\n",Min)
elseif Idx==2
       fprintf("We have reached the minimum error with %f by binning %1.0f uniform division .\n",Min,Idx)
elseif Idx==3
       fprintf("We have reached the minimum error with %f by binning %1.0f uniform division .\n",Min,Idx)
elseif Idx==4
       fprintf("We have reached the minimum error with %f by binning %1.0f uniform division .\n",Min,Idx)
elseif Idx==5
       fprintf("We have reached the minimum error with %f by binning %1.0f uniform division .\n",Min,Idx)
else
       fprintf("We have reached the minimum error with %f by binning %1.0f uniform division .\n",Min,Idx)
end

%% NAIVE RULE COMPARISION

for g=1:1000 %According to the naive rule, data is predicted as the majority of classes ("0").
NaivePred(g,1)=0;
end
NaiveRuleError = immse(ValidLabel,NaivePred);

if Min<NaiveRuleError
fprintf("Error rate with Naive Bayes classification is %f.\n",Min)
fprintf("Error rate with Naive Rule is %f.\n",NaiveRuleError)
fprintf("Our algorithm is working well because error rate with Naive Bayes is lower than Naive Rule.\n")
else
    fprintf("Naive Bayes classification does not work well.")
end



