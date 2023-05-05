Error-Aware Markov Blanket Learning for Causal Feature Selection

Usage
==========
"EAMB.m" is main function.

-------------------------------------------------------------------------------------------------------------------

function [MB,time] = EAMB(Data,data_type,target,alpha,k_or)

INPUT:

    Data is the data matrix, and rows represent the number of samples and columns represent the number of nodes. If Data is a discrete dataset, the value in Data should start from 1.

    data_type='dis' represents discrete data, and data_type='con' denotes continues data.

    target is the index of target node.

    alpha is the significance level, e.g., 0.01 or 0.05.

    k_or is recall coefficient, and k_or is greater than or equal to 0 and less than or equal to 1. Generally, k_or is taken as [0.05, 0.25]. The higher the dimension of the dataset, the smaller the value of k_or.


OUTPUT:

    MB is the Markov blanket of the target.

    time is the runtime of the algorithm.

Example
========
    clear;
    clc;
    load('./data/leukemia/data_labels.mat');
    load('./data/leukemia/cv10_indices.mat');

    % Cross-validation
    for i = 1:10
        test_indices = (indices == i); train_indices = ~test_indices;

        Data = horzcat(data(train_indices,:),labels(train_indices));
        Data = Data+1;
        [~,p] = size(Data);

        [features,~] = EAMB(Data, 'dis', p, 0.01, 0.05); % The p-th variable is the label variable.
    end

References
==========
[1] Guo X, Yu K, Cao F, et al. Error-aware Markov blanket learning for causal feature selection[J]. Information Sciences, 2022, 589: 849-877.
