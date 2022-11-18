function [MB] = SRFS_minor_Z(Data,target,alpha, samples, p)
%该算法第一轮理论上只找PC
%两轮之间多添加一次裁剪，裁剪时最后一个节点不用测
%在空集条件下与T独立的节点不再考虑加入or_rank中去

MB=[];
CanMB = mysetdiff([1:p],target);

%第一轮pc发现
tag=0;
while(~isempty(CanMB))
    tmp_dep = -10000;
    tmp_CI = 10000;
    tmp_length=length(CanMB);
    
    CanMB_remove=[];
    for i=1:tmp_length
        X = CanMB(i);
        [CI,dep]=fisherz_test(X,target,MB,Data,samples,alpha);
        
        if ~isnan(CI)
            if (dep > tmp_dep)
                tmp_dep = dep;
                tmp_CI = CI;
                Y = X;
            end
            if CI==1
                CanMB_remove=[CanMB_remove X];
            end
        else
            CanMB_remove=[CanMB_remove X];
        end
    end
    CanMB=mysetdiff(CanMB,CanMB_remove);
    
    if tmp_CI==0
        MB=[MB Y];
        tag=1;
        CanMB=mysetdiff(CanMB,Y);
    end
end

%mb的裁剪操作
tmp_MB = MB;
for i=1:length(MB)-1 %最后一个加入的节点不用测
    condset=mysetdiff(MB,MB(i));
    [CI]=fisherz_test(MB(i),target,condset,Data,samples,alpha);
    if CI==1
        tmp_MB=mysetdiff(tmp_MB,MB(i));
    end
end
MB = tmp_MB;

%第二轮寻找T的所有mb
if tag==1
    CanMB = mysetdiff([1:p],target);
    CanMB = mysetdiff(CanMB,MB);
    while(~isempty(CanMB))
        tmp_dep = -10000;
        tmp_CI = 10000;
        tmp_length=length(CanMB);
        
        CanMB_remove=[];
        for i=1:tmp_length
            X = CanMB(i);
            [CI,dep]=fisherz_test(X,target,MB,Data,samples,alpha);
            
            if ~isnan(CI)
                if (dep > tmp_dep)
                    tmp_dep = dep;
                    tmp_CI = CI;
                    Y = X;
                end
                if CI==1
                    CanMB_remove=[CanMB_remove X];
                end
            else
                CanMB_remove=[CanMB_remove X];
            end
        end
        CanMB=mysetdiff(CanMB,CanMB_remove);
        
        if tmp_CI==0
            MB=[MB Y];
            CanMB=mysetdiff(CanMB,Y);
        end
    end
end

%mb的裁剪操作
tmp_MB = MB;
for i=1:length(MB)-1 %最后一个加入的节点不用测
    condset=mysetdiff(MB,MB(i));
    [CI]=fisherz_test(MB(i),target,condset,Data,samples,alpha);
    if CI==1
        tmp_MB=mysetdiff(tmp_MB,MB(i));
    end
end

% MB = sort(tmp_MB);
MB = tmp_MB;

end

