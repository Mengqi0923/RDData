function [t] = isTW(a,n,P_TW,v,distanceD2P,distanceP2P)
%isTW 判断是否符合时间窗，符合为1，不符合为0
%   输入：a序列，P_TW时间窗,n总订单数
n1=size(a,2);
t=1;
for i=2:n1
    if a(i)<=n
        % 不满足时间窗
        if Time(a,i,n,P_TW,v,distanceD2P,distanceP2P)>P_TW(a(i)) % 车延误
            t=0;
            break;
        end
    end
end
end