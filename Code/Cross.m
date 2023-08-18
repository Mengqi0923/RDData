function [ newChrom ] = Cross( Chrom,Pc,n,m,P_seat_number,D_seat_number )
%   ����
%   �����ڲ����棬�����������⳵·������,n����������P_TWʱ�䴰��v�ٶȣ�distanceD2P,distanceP2P
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
            % �жϽ��������Ƿ�ᳬ��
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
            if a==(n*2+1) % ��һ����
                if aindex==1 % ��һ��Ϊ��
                    if b==a+1 % bΪ�ڶ�����
                        if bindex0+1==bindex % �ڶ���Ϊ��
                            continue;
                        else % �ڶ�����Ϊ��
                            newChrom(i,:)=[Chrom(i,(aindex+1):(bindex-1)),a,Chrom(i,bindex:end)];
                        end
                    else % b��a�ĺ�һ����
                        if bindex0+1==bindex % bΪ��
                            continue;
                        else
                            newChrom(i,:)=[Chrom(i,(bindex0+1):(bindex-1)),a,Chrom(i,(aindex+1):bindex0),b,Chrom(i,(bindex+1):end)];
                        end
                    end
                else % a�ǿ�
                    if b==a+1 % bΪ�ڶ�����
                        if bindex0+1==bindex % �ڶ���Ϊ��
                            newChrom(i,:)=[a,Chrom(i,1:aindex-1),Chrom(i,bindex:end)];
                        else
                            newChrom(i,:)=[Chrom(i,(aindex+1):(bindex-1)),a,Chrom(i,1:aindex-1),Chrom(i,bindex:end)];
                        end
                    else % b��a�ĺ�һ����
                        if bindex0+1==bindex % bΪ��
                            newChrom(i,:)=[Chrom(i,aindex:bindex0),Chrom(i,1:aindex-1),Chrom(i,bindex:end)];
                        else
                            newChrom(i,:)=[Chrom(i,(bindex0+1):(bindex-1)),Chrom(i,aindex:bindex0),Chrom(i,1:aindex-1),Chrom(i,bindex:end)];
                        end
                    end
                end
            else % a�ǵ�һ����
                aindex0=find(Chrom(i,:)==a-1);
                if aindex0+1==aindex % aΪ��
                    if b==a+1 % bΪa����һ����
                        if bindex0+1==bindex % bΪ��
                            continue;
                        else
                            newChrom(i,:)=[Chrom(i,1:aindex0),Chrom(i,(aindex+1):(bindex-1)),a,Chrom(i,bindex:end)];
                        end
                    else % b��a����һ����
                        if bindex0+1==bindex
                            continue;
                        else
                            newChrom(i,:)=[Chrom(i,1:aindex0),Chrom(i,(bindex0+1):(bindex-1)),Chrom(i,aindex:bindex0),Chrom(i,bindex:end)];
                        end
                    end

                else % a�ǿ�
                    if b==a+1 % bΪ�ڶ�����
                        if bindex0+1==bindex % �ڶ���Ϊ��
                            newChrom(i,:)=[Chrom(i,1:aindex0),a,Chrom(i,(aindex0+1):(aindex-1)),Chrom(i,bindex:end)];
                        else
                            newChrom(i,:)=[Chrom(i,1:aindex0),Chrom(i,(aindex+1):(bindex-1)),a,Chrom(i,(aindex0+1):(aindex-1)),Chrom(i,bindex:end)];
                        end
                    else % b��a�ĺ�һ����
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

