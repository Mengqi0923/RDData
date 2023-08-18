function [contact_number] = ContactOrderNumber(solution,m,n)
%ContactOrderNumber 计算解中会接触其他订单的订单总量
%   注：以订单为单位
contact_number=0;
individual=cell(m,1);
indextaxi=1;
for j=1:length(solution)
    if solution(j)<=n*2
        individual{indextaxi}=[individual{indextaxi},solution(j)];
    else
        indextaxi=indextaxi+1;
    end
end
for k=1:m
    if size(individual{k},2)>0
        for j=1:size(individual{k},2)-1
            if individual{k}(j)<=n
                index_jn=find(individual{k}==individual{k}(j)+n);
                for kk=1:j %j订单之前在车上的订单数
                    if individual{k}(kk)<=n && kk~=j
                        contact_number=contact_number+1;
                    else
                        if individual{k}(kk)>n
                            contact_number=contact_number-1;
                        end
                    end
                end
                for kk=(j+1):(index_jn-1) %订单j上车后的订单数
                    if individual{k}(kk)<=n
                        contact_number=contact_number+1;
                    end
                end
            end
        end
    end
end
end