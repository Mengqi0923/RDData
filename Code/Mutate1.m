function [ newChrom ] = Mutate1( Chrom,n,Pm)
%   变异操作
%   每条车辆路径内部路径序列的变化,n为订单数量
NIND = size(Chrom,1);
newChrom=Chrom;
i=1;
while i<=NIND
    if rand()<=Pm
        a=randi([1,n]);
        a1index=find(newChrom(i,:)==a);

        k=find(newChrom(i,1:a1index)>n*2);
        
        
        if isempty(k)
            r2index=n*2+1;
            newa1index=randi([1,r2index-2]);
           
        else
            r1index=k(length(k));
            if newChrom(i,r1index)==size(Chrom,2)
                newa1index=randi([r1index+1,size(Chrom,2)-1]);     
            else
                r2index=find(Chrom(i,:)==Chrom(i,r1index)+1);
                newa1index=randi([r1index+1,r2index-2]);
            end
        end
        if mod(newa1index,2)==0
            newa1index=newa1index-1;
        end
        temp=newChrom(i,a1index:(a1index+1));
        newChrom(i,a1index:(a1index+1))=newChrom(i,newa1index:(newa1index+1));
        newChrom(i,newa1index:(newa1index+1))=temp;
  
    end
    i=i+1;
end
end