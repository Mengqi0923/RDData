%% 构造VRPTW初始解
%输入n：      订单数目
%输入P_WT：           顾客左时间窗
%输入P_seat_number：     顾客需求量
%输入D_seat_number：         车辆容量
%输出init_vc：     初始解
function init_vc=init_No_Carpool(n,P_WT,P_seat_number,D_seat_number)
k=1;                                    %使用车辆数目，初始设置为1
init_vc=cell(k,1);
% 按照如下序列，遍历每个顾客，并执行以下步骤
seq=randperm(n);
% 开始遍历
route=[];       %存储每条路径上的顾客
load=0;         %初始路径上在出租车上的装载量为0
i=1;
while i<=n
    %如果没有超过容量约束，则按照左时间窗大小，将顾客添加到当前路径
    if load+P_seat_number(seq(i))<=D_seat_number(k)
        load=load+P_seat_number(seq(i));          %初始在出租车上的装载量增加
        %如果当前路径为空，直接将顾客添加到路径中
        if isempty(route)
            route=[seq(i),seq(i)+n];
            %如果当前路径只有一个顾客，再添加新顾客时，需要根据左时间窗大小进行添加
        elseif length(route)==2
            if P_WT(seq(i))<=P_WT(route(1))
                route=[seq(i),seq(i)+n,route];
            else
                route=[route,seq(i),seq(i)+n];
            end
        else
            lr=length(route)/2;       %当前路径长度,则有lr-1对连续的顾客
            flag=0;                 %标记是否存在这样1对顾客，能让seq(i)插入两者之间
            if P_WT(seq(i))<P_WT(route(1))
                route=[seq(i),seq(i)+n,route];
            elseif P_WT(seq(i))>P_WT(route(end-1))
                route=[route,seq(i),seq(i)+n];
            else
                %遍历这lr-1对连续的顾客的中间插入位置
                for m=1:lr-1
                    if (P_WT(seq(i))>=P_WT(route(m*2-1)))&&(P_WT(seq(i))<=P_WT(route(m*2+1)))
                        route=[route(1:m*2),seq(i),seq(i)+n,route(m*2+1:end)];
                        break
                    end
                end
            end
        end
        %如果遍历到最后一个顾客，则更新init_vc，并跳出程序
        if i==n
            init_vc{k,1}=route;
            break
        end
        i=i+1;
    else   %一旦超过车辆装载量约束，则需要增加一辆车
        %先储存上一辆车所经过的顾客
        init_vc{k,1}=route;
        %然后将route清空，load清零,k加1
        route=[];
        load=0;
        k=k+1;
    end
end
route=init_vc{k,1};
init_vc{k,1}=route;
end