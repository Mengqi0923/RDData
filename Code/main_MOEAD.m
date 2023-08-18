clc
close all
clear all

D_position=importdata('D_position.txt');
%% 乘客出发地及目的地
P_position=importdata('P_position.txt');
%% 出租车可用座位数量
D_seat_number=importdata('D_seat_number.txt');
%% 乘客预定座位数量
P_seat_number=importdata('P_seat_number.txt');
%% 乘客期望上车时间
P_WT=importdata('P_TW.txt');
% 经纬度转换为坐标
D_position = lltoxy(D_position);
P_position = lltoxy(P_position);
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

%% 初始化参数
%% 参数设置
gen=0;
codelength=n+m-1;
NIND=50;                        %种群大小
MAXGEN=1000;                    %迭代次数
Pc=0.5;                         %交叉概率
Pm=0.8;                         %变异概率
Pe=0.8;                         %交换概率
Delta=2;                        %最大绕道率
w1=0.5;                         %等待时间权重
w2=1;                           %延迟时间权重
probability=[0.94,0.01,0.05
    0.85,0.1,0.05
    0.80,0.15,0.05
    0.7,0.25,0.05
    0.68,0.27,0.05
    0.60,0.35,0.05
    0.55,0.4,0.05
    0.5,0.45,0.05
    0.1,0.85,0.05];
px=probability(6,:);
p1=px(1);
p2=px(2);
p3=px(3);
%% 初始化种群
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
[cost,contactnum,wt] = FounctionValue2(Chrom,n/2,m,P_WT,distanceD2P,distanceP2P,P_seat_number,w1,w2,v);


minr=zeros(MAXGEN,1)
minc=zeros(MAXGEN,1)
minu=zeros(MAXGEN,1)
minw=zeros(MAXGEN,1)


functionvalue=zeros(size(Chrom,1),3);           %合并后种群的各目标函数值

%% 初始种群分布
functionvalue(:,1)=cost
functionvalue(:,2)=contactnum
% functionvalue(:,3)=usedtaxi
functionvalue(:,3)=wt
functionvalue1=functionvalue
functionvalue0=functionvalue
fitness=p1.*(functionvalue(:,1))+p2.*(functionvalue(:,2))+p3.*(functionvalue(:,3));

%% 迭代
while gen<MAXGEN
    
    %% 交叉
    newChrom = Cross( Chrom,Pc,n/2,m,P_seat_number,D_seat_number );
    %% 交换
    newChrom = exchange( newChrom,Pe,n/2,m);
    %% 变异
    newChrom = Mutate( newChrom,n/2,m,Pm,P_seat_number,D_seat_number);
    % 调整不符合绕道率约束的个体
    for i=1:NIND
        for j=1:codelength
            if newChrom(i,j)<=n/2 %订单起点
                k=j+1;
                DD=0;
                while newChrom(i,k)~=newChrom(i,j)+n/2 && newChrom(i,k)<=n
                    DD=DD+distanceP2P(newChrom(i,k-1),newChrom(i,k));
                    k=k+1;
                end
                % 若不符合绕道率约束，将起点重置于终点前一个位置
                if (DD-distanceP2P(newChrom(i,j),newChrom(i,j)+n/2))/distanceP2P(newChrom(i,j),newChrom(i,j)+n/2)>Delta
                    newChrom(i,:)=[newChrom(i,1:j-1),newChrom(i,j+1:k-1),newChrom(i,j),newChrom(i,k:end)];
                end
            end
        end
    end
        
    [newcost,newcontactnum,newwt] = FounctionValue2(newChrom,n/2,m,P_WT,distanceD2P,distanceP2P,P_seat_number,w1,w2,v);

    functionvalue=zeros(size(newChrom,1),3)
    functionvalue(:,1)=cost
    functionvalue(:,2)=contactnum
    functionvalue(:,3)=wt;

    fitness=p1.*(functionvalue(:,1))+p2.*(functionvalue(:,2))+p3.*(functionvalue(:,3));
    
    % 选择
    Chrom=BinaryTourment_Select(newChrom,fitness);
    [cost,contactnum,wt] = FounctionValue2(Chrom,n/2,m,P_WT,distanceD2P,distanceP2P,P_seat_number,w1,w2,v);
    functionvalue(:,1)=cost
    functionvalue(:,2)=contactnum
    functionvalue(:,3)=wt;

    fitness=p1.*(functionvalue(:,1))+p2.*(functionvalue(:,2))+p3.*(functionvalue(:,3));
    gen=gen+1;
    disp(gen)
    %% 每次迭代种群的最小值
    minr(gen)=min(cost)
    minc(gen)=min(contactnum)
    minw(gen)=min(wt)
end
[val,Ind]=min(fitness);
fun_v=functionvalue(Ind,:);
fun_v0=mean(functionvalue0);