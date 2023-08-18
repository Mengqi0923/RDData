function [time] = Time(a,x,n,P_TW,v,distanceP2P)
%Time 计时函数
%   输入：a路径序列；x当前位置,n订单总数，P_TW时间窗，v速度，distanceD2P,distanceP2P
%   输出：time时间
time=0;
for i=2:x
    if i==2
%         time=distanceD2P(a(1),a(i))*v;
        time=0;
    elseif a(i)<=n && i>2
        time=max(time+distanceP2P(a(i-1),a(i))/v,P_TW(a(i)));
    else
        time=time+distanceP2P(a(i-1),a(i))/v;
    end
end
end