function [ newChrom ] = exchange1( Chrom,Pe,n,m)
%   Exchange() 交换函数
%   将某个订单分配给其他出租车
%   n为订单数量
    newChrom=Chrom;
    NIND = size(newChrom,1);
    i=1;
    while i<=NIND
       if rand()<Pe
           o=randi([1 n]);
           o1index=find(Chrom(i,:)==o);
%            o2index=find(Chrom(i,:)==o+n);
           r=randi([n*2+1 n*2+m-1]);
%            rindex=find(Chrom(i,:)==r);
           a=Chrom(i,:);
           a([o1index,o1index+1])=[];
           rindex=find(a==r);
           a=[a(1:rindex-1),o,o+n,a(rindex:end)];
           newChrom(i,:)=a;
       end
       i=i+1;
    end
    
end

