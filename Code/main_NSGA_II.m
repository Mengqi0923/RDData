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
Pm=0.8;                         %变异概率
Pe=0.8;                         %交换概率
Delta=2;                        %最大绕道率
w1=0.5;                         %等待时间权重
w2=1;                           %延迟时间权重
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


%% 迭代
while gen<MAXGEN    
    %% 交换
    newChrom = exchange( Chrom,Pe,n/2,m);
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
    %% 计算新种群目标函数值
    newChrom=[Chrom;newChrom];
    % 总路径长度
    cost = [cost;newcost];
    % 接触人数
    contactnum = [contactnum;newcontactnum];
    % 已用出租车数量
%     usedtaxi = [usedtaxi;newusedtaxi];
    %% 时间惩罚
    wt = [wt;newwt];

    functionvalue=zeros(size(newChrom,1),3)
    functionvalue(:,1)=cost
    functionvalue(:,2)=contactnum
%     functionvalue(:,3)=usedtaxi
    functionvalue(:,3)=wt;


    %% 非支配排序
    fnum=0;                                             %当前分配的前沿面编号
    cz=false(1,size(functionvalue,1));                  %记录个体是否已被分配编号
    frontvalue=zeros(size(cz));                         %每个个体的前沿面编号
    [functionvalue_sorted,newsite]=sortrows(functionvalue);    %对种群按第一维目标值大小进行排序
    while ~all(cz)                                      %开始迭代判断每个个体的前沿面,采用改进的deductive sort
        fnum=fnum+1;
        d=cz;
        for i=1:size(functionvalue,1)
            if ~d(i)
                for j=i+1:size(functionvalue,1)
                    if ~d(j)
                        k=1;
                        for m1=1:size(functionvalue,2)
                            if functionvalue_sorted(i,m1)>functionvalue_sorted(j,m1)
                                k=0;
                                break
                            end
                        end
                        if k
                            d(j)=true;
                        end
                    end
                end
                frontvalue(newsite(i))=fnum;
                cz(i)=true;
            end
        end
    end
    %% 计算拥挤距离
    fnum=0;                                                                 %当前前沿面
    while numel(frontvalue,frontvalue<=fnum+1)<=NIND                      %判断前多少个面的个体能完全放入下一代种群
        fnum=fnum+1;
    end
    newnum=numel(frontvalue,frontvalue<=fnum);                              %前fnum个面的个体数
    Chrom(1:newnum,:)=newChrom(frontvalue<=fnum,:);                         %将前fnum个面的个体复制入下一代
    popu=find(frontvalue==fnum+1);                                          %popu记录第fnum+1个面上的个体编号
    distancevalue=zeros(size(popu));                                        %popu各个体的拥挤距离
    fmax=max(functionvalue(popu,:),[],1);                                   %popu每维上的最大值
    fmin=min(functionvalue(popu,:),[],1);                                   %popu每维上的最小值
    for i=1:size(functionvalue,2)                                           %分目标计算每个目标上popu各个体的拥挤距离
        [~,newsite]=sortrows(functionvalue(popu,i));
        distancevalue(newsite(1))=inf;
        distancevalue(newsite(end))=inf;
        for j=2:length(popu)-1
            distancevalue(newsite(j))=distancevalue(newsite(j))+(functionvalue(popu(newsite(j+1)),i)-functionvalue(popu(newsite(j-1)),i))/(fmax(i)-fmin(i));
        end
    end
    % 选择（精英保留策略）
    popu=-sortrows(-[distancevalue;popu]')';                                %按拥挤距离降序排序第fnum+1个面上的个体
    Chrom(newnum+1:NIND,:)=newChrom(popu(2,1:NIND-newnum),:);	%将第fnum+1个面上拥挤距离较大的前NIND-newnum个个体复制入下一代
    [cost,contactnum,wt] = FounctionValue2(Chrom,n/2,m,P_WT,distanceD2P,distanceP2P,P_seat_number,w1,w2,v);
    gen=gen+1;
    disp(gen)
    %% 每次迭代种群的最小值
    minr(gen)=min(cost)
    minc(gen)=min(contactnum)
    minw(gen)=min(wt)
end

functionvalue=[cost,contactnum,wt];
frontvalue = nondominated_sort(functionvalue);
output=sortrows(functionvalue(frontvalue==1,:));