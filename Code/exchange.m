function [ newChrom ] = exchange( Chrom,Pe,n,m)
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
           o2index=find(Chrom(i,:)==o+n);
           r=randi([n*2+1 n*2+m-1]);
           rindex=find(Chrom(i,:)==r);
           if o1index<rindex && o1index>1
               if rand()<0.5
                   newChrom(i,:)=[Chrom(i,1:o1index-1),Chrom(i,o1index+1:o2index-1),Chrom(i,o2index+1:rindex-1),o,o+n,Chrom(i,rindex:end)];
               else
                   newChrom(i,:)=[Chrom(i,1:o1index-1),Chrom(i,o1index+1:o2index-1),Chrom(i,o2index+1:rindex),o,o+n,Chrom(i,rindex+1:end)];
               end
           elseif o1index>rindex
               if rand()<0.5
                   newChrom(i,:)=[Chrom(i,1:rindex-1),o,o+n,Chrom(i,rindex:o1index-1),Chrom(i,o1index+1:o2index-1),Chrom(i,o2index+1:end)];
               else
                   newChrom(i,:)=[Chrom(i,1:rindex),o,o+n,Chrom(i,rindex+1:o1index-1),Chrom(i,o1index+1:o2index-1),Chrom(i,o2index+1:end)];
               end
           else
               if rand()<0.5
                   newChrom(i,:)=[Chrom(i,2:o2index-1),Chrom(i,o2index+1:rindex-1),o,o+n,Chrom(i,rindex:end)];
               else
                   newChrom(i,:)=[Chrom(i,2:o2index-1),Chrom(i,o2index+1:rindex),o,o+n,Chrom(i,rindex+1:end)];
               end
           end
       end
       i=i+1;
    end
    
end

