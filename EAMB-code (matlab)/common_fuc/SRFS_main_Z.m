function [MB,ntest,time,index] = SRFS_main_Z(Data,target,alpha, samples, p)
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
    tmp_CI = 10000;
    tmp_length=length(CanMB);
    
    CanMB_remove=[];
    for i=1:tmp_length
        X = CanMB(i);
        ntest=ntest+1;
        [CI,dep]=fisherz_test(X,target,MB,Data,samples,alpha);
        
        if ~isnan(CI)
            if (dep > tmp_dep)
                tmp_dep = dep;
                tmp_CI = CI;
                Y = X;
            end
            if CI==1
                CanMB_remove=[CanMB_remove X];
                if isempty(MB)
                    CanSP=[CanSP X];
                end
            end
            p_rank(X)=dep;
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

%mb�Ĳü�����
tmp_MB = MB;
for i=1:length(MB)-1 %���һ������Ľڵ㲻�ò�
    condset=mysetdiff(MB,MB(i));
    [CI]=fisherz_test(MB(i),target,condset,Data,samples,alpha);
    ntest=ntest+1;
    if CI==1
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
        tmp_CI = 10000;
        tmp_length=length(CanMB);
        
        CanMB_remove=[];
        for i=1:tmp_length
            X = CanMB(i);
            ntest=ntest+1;
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
                p_rank(X)=dep;
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

%mb�Ĳü�����
tmp_MB = MB;
for i=1:length(MB)-1 %���һ������Ľڵ㲻�ò�
    condset=mysetdiff(MB,MB(i));
    [CI]=fisherz_test(MB(i),target,condset,Data,samples,alpha);
    ntest=ntest+1;
    if CI==1
        tmp_MB=mysetdiff(tmp_MB,MB(i));
        dele_MB=[dele_MB MB(i)];
    end
end

% MB = sort(tmp_MB);
MB = tmp_MB;

[p_value,index]=sort(p_rank,'descend');

index=mysetdiff(index,target);
index=mysetdiff(index,MB);
index=mysetdiff(index,dele_MB);
index=mysetdiff(index,CanSP);

time=toc(start);

end

