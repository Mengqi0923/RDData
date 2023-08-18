function [ newChrom ] = Cross1( Chrom,Pc,n,m )
%   交叉
%   个体内部交叉，任意两个出租车路径交换,n订单总数，P_TW时间窗，v速度，distanceD2P,distanceP2P
    newChrom=Chrom;
    NIND = size(newChrom,1);
    for i=1:NIND
        if rand()<Pc
            r1=randi([n*2+1 n*2+m-1]);
            r2=randi([n*2+1 n*2+m-1]);
            while r1==r2
                r1=randi([n*2+1 n*2+m-1]);
                r2=randi([n*2+1 n*2+m-1]);
            end
            a=min([r1,r2]);
            b=max([r1,r2]);
            aindex=find(Chrom(i,:)==a);
            bindex=find(Chrom(i,:)==b);
            bindex0=find(Chrom(i,:)==b-1);
            if a==n*2+1
                newChrom(i,:)=[Chrom(i,bindex0+1:bindex-1),Chrom(i,aindex:bindex0),Chrom(i,1:aindex-1),Chrom(i,bindex:end)];
            else
                aindex0=find(Chrom(i,:)==a-1);
                newChrom(i,:)=[Chrom(i,1:aindex0),Chrom(i,bindex0+1:bindex-1),Chrom(i,aindex:bindex0),Chrom(i,aindex0+1:aindex-1),Chrom(i,bindex:end)];
            end
        end
    end
end

