function [delta] = Bypass_ratio(Chrom,n,distanceP2P)
%%Bypass_ratio 计算绕道率
%   输入:n为订单数量
[NIND,m] = size(Chrom);
mind=zeros(n,1);% 最小距离
d=zeros(NIND,n); % 计算两地实际路径长度
delta=zeros(NIND,n); % 绕道率
for i=1:NIND
    for j=1:m
        if size(Chrom{i,j},2)>=3 % 车被分配了订单
            for k=2:size(Chrom{i,j},2)
                if Chrom{i,j}(k)<=n
                    for ii=k+1:size(Chrom{i,j},2)
                        d(i,Chrom{i,j}(k))=d(i,Chrom{i,j}(k))+distanceP2P(Chrom{i,j}(ii-1),Chrom{i,j}(ii));
                        if Chrom{i,j}(ii)==Chrom{i,j}(k)+n
                            mind(Chrom{i,j}(k))=distanceP2P(Chrom{i,j}(k),Chrom{i,j}(ii));
                            delta(i,Chrom{i,j}(k)) = (d(i,Chrom{i,j}(k))-mind(Chrom{i,j}(k)))/mind(Chrom{i,j}(k));
                            break;
                        end
                    end
                end
            end
        end
    end
end
end