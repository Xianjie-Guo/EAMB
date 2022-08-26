function [MB] = SRFS_minor(Data,target,alpha, ns, p)
%���㷨��һ��������ֻ��PC
%����֮������һ�βü����ü�ʱ���һ���ڵ㲻�ò�
%�ڿռ���������T�����Ľڵ㲻�ٿ��Ǽ���or_rank��ȥ

MB=[];
CanMB = mysetdiff([1:p],target);

%��һ��pc����
tag=0;
while(~isempty(CanMB))
    tmp_dep = -10000;
    tmp_pval = 10000;
    tmp_length=length(CanMB);
    
    CanMB_remove=[];
    for i=1:tmp_length
        X = CanMB(i);
        [pval,dep]=g2test_2(X,target,MB,Data,ns);
        
        if ~isnan(pval)
            if (dep > tmp_dep)
                tmp_dep = dep;
                tmp_pval = pval;
                Y = X;
            end
            if pval>alpha
                CanMB_remove=[CanMB_remove X];
            end
        else
            CanMB_remove=[CanMB_remove X];
        end
    end
    CanMB=mysetdiff(CanMB,CanMB_remove);
    
    if tmp_pval<=alpha
        MB=[MB Y];
        tag=1;
        CanMB=mysetdiff(CanMB,Y);
    end
end

%mb�Ĳü�����
tmp_MB = MB;
for i=1:length(MB)-1 %���һ������Ľڵ㲻�ò�
    condset=mysetdiff(MB,MB(i));
    [pval]=g2test_2(MB(i),target,condset,Data,ns);
    if pval>alpha
        tmp_MB=mysetdiff(tmp_MB,MB(i));
    end
end
MB = tmp_MB;

%�ڶ���Ѱ��T������mb
if tag==1
    CanMB = mysetdiff([1:p],target);
    CanMB = mysetdiff(CanMB,MB);
    while(~isempty(CanMB))
        tmp_dep = -10000;
        tmp_pval = 10000;
        tmp_length=length(CanMB);
        
        CanMB_remove=[];
        for i=1:tmp_length
            X = CanMB(i);
            [pval,dep]=g2test_2(X,target,MB,Data,ns);
            
            if ~isnan(pval)
                if (dep > tmp_dep)
                    tmp_dep = dep;
                    tmp_pval = pval;
                    Y = X;
                end
                if pval>alpha
                    CanMB_remove=[CanMB_remove X];
                end
            else
                CanMB_remove=[CanMB_remove X];
            end
        end
        CanMB=mysetdiff(CanMB,CanMB_remove);
        
        if tmp_pval<=alpha
            MB=[MB Y];
            CanMB=mysetdiff(CanMB,Y);
        end
    end
end

%mb�Ĳü�����
tmp_MB = MB;
for i=1:length(MB)-1 %���һ������Ľڵ㲻�ò�
    condset=mysetdiff(MB,MB(i));
    [pval]=g2test_2(MB(i),target,condset,Data,ns);
    if pval>alpha
        tmp_MB=mysetdiff(tmp_MB,MB(i));
    end
end

% MB = sort(tmp_MB);
MB = tmp_MB;

end

