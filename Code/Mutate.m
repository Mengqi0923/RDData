function [ newChrom ] = Mutate( Chrom,n,m,Pm,P_seat_number,D_seat_number)
%   变异操作
%   每条车辆路径内部路径序列的变化,n为订单数量
NIND = size(Chrom,1);
newChrom=Chrom;
i=1;
while i<=NIND
    if rand()<=Pm
        a=randi([1,n]);
        a1index=find(newChrom(i,:)==a);
        a2index=find(newChrom(i,:)==a+n);
        k=a1index;
        while k>=1 && newChrom(i,k)<=n*2
            k=k-1;
        end
        r1index=k;
        if r1index==0
            j=a2index;
            while newChrom(i,j)<=n*2
                j=j+1;
            end
            r2index=j;
        end
        newa1index=randi([r1index+1,a2index-1]);
        temp=newChrom(i,a1index);
        newChrom(i,a1index)=newChrom(i,newa1index);
        newChrom(i,newa1index)=temp;
        for k=(r1index+1):(a2index-1)
            for kk=(k+1):(a2index-1)
                if newChrom(i,k)==newChrom(i,kk)+n && newChrom(i,kk)<=n
                    p=newChrom(i,k);
                    newChrom(i,k)=newChrom(i,kk);
                    newChrom(i,kk)=p;
                end
            end
        end
        % 判断是否该车是否超载
        count=0;
        for j=(r1index+1):(a2index-1)
            if Chrom(i,j)<=n
                count=count+P_seat_number(Chrom(i,j));
                if r1index==0
                    if count>D_seat_number(Chrom(i,r2index)-n*2)
                        newChrom(i,:)=Chrom(i,:);
                        break;
                    end
                else
                    if count>D_seat_number(Chrom(i,r1index)+1-n*2)
                        newChrom(i,:)=Chrom(i,:);
                        break;
                    end
                end
            else
                count=count-P_seat_number(Chrom(i,j)-n);
            end
        end
    end
    i=i+1;
end
end