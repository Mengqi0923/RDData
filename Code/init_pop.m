%% 初始化种群
%输入NIND：                种群数目
%输入N：                   染色体长度
%输入cusnum：              顾客数目
%输入init_vc：             初始配送方案
%输出Chrom：               初始种群
function Chrom=init_pop(NIND,N,n,P_WT,P_seat_number,D_seat_number)
Chrom=zeros(NIND,N);%用于存储种群

for j=1:NIND
    init_vc=init(n,P_WT,P_seat_number,D_seat_number); 
    individual=change(init_vc,N,n);
    Chrom(j,:)=individual;
end