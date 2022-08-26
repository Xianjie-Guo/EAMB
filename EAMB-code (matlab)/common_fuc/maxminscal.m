function [Xnew] = maxminscal(X)
% Scaling the data of X into the unit interval [0,1] (each column) 
% via max-min scaling. Rows are assumed to be observations and clumns are 
% the features (=variables)

for i=1:size(X,2)
    Xnew(:,i)=gsubtract(X(:,i),repmat(min(X(:,i)),size(X,1),1))./(max(X(:,i))-min(X(:,i)));
end
end

