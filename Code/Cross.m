function [ newChrom ] = Cross( Chrom,Pc,n,m,P_seat_number,D_seat_number )
%   交叉
%   个体内部交叉，任意两个出租车路径交换,n订单总数，P_TW时间窗，v速度，distanceD2P,distanceP2P
    newChrom=Chrom;
    NIND = size(newChrom,1);
    for i=1:NIND
        if rand()<Pc
            r1=randi([n*2+1 n*2+m-1]);
            r2=randi([n*2+1 n*2+m-1]);
            while r1==r2
                r1=randi([n*2+1 n*2+m-1]);
                r2=randi([n*2+1 n*2+m-1]);
            end
            a=min([r1,r2]);
            b=max([r1,r2]);
            aindex=find(Chrom(i,:)==a);
            bindex=find(Chrom(i,:)==b);
            bindex0=find(Chrom(i,:)==b-1);
            j=bindex0+1;
            count=0;
            tag=0;
            % 判断交换序列是否会超载
            while Chrom(i,j)<b
                if Chrom(i,j)<=n
                    count=count+P_seat_number(Chrom(i,j));
                    if count>D_seat_number(a-n*2)
                        tag=1;
                        break;
                    end
                else
                    count=count-P_seat_number(Chrom(i,j)-n);
                end
                j=j+1;
            end
            if tag==1
                continue;
            end
            if a==(n*2+1) % 第一辆车
                if aindex==1 % 第一辆为空
                    if b==a+1 % b为第二辆车
                        if bindex0+1==bindex % 第二辆为空
                            continue;
                        else % 第二辆不为空
                            newChrom(i,:)=[Chrom(i,(aindex+1):(bindex-1)),a,Chrom(i,bindex:end)];
                        end
                    else % b非a的后一辆车
                        if bindex0+1==bindex % b为空
                            continue;
                        else
                            newChrom(i,:)=[Chrom(i,(bindex0+1):(bindex-1)),a,Chrom(i,(aindex+1):bindex0),b,Chrom(i,(bindex+1):end)];
                        end
                    end
                else % a非空
                    if b==a+1 % b为第二辆车
                        if bindex0+1==bindex % 第二辆为空
                            newChrom(i,:)=[a,Chrom(i,1:aindex-1),Chrom(i,bindex:end)];
                        else
                            newChrom(i,:)=[Chrom(i,(aindex+1):(bindex-1)),a,Chrom(i,1:aindex-1),Chrom(i,bindex:end)];
                        end
                    else % b非a的后一辆车
                        if bindex0+1==bindex % b为空
                            newChrom(i,:)=[Chrom(i,aindex:bindex0),Chrom(i,1:aindex-1),Chrom(i,bindex:end)];
                        else
                            newChrom(i,:)=[Chrom(i,(bindex0+1):(bindex-1)),Chrom(i,aindex:bindex0),Chrom(i,1:aindex-1),Chrom(i,bindex:end)];
                        end
                    end
                end
            else % a非第一辆车
                aindex0=find(Chrom(i,:)==a-1);
                if aindex0+1==aindex % a为空
                    if b==a+1 % b为a的下一辆车
                        if bindex0+1==bindex % b为空
                            continue;
                        else
                            newChrom(i,:)=[Chrom(i,1:aindex0),Chrom(i,(aindex+1):(bindex-1)),a,Chrom(i,bindex:end)];
                        end
                    else % b非a的下一辆车
                        if bindex0+1==bindex
                            continue;
                        else
                            newChrom(i,:)=[Chrom(i,1:aindex0),Chrom(i,(bindex0+1):(bindex-1)),Chrom(i,aindex:bindex0),Chrom(i,bindex:end)];
                        end
                    end

                else % a非空
                    if b==a+1 % b为第二辆车
                        if bindex0+1==bindex % 第二辆为空
                            newChrom(i,:)=[Chrom(i,1:aindex0),a,Chrom(i,(aindex0+1):(aindex-1)),Chrom(i,bindex:end)];
                        else
                            newChrom(i,:)=[Chrom(i,1:aindex0),Chrom(i,(aindex+1):(bindex-1)),a,Chrom(i,(aindex0+1):(aindex-1)),Chrom(i,bindex:end)];
                        end
                    else % b非a的后一辆车
                        if bindex0+1==bindex
                            newChrom(i,:)=[Chrom(i,1:aindex0),Chrom(i,aindex:bindex0),Chrom(i,(aindex0+1):(aindex-1)),Chrom(i,bindex:end)];
                        else
                            newChrom(i,:)=[Chrom(i,1:aindex0),Chrom(i,(bindex0+1):(bindex-1)),Chrom(i,(aindex):(bindex0)),Chrom(i,(aindex0+1):(aindex-1)),Chrom(i,bindex:end)];
                        end
                    end
                end
            end

        end        
    end
end

