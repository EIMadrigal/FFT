clc;
clear;

%输入频率f，采样点数N，采样间隔T，是否补零，初始相位
f = input('Please enter the frequency(Hz): ');
N = input('Please enter the number of samples: ');
T = input('Please enter the sampling interval(s): ');
flag = input('Would you like to add zero(enter 1) or not(enter 0)?');
phi = input('Please enter the initial phase:');

%采样
i = 0:T:(N - 1)*T;
y = sin(2*pi*f*i + phi);

%补零
if flag == 1
    num_zero = input('Please enter the number of zeros: ');
    N = N + num_zero;
    b = zeros(1,num_zero);    %生成一个1行，num_zero列的零矩阵
    y = [y,b];
end

%码位倒置
M = log2(N);      %共有M级运算
temp = 0:N-1;     
addr_modi = bin2dec(fliplr(dec2bin(temp,M)));      %变址
for s = 1:N
    A(s) = y(addr_modi(s) + 1);  %matlab中数组下标从1开始，故加1。
end                              %将采样值按照变址顺序存入数组A中


%FFT蝶形算法
%只需计算一半系数
for z = 0:N/2-1
    W_N(z + 1) = exp(-1j*2*pi*z/N);
end

for t = 1:M        %级循环
    dist = 2^(t - 1);    %表示第M级中每个蝶形单元上下结点的距离，也表示第M级不同系数的个数
    for k = 1:dist       %每一级中按照系数不同进行组循环
        index = (k - 1)*(2^(M - t));       %W_N的系数
        for up = k:2^t:N   %系数相同的组内循环
            down = up + dist;     %up表示每个蝶形单元上面结点编号，down表示下面结点编号
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
 
stem(temp,abs(A)/max(abs(A)))     %画出FFT结果的火柴杆图并归一化