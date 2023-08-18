function [ usedtaxi ] = UsedTaxi( Chrom )
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
    [NIND,m] = size(Chrom);
    usedtaxi=zeros(NIND,1);
    for i=1:NIND
        for j=1:m
            if size(Chrom{i,j},2)>1
                usedtaxi(i)=usedtaxi(i)+1;
            end
        end
    end
end

