function [Chrom]=immigrant(Chrom,Chrom2,functionvalue,functionvalue2)
%% 移民算子
for i=1:size(functionvalue2,2)
    [MinO,MinI]=min(functionvalue2(:,i));          % 找出第i种群中最优的个体
    [MaxO,MaxI]=max(functionvalue(:,i));          % 找出目标种群中最劣的个体
    %% 目标种群最劣个体替换为源种群最优个体
    for j=1:size(Chrom,2)        
        Chrom{MaxI,j}=Chrom2{MinI,j};
    end
end
end
