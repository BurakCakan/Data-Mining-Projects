# Classification-Tree-Algorithm- 

Classification Tree Algorithm (Matlab)

I partitioned the data set into training (%80) and validation set (%20). I assumed that all attributes in FlightDelay.xls are independent. 

In Part A: I made the required transformations in order to use "fitctree" function. I converted categorical variables into numerical values. 

In Part B-i: Used "fitctree" and created a full classification tree with Gini index. And calculated error value. 

In Part B-ii: I compared the misclassification errors after pruning at each level. Then I found the minimum error tree. 

In Part C: Insead of Gini index, I repeated part B with "entropy".

In Part D: I solved this example question; "Suppose that an airline company has determined the misclassification cost when the true label is delayed as 50$, where it is 5$ when the true label is ontime. Repeat (b) with Gini Index. Report the misclassification cost in $s."

