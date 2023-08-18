clc
close all
clear all
%% 出租车位置
D_position=[1 1;3 2;5 4];
%% 乘客出发地及目的地
P_position=[1 2;2 2;2 1;3 4;4 3;5 2;
            1 3;2 4;3 3;3 1;4 1;4 0];
%% 出租车可用座位数量
D_seat_number=ones(1,3)*4;
P_seat_number=ones(1,6)*1;
%% 乘客期望上车时间
P_WT=[0 0 1 1 2 2];

v=0.5; % 假设速度为30km/h
n=size(P_position,1) % 订单数量n/2
m=size(D_position,1) % 出租车数量
distanceD2P = zeros(m,n)
%% 曼哈顿距离
for i=1:m % 车与乘客的距离
   for j=1:n
       distanceD2P(i,j)=abs(P_position(j,1)-D_position(i,1))+abs(P_position(j,2)-D_position(i,2));
   end
end
% 乘客之间的距离
DP=pdist(P_position,'cityblock');
distanceP2P=squareform(DP);


gen=0;
codelength=n+m-1;
NIND=3;                        %种群大小
MAXGEN=1000;                    %迭代次数
Pc=0.2;                         %交叉概率
Pm=0.8;                         %变异概率
Pe=0.8;                         %交换概率
Delta=3;                        %最大绕道率
w1=0.5;                         %等待时间权重
w2=1;                           %延迟时间权重

Chrom=init_pop(NIND,codelength,n/2,P_WT,P_seat_number,D_seat_number);
% 调整不符合绕道率约束的个体
for i=1:NIND
    for j=1:codelength
        if Chrom(i,j)<=n/2 %订单起点
            k=j+1;
            DD=0;
            while Chrom(i,k)~=Chrom(i,j)+n/2 && Chrom(i,k)<=n
                DD=DD+distanceP2P(Chrom(i,k-1),Chrom(i,k));
                k=k+1;
            end
            % 若不符合绕道率约束，将起点重置于终点前一个位置
            if (DD-distanceP2P(Chrom(i,j),Chrom(i,j)+n/2))/distanceP2P(Chrom(i,j),Chrom(i,j)+n/2)>Delta
                Chrom(i,:)=[Chrom(i,1:j-1),Chrom(i,j+1:k-1),Chrom(i,j),Chrom(i,k:end)];
            end
        end
    end
end
%% 计算初始种群的目标函数值
[routelength,contactnum,wt] = FounctionValue1(Chrom,n/2,m,P_WT,distanceD2P,distanceP2P,P_seat_number,w1,w2,v);