function [watermarkimagergb,watermarkimage,waterCA,watermark]=dwtspread2(input,goal,seed,wavelet,level,alpha)
%读取原始图像
data=imread(input);
data=double(data)/255;
datared=data(:,:,1);%在R层加水印
%对原始图像的R层进行小波分解记录原始大小,并将其补成正方
[C,Sreal]=wavedec2(datared,level,wavelet);
[row,list]=size(datared);
standard1=max(row,list);
new=zeros(standard1,standard1);
if row<=list
   new(1:row,:)=datared;
else
   new(:,1:list)=datared;
end   
%正式开是加水印
%小波分解,提取低频系数
[C,S]=wavedec2(new,level,wavelet);
CA=appcoef2(C,S,wavelet,level);
%对低频系数进行归一化处理
[M,N]=size(CA);
CAmin=min(min(CA));
CAmax=max(max(CA));
CA=(1/(CAmax-CAmin))*(CA-CAmin);
d=max(size(CA));
%对低频率系数单值分解
[U,sigma,V]=svd(CA);

%读取水印图像
logobmp_ori=imread('logo.bmp')
logobmp=double(logobmp_ori)/255;
%logobmp=round(logobmp);
logobmp=logobmp(:);
[logoh,logol]=size(logobmp);
%扩频成原始图像R层像素数一样多
n=row*list/logoh;
for i=1:logoh
    for j=2:n
        logobmp(i,j)=logobmp(i,1);
    end
end
 logobmp=logobmp(:)';
[logoh,logol]=size(logobmp);
%m序列(这里用随机序列二值化代替)
rand('seed',seed);
mesquence=rand(1,logol);
for i=1:logoh
    if mesquence(i)>0.5
        mesquence(i)=1;
    else
        mesquence(i)=0;
    end
end
%gold码
spread_mark=xor(logobmp,mesquence);

%变为和原始图像R层等大的二维矩阵
item=1;
for i=1:row
    for j=1:list
        spread_mark2(i,j)=spread_mark(item);
        item=item+1;
    end
end
spread_mark=spread_mark2;

%进行dwt+svd操作
[C1,S1]=wavedec2(spread_mark,level,wavelet);
CA1=appcoef2(C1,S1,wavelet,level);
%对低频系数进行归一化处理
[M1,N1]=size(CA1);
CAmin1=min(min(CA1));
CAmax1=max(max(CA1));
CA1=(1/(CAmax-CAmin))*(CA1-CAmin);
d1=max(size(CA1));
%对低频率系数单值分解
[U1,sigma1,V1]=svd(CA1);

sigma_tilda=alpha*flipud(sort(rand(d,1)));
watermark=CA+U1*diag(sigma_tilda,0)*V1';
%重构生成水印的形状,便于直观认识,本身无意义
watermark2=reshape(watermark,1,S(1,1)*S(1,2));
waterC=C1;
waterC(1,1:S(1,1)*S(1,2))=watermark2;
watermark2=waverec2(waterC,S,wavelet);
%调整系数生成嵌入水印后的图片
CA_tilda=watermark;
over1=find(CA_tilda>1);
below0=find(CA_tilda<0);
CA_tilda(over1)=1;
CA_tilda(below0)=0;%系数调整,将过幅与附数修正

CA_tilda=(CAmax-CAmin)*CA_tilda+CAmin;%系数还原到归一化以前的范围
%记录加有水印的低频系数
waterCA=CA_tilda;
if row<=list
   waterCA=waterCA(1:Sreal(1,1),:);
else
   waterCA=waterCA(:,1:Sreal(1,2));
end   
%重构
CA_tilda=reshape(CA_tilda,1,S(1,1)*S(1,2));
C(1,1:S(1,1)*S(1,2))=CA_tilda;
watermarkimage=waverec2(C,S,wavelet);
%将前面补上的边缘去掉
if row<=list
  watermarkimage=watermarkimage(1:row,:);
else
   watermarkimage=watermarkimage(:,1:list);
end   
watermarkimagergb=data;
watermarkimagergb(:,:,1)=watermarkimage;
imwrite(watermarkimagergb,goal,'BitDepth',16);%通过写回修正过幅系数
watermarkimagergb2=imread(goal);