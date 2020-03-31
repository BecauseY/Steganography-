%输入格式举例:[watermarkimagergb,watermarkimage,waterCA,watermark,S_sigma,S_C]=wavemarksvd('girl.jpg','embed.png',1983,'db6',2,0.1)
function [watermarkimagergb,watermarkimage,waterCA,watermark,S_sigma,S_C,S_S] = wavemarksvd(input,goal,seed,wavelet,level,alpha)
data=imread(input);
data=double(data)/255;
datared=data(:,:,1);
%------------------------------对原始图像进行的svd操作
[row,list]=size(datared);
[C,S]=wavedec2(datared,level,wavelet);
CA=appcoef2(C,S,wavelet,level);
[M,N]=size(CA);
%--------------------------低频系数归一化
CAmin=min(min(CA));
CAmax=max(max(CA));
CA=(1/(CAmax-CAmin))*(CA-CAmin);
d=max(size(CA));
[U,sigma,V]=svd(CA);
%---------------------------R层作为水印图像
mark = imread('9999.jpg');
mark = double(mark)/255;
mark_R = mark(:,:,1);
%---------------------------将水印图像二值化
mark_R =  round(mark_R);
[height,width] = size(mark_R);
%---------------------------计算扩频的系数
times = row*list / (height*width);
%---------------------------将水印图像转成一维并扩频
for i = 1:height
    for j = 1:width
        for k=1:times
			S_mark((i-1)*width*times + (j-1)*times + k)= mark_R(i,j);
        end
    end
end
%-----------------------生成随机序列（代替m序列）
rand('seed',seed);
sz = size(S_mark,2);
m_sequence = rand(1,sz);
%-----------------------随机序列二值化
for i=1:sz
    if m_sequence(i)>=0.5
        m_sequence(i)=1;
    else
        m_sequence(i)=0;
    end
end
%-----------------------------------异或操作得到gold码
goldcode=xor(S_mark,m_sequence); 
%-----------------------------------还原成2维
spread_mark = reshape(goldcode,[row,list]);
% for i=1:row
%     for j=1:list
%         spread_cache(i,j)=spread_mark2(1,(i-1)*384+j);
%     end
% end
% spread_mark=spread_cache;
%-----------------------------------对扩频后的水印图像进行svd操作
[S_C,S_S]=wavedec2(spread_mark,level,wavelet);
S_CA=appcoef2(S_C,S_S,wavelet,level);
[M2,N2]=size(S_CA);
CAmin2=min(min(S_CA));
CAmax2=max(max(S_CA));
S_CA=(1/(CAmax2-CAmin2))*(S_CA-CAmin2);
d=max(size(S_CA));
[S_U,S_sigma,S_V]=svd(S_CA);
V2=S_V;
U2=S_U;
sigma_tilda=alpha*flipud(sort(rand(d,1)));
%-------------------------------------------生成嵌入水印图，替换u和v.


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
mark(:,:,1) = spread_cache*255
imshow(spread_cache)




watermark=U2*diag(sigma_tilda,0)*V2';
%-------------------------------------------重构生成水印的形状，便于直观认识，本身无意义
watermark2=reshape(watermark,1,S_S(1,1)*S_S(1,2));
waterC=S_C;
waterC(1,1:S_S(1,1)*S_S(1,2))=watermark2;
watermark2=waverec2(waterC,S_S,wavelet);
%-------------------------------------------生成嵌入水印后的图像
CA_tilda=watermark+CA;
%--------------------------------------------系数调整，将过幅系数与负数修正
over1=find(CA_tilda>1);
below0=find(CA_tilda<0);
CA_tilda(over1)=1;
CA_tilda(below0)=0;
%--------------------------------------------系数还原到归一化前范围
CA_tilda=(CAmax-CAmin)*CA_tilda+CAmin;
%--------------------------------------------记录加有水印的低频系数（仅保存）
waterCA=CA_tilda;
%--------------------------------------------重构
CA_tilda=reshape(CA_tilda,1,S(1,1)*S(1,2));
C(1,1:S(1,1)*S(1,2))=CA_tilda;
watermarkimage=waverec2(C,S,wavelet);
watermarkimagergb=data;
watermarkimagergb(:,:,1)=watermarkimage;
imwrite(watermarkimagergb,goal,'BitDepth',16);
watermarkimagergb2=imread(goal);
%-------------------------------------------图片展示
% mark(:,:,1) = mark_R*255;
figure(1);
subplot(321),imshow(watermark2*255);title('水印形态图');
subplot(322),imshow(mark);title('水印图像');
subplot(323),imshow(data);title('原始图像');
subplot(324),imshow(watermarkimagergb2);title('嵌入水印后的rgb图像');
subplot(325),imshow(datared);title('R层图像');
subplot(326),imshow(watermarkimage);title('嵌入水印后的R层图像');
