function [subdelta]=subBypass_ratio(a,x,n,distanceP2P)
%%subBypass_ratio 计算单个订单的绕道率
%   输入:n为订单数量
% [NIND,m] = size(Chrom);
% mind=zeros(n,1);% 最小距离
% d=zeros(NIND,n); % 计算两地实际路径长度
% delta=zeros(NIND,n); % 绕道率
subdelta=0;
mind=0;
d=0;
if size(a,2)>=3 % 车被分配了订单
    for k=2:size(a,2)
        if a(k)==x
            for ii=k+1:size(a,2)
                d=d+distanceP2P(a(ii-1),a(ii));
                if a(ii)==a(k)+n
                    mind=distanceP2P(a(k),a(ii));
                    subdelta = (d-mind)/mind;
                    break;
                end
            end
        end
    end
end
end