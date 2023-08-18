function [ num ] = NoP( a,n,nn,P_seat_number ) 
%   输入：a为一条路径序列，n为路径中的第n个位置,nn为订单总数，P_seat_number为每个订单请求的座位数量
%   输出：num为出租车上当前的人数
%   number of people 乘客人数
%   出租车上的实时人数
%     n=size(a,1);
    num=0;
    for i=2:n
        if a(i)<=nn
            num=num+P_seat_number(a(i));
        else
            num=num-P_seat_number(a(i)-nn);
        end
    end
end

