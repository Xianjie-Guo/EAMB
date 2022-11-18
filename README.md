# EAMB
Error-Aware Markov Blanket Learning for Causal Feature Selection

Reference: Guo X, Yu K, Cao F, et al. Error-aware Markov blanket learning for causal feature selection[J]. Information Sciences, 2022, 589: 849-877.

"EAMB.m" is main function.

function [MB,time] = EAMB(Data,data_type,target,alpha,k_or)
% Input :
% Data is the data matrix, and rows represent the number of samples and columns represent the number of nodes.
% If Data is a discrete dataset, the value in Data should start from 1.

% data_type='dis' represents discrete data, and data_type='con' denotes continues data.

% target is the index of target node.

% alpha is the significance level, e.g., 0.01 or 0.05.

% k_or is recall coefficient, and k_or is greater than or equal to 0 and less than or equal to 1.
% Generally, k_or is taken as [0.05, 0.25]. The higher the dimension of the dataset, the smaller the value of k_or.


% Output:
% MB is the Markov blanket of the target.
% time is the runtime of the algorithm.
