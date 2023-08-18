%% ����VRPTW��ʼ��
%����n��      ������Ŀ
%����P_WT��           �˿���ʱ�䴰
%����P_seat_number��     �˿�������
%����D_seat_number��         ��������
%���init_vc��     ��ʼ��
function init_vc=init(n,P_WT,P_seat_number,D_seat_number)
j=ceil(rand*n);                    %�����й˿������ѡ��һ���˿�
k=1;                                    %ʹ�ó�����Ŀ����ʼ����Ϊ1
init_vc=cell(k,1);
% �����������У�����ÿ���˿ͣ���ִ�����²���
if j==1
    seq=1:n;
elseif j==n
    seq=[n,1:j-1];
else
    seq1=1:j-1;
    seq2=j:n;
    seq=[seq2,seq1];
end
% ��ʼ����
route=[];       %�洢ÿ��·���ϵĹ˿�
load=0;         %��ʼ·�����ڳ��⳵�ϵ�װ����Ϊ0
i=1;
while i<=n
    %���û�г�������Լ����������ʱ�䴰��С�����˿���ӵ���ǰ·��
    if load+P_seat_number(seq(i))<=D_seat_number(k)
        load=load+P_seat_number(seq(i));          %��ʼ�ڳ��⳵�ϵ�װ��������
        %�����ǰ·��Ϊ�գ�ֱ�ӽ��˿���ӵ�·����
        if isempty(route)
            route=[seq(i)];
            %�����ǰ·��ֻ��һ���˿ͣ�������¹˿�ʱ����Ҫ������ʱ�䴰��С�������
        elseif length(route)==1
            if P_WT(seq(i))<=P_WT(route(1))
                route=[seq(i),route];
            else
                route=[route,seq(i)];
            end
        else
            lr=length(route);       %��ǰ·������,����lr-1�������Ĺ˿�
            flag=0;                 %����Ƿ��������1�Թ˿ͣ�����seq(i)��������֮��
            if P_WT(seq(i))<P_WT(route(1))
                route=[seq(i),route];
            elseif P_WT(seq(i))>P_WT(route(end))
                route=[route,seq(i)];
            else
                %������lr-1�������Ĺ˿͵��м����λ��
                for m=1:lr-1
                    if (P_WT(seq(i))>=P_WT(route(m)))&&(P_WT(seq(i))<=P_WT(route(m+1)))
                        route=[route(1:m),seq(i),route(m+1:end)];
                        break
                    end
                end
            end
        end
        %������������һ���˿ͣ������init_vc������������
        if i==n
            init_vc{k,1}=route;
            break
        end
        i=i+1;
    else   %һ����������װ����Լ��������Ҫ����һ����
        %�ȴ�����һ�����������Ĺ˿�
        init_vc{k,1}=[route,route+n];
        %Ȼ��route��գ�load����,k��1
        route=[];
        load=0;
        k=k+1;
    end
end
route=init_vc{k,1};
init_vc{k,1}=[route,route+n];
end