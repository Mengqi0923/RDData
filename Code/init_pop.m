%% ��ʼ����Ⱥ
%����NIND��                ��Ⱥ��Ŀ
%����N��                   Ⱦɫ�峤��
%����cusnum��              �˿���Ŀ
%����init_vc��             ��ʼ���ͷ���
%���Chrom��               ��ʼ��Ⱥ
function Chrom=init_pop(NIND,N,n,P_WT,P_seat_number,D_seat_number)
Chrom=zeros(NIND,N);%���ڴ洢��Ⱥ

for j=1:NIND
    init_vc=init(n,P_WT,P_seat_number,D_seat_number); 
    individual=change(init_vc,N,n);
    Chrom(j,:)=individual;
end