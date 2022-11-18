% Author: Xianjie Guo.
% Time: 2022.11.18

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% START %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ns=max(Data);
[samples,n_vars]=size(Data);

start=tic;

if strcmp(data_type,'dis')
    [MB,~,~,index] = SRFS_main_G2(Data,target,alpha, ns, n_vars);
    or_len=round(length(index)*k_or);
    for i=1:or_len
        [mb] = SRFS_minor_G2(Data,index(i),alpha, ns, n_vars);
        
        if ismember(target,mb)
            MB=[MB index(i)];
        end
    end
elseif strcmp(data_type,'con')
    [MB,~,~,index] = SRFS_main_Z(Data,target,alpha, samples, n_vars);
    or_len=round(length(index)*k_or);
    for i=1:or_len
        [mb] = SRFS_minor_Z(Data,index(i),alpha, samples, n_vars);
        
        if ismember(target,mb)
            MB=[MB index(i)];
        end
    end
else
    disp('Please enter the correct data type!');
    disp("'dis' or 'con'");
end

time=toc(start);

end

