
%输入格式举例:waveextract('girlwsvd.png','girl.jpg',52,'db6',2,0.1)
%参数说明:
%input为输入原始图像
%seed为随机数种子
%wavelet为使用的小波函数
%level为小波分解的尺度
%alpha为水印强度

function waveextract(test,original,seed,wavelet,level,alpha)

%读取原始图像
data=imread(original);
data=double(data)/255;
datared=data(:,:,1);%在R层加水印
%小波分解,提取低频系数
[C,S]=wavedec2(datared,level,wavelet);
CA=appcoef2(C,S,wavelet,level);
%对低频系数进行归一化处理
[M,N]=size(CA);
CAmin=min(min(CA));
CAmax=max(max(CA));
CA=(1/(CAmax-CAmin))*(CA-CAmin);
d=max(size(CA));
%对低频率系数单值分解
[U,sigma,V]=svd(CA);


%读取含有水印的图像
datatest=imread(test);
datatest=double(datatest)/255;
datatestred=datatest(:,:,1);%在R层加水印
%小波分解,提取低频系数
[C1,S1]=wavedec2(datatestred,level,wavelet);
CA1=appcoef2(C1,S1,wavelet,level);
%对低频系数进行归一化处理
[M1,N1]=size(CA1);
CAmin1=min(min(CA1));
CAmax1=max(max(CA1));
CA1=(1/(CAmax1-CAmin1))*(CA1-CAmin1);
d1=max(size(CA1));
CA1=(CA1-CAmin)/(CAmax-CAmin);

watermark=(CA1-CA)*10;

%重构生成水印的形状
watermark2=reshape(watermark,1,S(1,1)*S(1,2));
waterC=C1;
waterC(1,1:S(1,1)*S(1,2))=watermark2;
watermark2=waverec2(waterC,S,wavelet);

watermark2=watermark2(:)';
[logoh,logol]=size(watermark2);
%m序列(这里用随机序列二值化代替)
rand('seed',seed);
mesquence=rand(1,logol);
for i=1:logol
    if mesquence(i)>0.5
        mesquence(i)=1;
    else
        mesquence(i)=0;
    end
end

spread_mark=xor(watermark2,mesquence);









