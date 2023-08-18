clc
close all
clear all
tic

%% 出租车位置
D_position=importdata('D_position01.txt');
% D_position=[1 1;3 2;5 4];
%% 乘客出发地及目的地
P_position=importdata('P_position01.txt');
%  P_position=[1 2;2 2;2 1;3 4;4 3;5 2;
%             1 3;2 4;3 3;3 1;4 1;4 0];
%% 出租车可用座位数量
D_seat_number=importdata('D_seat_number01.txt');
% D_seat_number=ones(1,3)*4;
P_seat_number=importdata('P_seat_number01.txt');
% P_seat_number=ones(1,6)*1;
%% 乘客期望上车时间
P_WT=importdata('P_TW01.txt');
% P_WT=[0 0 1 1 2 2];
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
Pc=0.2;                         %交叉概率
Pm=0.8;                         %变异概率
Pe=0.8;                         %交换概率
Delta=3;                        %最大绕道率
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
[routelength,contactnum,wt] = FounctionValue1(Chrom,n/2,m,P_WT,distanceD2P,distanceP2P,P_seat_number,w1,w2,v);


minr=zeros(MAXGEN,1)
minc=zeros(MAXGEN,1)
minu=zeros(MAXGEN,1)
minw=zeros(MAXGEN,1)


functionvalue=zeros(size(Chrom,1),3);           %合并后种群的各目标函数值

%% 初始种群分布
functionvalue(:,1)=routelength
functionvalue(:,2)=contactnum
% functionvalue(:,3)=usedtaxi
functionvalue(:,3)=wt
functionvalue1=functionvalue
functionvalue0=functionvalue

%% 热图表示初始种群
for i=1:size(functionvalue,2)
    if max(functionvalue(:,i))>0
        if i==3
            functionvalue1(:,i)=functionvalue(:,i)./m;
        else
            functionvalue1(:,i)=functionvalue(:,i)./max(functionvalue(:,i));
        end
    else
        functionvalue1(:,i)=functionvalue(:,i);
    end
end
functionvalue1=sortrows(functionvalue1); 
figure(1)
h1 = heatmap(functionvalue1,'Colormap',parula,'GridVisible','off');
h1.XData = {'DD','CF','WT'};
clim([0,1]);
ax=gca;
ax.YDisplayLabels = nan(size(ax.YDisplayData));
title('初始种群')


%% 迭代
while gen<MAXGEN
    Pc=0.2*(MAXGEN-gen)/MAXGEN;                         %交叉概率
    Pm=0.8*(MAXGEN-gen)/MAXGEN;                         %变异概率
    Pe=0.8*(MAXGEN-gen)/MAXGEN;                         %交换概率
    
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
    
        
    [newroutelength,newcontactnum,newwt] = FounctionValue1(newChrom,n/2,m,P_WT,distanceD2P,distanceP2P,P_seat_number,w1,w2,v);
    %% 计算新种群目标函数值
    newChrom=[Chrom;newChrom];
    % 总路径长度
    routelength = [routelength;newroutelength];
    % 接触人数
    contactnum = [contactnum;newcontactnum];
    % 已用出租车数量
%     usedtaxi = [usedtaxi;newusedtaxi];
    %% 时间惩罚
    wt = [wt;newwt];

    functionvalue=zeros(size(newChrom,1),3)
    functionvalue(:,1)=routelength
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
    [routelength,contactnum,wt] = FounctionValue1(Chrom,n/2,m,P_WT,distanceD2P,distanceP2P,P_seat_number,w1,w2,v);
    gen=gen+1;
    disp(gen)
    %% 每次迭代种群的最小值
%     alloutput=sortrows(functionvalue(frontvalue==1,:))
    minr(gen)=min(routelength)
    minc(gen)=min(contactnum)
%     minu(gen)=min(usedtaxi)
    minw(gen)=min(wt)
end
%[routelength,contactnum,usedtaxi,wt] = FounctionValue(Chrom,n/2,m,P_WT,distanceD2P,distanceP2P,P_seat_number,w1,w2,v);
% output=sortrows(functionvalue(frontvalue==1,:));    %最终结果:种群中非支配解的函数值
functionvalue=[routelength,contactnum,wt];
frontvalue = nondominated_sort(functionvalue);
output=sortrows(functionvalue(frontvalue==1,:));
output1=output;
for i=1:size(output,2)
    if max(functionvalue0(:,i))>0
        output1(:,i)=output(:,i)./max(functionvalue0(:,i));
    else
        output1(:,i)=output(:,i);
    end
end
p=0.75;
if p>0.67
    if p<=0.77
        fitness=0.7.*(output1(:,1))+0.3.*(output1(:,2));
%         fitness=0.3.*(output1(:,1))+0.5.*(output1(:,2))+0.1.*(output1(:,3))+0.1.*(output1(:,4));
    elseif p>0.77 && p<=0.88
        fitness=0.5.*(output1(:,1))+0.5.*(output1(:,2));
    else
        fitness=0.4.*(output1(:,1))+0.6.*(output1(:,2));
    end    
elseif p>0.33 && p<=0.67
    if p<=0.44   
        fitness=0.78.*(output1(:,1))+0.22.*(output1(:,2));
    elseif p>0.44 && p<=0.55
        fitness=0.76.*(output1(:,1))+0.24.*(output1(:,2));
    else
        fitness=0.74.*(output1(:,1))+0.26.*(output1(:,2));
    end
else
    if p<=0.11
        fitness=0.95.*(output1(:,1))+0.05.*(output1(:,2));
    elseif p>0.11 && p<=0.22
        
        fitness=0.85.*(output1(:,1))+0.15.*(output1(:,2));
    else
        fitness=0.8.*(output1(:,1))+0.2.*(output1(:,2));
    end
end
% if p<0.1
%     fitness=0.95.*(output1(:,1))+0.05.*(output1(:,2));
% elseif p>=0.1 && p<0.2
%     fitness=0.9.*(output1(:,1))+0.1.*(output1(:,2));
% elseif p>=0.2 && p<0.3
%     fitness=0.8.*(output1(:,1))+0.2.*(output1(:,2));
% elseif p>=0.3 && p<0.4
%     fitness=0.7.*(output1(:,1))+0.3.*(output1(:,2));
% elseif p>=0.4 && p<0.5
%     fitness=0.6.*(output1(:,1))+0.4.*(output1(:,2));
% elseif p>=0.5 && p<0.6
%     fitness=0.5.*(output1(:,1))+0.5.*(output1(:,2));
% elseif p>=0.6 && p<0.7
%     fitness=0.4.*(output1(:,1))+0.6.*(output1(:,2));
% elseif p>=0.7 && p<0.8
%     fitness=0.3.*(output1(:,1))+0.7.*(output1(:,2));
% elseif p>=0.8 && p<0.9
%     fitness=0.2.*(output1(:,1))+0.8.*(output1(:,2));
% else
%     fitness=0.1.*(output1(:,1))+0.9.*(output1(:,2));
% end
[M,I]=min(fitness);
opt=output(I,:);
%% 绘图
figure(2)
hold on
plot(1:MAXGEN,minr)

xlabel('Iteration Count')
ylabel('Length of Path')
title('The length of path changes in each generation')
figure(3)
hold on
plot(1:MAXGEN,minc)
xlabel('Iteration Count')
ylabel('contact frequency')
title('The contact frequency changes in each generation')
% figure(4)
% 
% plot(1:MAXGEN,minu)
% xlabel('Iteration Count')
% ylabel('Number of Taxis Used')
% title('The Number of Taxis Used changes in each generation')
figure(5)
plot(1:MAXGEN,minw)
xlabel('Iteration Count')
ylabel('Punishment of Time')
title('The Punishment of Time changes in each generation')

% for i=1:size(output,2)
%     figure(i+9);
%     boxplot(output(:,i))
% end
%% 热图表示优化后的种群
figure(6)
h = heatmap(output1,'Colormap',parula,'GridVisible','off');
h.XData = {'DD','CF','WT'};
clim([0,1]);
ax=gca;
ax.YDisplayLabels = nan(size(ax.YDisplayData));
%title('优化后的种群')

%% 绘制箱线图

figure(7);% 宽135，高135
rng('default')  % For reproducibility
x1 = functionvalue0(:,1);
x2 = output(:,1);
x = [x1; x2];
%%步骤2
g1 = repmat({'Initial value'},size(functionvalue0(:,1),1),1);
g2 = repmat({'Optimized value'},size(output(:,1),1),1);
g = [g1; g2];

%%步骤3
% boxplot(x,g,'Notch','on',"Colors","rb","BoxStyle","filled")
% boxplot(x,g,'Colors','rb','OutlierSize',1,'symbol','+')
h1=boxplot(x,g,'OutlierSize',6);
set(h1,'Linewidth',1.5);
%xlabel('Category of population')
ylabel('DD (km)')

figure(8);
rng('default')  % For reproducibility
x1 = functionvalue0(:,2);
x2 = output(:,2);
x = [x1; x2];
%%步骤2
g1 = repmat({'Initial value'},size(functionvalue0(:,2),1),1);
g2 = repmat({'Optimized value'},size(output(:,2),1),1);
g = [g1; g2];

%%步骤3
h2=boxplot(x,g,'OutlierSize',6);
set(h2,'Linewidth',1.5);
%xlabel('Category of population')
ylabel('CF')

figure(9);
rng('default')  % For reproducibility
x1 = functionvalue0(:,3);
x2 = output(:,3);
x = [x1; x2];
%%步骤2
g1 = repmat({'Initial value'},size(functionvalue0(:,3),1),1);
g2 = repmat({'Optimized value'},size(output(:,3),1),1);
g = [g1; g2];

%%步骤3
h3=boxplot(x,g,'OutlierSize',6);
set(h3,'Linewidth',1.5);
%xlabel('Category of population')
ylabel('NRU')

% figure(10);
% rng('default')  % For reproducibility
% x1 = functionvalue0(:,3);
% x2 = output(:,3);
% x = [x1; x2];
% %%步骤2
% g1 = repmat({'Initial value'},size(functionvalue0(:,3),1),1);
% g2 = repmat({'Optimized value'},size(output(:,3),1),1);
% g = [g1; g2];
% 
% %%步骤3
% h4=boxplot(x,g,'OutlierSize',6);
% set(h4,'Linewidth',1.5);
% %xlabel('Category of population')
% ylabel('WT (minute)')

toc