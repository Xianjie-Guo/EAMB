function [MB,ntest,time,index] = SRFS_main_G2(Data,target,alpha, ns, p)
%���㷨��һ��������ֻ��PC
%����֮������һ�βü����ü�ʱ���һ���ڵ㲻�ò�
%�ڿռ���������T�����Ľڵ㲻�ٿ��Ǽ���or_rank��ȥ
start=tic;

p_rank=zeros(1,p);%��¼ÿ���ڵ���T֮���������
dele_MB=[];%��¼�ü��׶α�ɾ���Ľڵ�

MB=[];
ntest=0;
CanMB = mysetdiff([1:p],target);

%��һ��pc����
CanSP=[];
tag=0;
while(~isempty(CanMB))
    tmp_dep = -10000;
    tmp_pval = 10000;
    tmp_length=length(CanMB);
    
    CanMB_remove=[];
    for i=1:tmp_length
        X = CanMB(i);
        ntest=ntest+1;
        [pval,dep]=g2test(X,target,MB,Data,ns,alpha);
        
        if ~isnan(pval)
            if (dep > tmp_dep)
                tmp_dep = dep;
                tmp_pval = pval;
                Y = X;
            end
            if pval>alpha
                CanMB_remove=[CanMB_remove X];
                if isempty(MB)
                    CanSP=[CanSP X];
                end
            end
            p_rank(X)=pval;
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
    [pval]=g2test(MB(i),target,condset,Data,ns,alpha);
    ntest=ntest+1;
    if pval>alpha
        tmp_MB=mysetdiff(tmp_MB,MB(i));
        dele_MB=[dele_MB MB(i)];
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
            ntest=ntest+1;
            [pval,dep]=g2test(X,target,MB,Data,ns,alpha);
            
            if ~isnan(pval)
                if (dep > tmp_dep)
                    tmp_dep = dep;
                    tmp_pval = pval;
                    Y = X;
                end
                if pval>alpha
                    CanMB_remove=[CanMB_remove X];
                end
                p_rank(X)=pval;
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
    [pval]=g2test(MB(i),target,condset,Data,ns,alpha);
    ntest=ntest+1;
    if pval>alpha
        tmp_MB=mysetdiff(tmp_MB,MB(i));
        dele_MB=[dele_MB MB(i)];
    end
end

% MB = sort(tmp_MB);
MB = tmp_MB;

[p_value,index]=sort(p_rank,'ascend');

index=mysetdiff(index,target);
index=mysetdiff(index,MB);
index=mysetdiff(index,dele_MB);
index=mysetdiff(index,CanSP);

time=toc(start);

end

