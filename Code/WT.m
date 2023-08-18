function [wt] = WT(Chrom,n,P_TW,actual_st)
%WT 时间惩罚函数
%   计算车等人时间之和,n为订单数量
[NIND,m] = size(Chrom);
wt=zeros(NIND,1);
for i=1:NIND
    dif1=0;
    for j=1:m
        dif1=0;
        if size(Chrom{i,j},2)>=3
            for k=2:size(Chrom{i,j},2)
                if Chrom{i,j}(k)<=n % 乘客出发位置
                    dif1=dif1+(P_TW(Chrom{i,j}(k))-actual_st(i,Chrom{i,j}(k)));
                    
                end
            end
        end
        wt(i)=wt(i)+dif1;
    end
    wt(i)=wt(i)/n;
end
end