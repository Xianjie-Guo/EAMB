
function [mb,ps,cs,pc,sps,p,SP_ling] = STA(dag)

[n,p]=size(dag);
mb = cell(1,p);
ps = cell(1,p);
cs = cell(1,p);
pc = cell(1,p);
sps = cell(1,p);

SP_ling=cell(p,p);

for i=1:p
    
    sps_tmp=[];
    ps_tmp = parents(dag, i);
    cs_tmp = children(dag, i, 1);
    pc_tmp = myunion(ps_tmp,cs_tmp);
    
    ps{i}=ps_tmp;
    cs{i}=cs_tmp;
    pc{i}=pc_tmp;
    
    for j=1:length(cs_tmp)
        X = cs_tmp(j);
        sps_tmp = myunion(sps_tmp,parents(dag, X));
        
        SP_ling{i,X}=mysetdiff(parents(dag, X),i);
    end
    sps_tmp = mysetdiff(sps_tmp,i);
    sps{i}=sps_tmp;
    
     mb_tmp= myunion(pc_tmp,sps_tmp);
     mb{i}=mb_tmp;
     
%      i
%      ps_tmp
%      cs_tmp
%      pc_tmp
%      sps_tmp
%      mb_tmp
    
end


