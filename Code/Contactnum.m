function [ contactnum ] = Contactnum( Chrom,P_position,P_seat_number )
%Contactnum 计算接触人数
%   一次匹配的总接触人数
    [NIND,m] = size(Chrom);
    n=size(P_position,1);
    contactnum=zeros(NIND,1);
    for i=1:NIND %种群大小
        for j=1:m % 遍历每辆车
            loc=zeros(1,size(Chrom{i,j},2));
            
            if size(Chrom{i,j},2)>=3
                for k=2:size(Chrom{i,j},2)-1
                    for ii=k+1:size(Chrom{i,j},2)
                        if Chrom{i,j}(ii)== Chrom{i,j}(k)+n/2
                            loc(k)=ii;
                            break;
                        end
                    end
                end
                for k=2:size(Chrom{i,j},2)-1
                    if Chrom{i,j}(k)<=n/2
                        for ii=2:n
                            if ((ii<k && loc(ii)>k) || (ii>k && ii<loc(k))) && (Chrom{i,j}(ii)<=n/2)
                                contactnum(i)=contactnum(i)+P_seat_number(Chrom{i,j}(ii));
                            end
                        end
                    end
                end
            end
            
        end
    end
end

