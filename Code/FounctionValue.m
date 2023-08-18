function [routelength,contactnum,wt] = FounctionValue(Chrom,n,m,P_TW,distanceD2P,distanceP2P,P_seat_number,w1,w2,v)
%FounctionValue 计算目标函数 
%n 订单数量
%m 出租车数量
[NIND,codelength] = size(Chrom);
    routelength=zeros(NIND,1);
%     n=size(P_position,1);
    contactnum=zeros(NIND,1);
    usedtaxi=zeros(NIND,1);
    wt=zeros(NIND,1);
    for i=1:NIND
        time=0;
        for j=1:codelength            
            if Chrom(i,j)<=n
                k=j+1;
                while k<=codelength && Chrom(i,k)<=2*n && Chrom(i,k)~=Chrom(i,j)+n/2
                    if Chrom(i,k)<=n
                        contactnum(i)=contactnum(i)+P_seat_number(Chrom(i,k));
                    end
                    k=k+1;
                end
                if time>P_TW(Chrom(i,j))
                    wt(i)=wt(i)+w2*(time-P_TW(Chrom(i,j)));
                else
                    wt(i)=wt(i)+w1*(P_TW(Chrom(i,j))-time);
                end
                routelength(i)=routelength(i)+distanceP2P(Chrom(i,j),Chrom(i,j+1));
                time=distanceP2P(Chrom(i,j),Chrom(i,j+1))/v;
            end
            if Chrom(i,j)>n && Chrom(i,j)<=n*2
                if j+1<=codelength && Chrom(i,j+1)<=n*2
                    routelength(i)=routelength(i)+distanceP2P(Chrom(i,j),Chrom(i,j+1));
                    time=distanceP2P(Chrom(i,j),Chrom(i,j+1))/v;
                end
            end
            if Chrom(i,j)>n*2
                if j>1 && Chrom(i,j-1)<=2*n
                    usedtaxi(i)=usedtaxi(i)+1;
                end
                if j+1<=codelength && Chrom(i,j+1)<=n
%                     usedtaxi(i)=usedtaxi(i)+1;
                    routelength(i)=routelength(i)+distanceD2P(Chrom(i,j)+1-n*2,Chrom(i,j+1));
%                     time=distanceD2P(Chrom(i,j)+1-n*2,Chrom(i,j+1))/v;
                    time=0;
                end
            end
            if j==codelength && Chrom(i,j)<=n*2
                usedtaxi(i)=usedtaxi(i)+1;
            end
        end
        wt(i)=wt(i)/m;
    end
end