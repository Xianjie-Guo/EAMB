% Author: XianjieGuo. 
% Time: 2022.8.26

function [MB,time] = EAMB(Data,target,alpha,k_or)
% Input :
% Data is the data matrix, and rows represent the number of samples and columns represent the number of nodes.
% target is the index of target node.
% alpha is the significance level, e.g., 0.01 or 0.05.
%  k_or is recall coefficientm, and k_or∈[0, 1]. Generally, k_or is taken as [0.05, 0.25]. The higher the dimension of the dataset, the smaller the value of k_or.

% Output:
% MB is the Markov blanket of the target.
% time is the runtime of the algorithm.

ns=max(Data);
[~,n_vars]=size(Data);

start=tic;

[MB,~,~,index] = SRFS_main(Data,target,alpha, ns, n_vars);

or_len=round(length(index)*k_or);

for i=1:or_len
    [mb] = SRFS_minor(Data,index(i),alpha, ns, n_vars);
    
    if ismember(target,mb)
        MB=[MB index(i)];
    end
end

time=toc(start);

end

