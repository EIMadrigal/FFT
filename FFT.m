clc;
clear;

%����Ƶ��f����������N���������T���Ƿ��㣬��ʼ��λ
f = input('Please enter the frequency(Hz): ');
N = input('Please enter the number of samples: ');
T = input('Please enter the sampling interval(s): ');
flag = input('Would you like to add zero(enter 1) or not(enter 0)?');
phi = input('Please enter the initial phase:');

%����
i = 0:T:(N - 1)*T;
y = sin(2*pi*f*i + phi);

%����
if flag == 1
    num_zero = input('Please enter the number of zeros: ');
    N = N + num_zero;
    b = zeros(1,num_zero);    %����һ��1�У�num_zero�е������
    y = [y,b];
end

%��λ����
M = log2(N);      %����M������
temp = 0:N-1;     
addr_modi = bin2dec(fliplr(dec2bin(temp,M)));      %��ַ
for s = 1:N
    A(s) = y(addr_modi(s) + 1);  %matlab�������±��1��ʼ���ʼ�1��
end                              %������ֵ���ձ�ַ˳���������A��


%FFT�����㷨
%ֻ�����һ��ϵ��
for z = 0:N/2-1
    W_N(z + 1) = exp(-1j*2*pi*z/N);
end

for t = 1:M        %��ѭ��
    dist = 2^(t - 1);    %��ʾ��M����ÿ�����ε�Ԫ���½��ľ��룬Ҳ��ʾ��M����ͬϵ���ĸ���
    for k = 1:dist       %ÿһ���а���ϵ����ͬ������ѭ��
        index = (k - 1)*(2^(M - t));       %W_N��ϵ��
        for up = k:2^t:N   %ϵ����ͬ������ѭ��
            down = up + dist;     %up��ʾÿ�����ε�Ԫ�������ţ�down��ʾ��������
            if down>N
                break;
            else
                temp1 = A(down)*W_N(index + 1);
                A(down) = A(up) - temp1;
                A(up) = A(up) + temp1;
            end
        end
    end
end
 
stem(temp,abs(A)/max(abs(A)))     %����FFT����Ļ���ͼ����һ��