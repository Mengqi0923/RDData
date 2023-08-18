function [cost,wt] = FounctionValueNoCarpool(Chrom,n,m,P_TW,distanceD2P,distanceP2P,w1,w2,v)
%FounctionValue 计算目标函数
%n 订单数量
%m 出租车数量
[NIND,codelength] = size(Chrom);


cost=zeros(NIND,1); %成本
wt=zeros(NIND,1);
eta=0.05; %空车成本
rou=0.35; %载人单位里程成本
for i=1:NIND
    individual=cell(m,1);
    indextaxi=1;
    for j=1:codelength
        if Chrom(i,j)<=n*2
            individual{indextaxi}=[individual{indextaxi},Chrom(i,j)];
        else
            indextaxi=indextaxi+1;
        end
    end
    for k=1:m
        time=0;
        if size(individual{k},2)>0
            cost(i)=cost(i)+rou*distanceD2P(k,individual{k}(1));
            time=time+distanceD2P(k,individual{k}(1))/v;
            for j=1:size(individual{k},2)-1
                if individual{k}(j)<=n
                  
                    if time<P_TW(individual{k}(j))
                        wt(i)=wt(i)+w1*(P_TW(individual{k}(j))-time);
                    else
                        wt(i)=wt(i)+w2*(time-P_TW(individual{k}(j)));
                    end
                end
                cost(i)=cost(i)+rou*distanceP2P(individual{k}(j),individual{k}(j+1));
                time=time+distanceP2P(individual{k}(j),individual{k}(j+1))/v;
            end
        else
            cost(i)=cost(i)+eta;
            
        end
    end


end