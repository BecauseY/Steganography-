%文件名:wavedetect.m
%程序员:郭迟
%编写时间:2003.10.7
%函数功能:本函数将完成W-svd模型下数字水印的检测
%输入格式举例:[corr_coef,corr_DCTcoef]=detect('embed.png','girl.jpg',1983,'db6',2,0.1)
%参数说明:
%input为输入原始图像
%seed为随机数种子
%wavelet为使用的小波函数
%level为小波分解的尺度
%alpha为水印强度
%ratio为算法中d/n的比例
%corr_coef,corr_DCTcoef分别为不同方法下检测出的相关系数
function [corr_coef,corr_DCTcoef]=detect(test,original,seed,wavelet,level,alpha)
%function realCA=wavedetect(test,original,seed,wavelet,level,alpha,ratio)
dataoriginal=imread(original);
datatest=imread(test);
dataoriginal=double(dataoriginal)/255;
datatest=double(datatest)/65535;
dataoriginal=dataoriginal(:,:,1);
datatest=datatest(:,:,1);
%提取加有水印的图像的小波低频系数
[watermarkimagergb,watermarkimage,waterCA,watermark2,S_sigma,S_C,S_S]=wavemarksvd(original,'temp.png',seed,wavelet,level,alpha);
%提取待测图像的小波低频系数
[row,list]=size(datatest);
[C,S]=wavedec2(datatest,level,wavelet);
CA_test=appcoef2(C,S,wavelet,level);
%提取原始图像的小波低频系数
[C,S]=wavedec2(dataoriginal,level,wavelet);
realCA=appcoef2(C,S,wavelet,level);
%生成两种水印
realwatermark=waterCA-realCA;
testwatermark=CA_test-realCA;

%计算相关性
corr_coef=trace(realwatermark'*testwatermark)/(norm(realwatermark,'fro')*norm(testwatermark,'fro'));
%DCT 系数比较
DCTrealwatermark=dct2(waterCA-realCA);
DCTtestwatermark=dct2(CA_test-realCA);
DCTrealwatermark=DCTrealwatermark(1:min(32,max(size(DCTrealwatermark))),1:min(32,max(size(DCTrealwatermark))));
DCTtestwatermark=DCTtestwatermark(1:min(32,max(size(DCTtestwatermark))),1:min(32,max(size(DCTtestwatermark))));
DCTrealwatermark(1,1)=0;
DCTtestwatermark(1,1)=0;
corr_DCTcoef=trace(DCTrealwatermark'*DCTtestwatermark)/(norm(DCTrealwatermark,'fro')*norm(DCTtestwatermark,'fro'));

%-----------------------将扩频信号（水印）还原成窄带信号
[S_U,S_sigma,S_V] = svd(testwatermark);
S_CA = S_U*S_sigma*S_V';
S_CA=reshape(S_CA,1,S_S(1,1)*S_S(1,2));
S_C(1,1:S_S(1,1)*S_S(1,2))=S_CA;
spread_mark3 = waverec2(S_C,S_S,wavelet);
spread_mark3 = round(abs(spread_mark3));
goldcode = reshape(spread_mark3,[1,row*list])
%-----------------------------------异或操作得到扩频信号
S_mark=xor(goldcode,m_sequence);
sz = size(S_mark,2);
n = 0
flag = 0
for i = 1:sz
    flag = flag + 1;
    if flag == 9
        n = n + 1;
        flag = 0;
        mark(n) = S_mark(i);
    end
end
sz2 = size(mark,2);
for i=1:128
    for j=1:128
        spread_cache(i,j)=mark((i-1)*128+j);
    end
end
figure(2)
imshow(spread_cache)

