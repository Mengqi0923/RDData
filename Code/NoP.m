function [ num ] = NoP( a,n,nn,P_seat_number ) 
%   ���룺aΪһ��·�����У�nΪ·���еĵ�n��λ��,nnΪ����������P_seat_numberΪÿ�������������λ����
%   �����numΪ���⳵�ϵ�ǰ������
%   number of people �˿�����
%   ���⳵�ϵ�ʵʱ����
%     n=size(a,1);
    num=0;
    for i=2:n
        if a(i)<=nn
            num=num+P_seat_number(a(i));
        else
            num=num-P_seat_number(a(i)-nn);
        end
    end
end

