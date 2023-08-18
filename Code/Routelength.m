function [ routelength ] = Routelength( Chrom,distanceD2P,distanceP2P )
%Routelength 路径距离函数
%   计算所有出租车的总路径距离
    [NIND,m] = size(Chrom);
    routelength=zeros(NIND,1);
%     n=size(P_position,1);
    for i=1:NIND
        for j=1:m
            if size(Chrom{i,j},2)>1
                for k=1:size(Chrom{i,j},2)-1
                    if k==1
                        routelength(i)=routelength(i)+distanceD2P(j,Chrom{i,j}(k+1))
                    else
                        routelength(i)=routelength(i)+distanceP2P(Chrom{i,j}(k),Chrom{i,j}(k+1))
                    end
                end
            end
        end
    end
end

