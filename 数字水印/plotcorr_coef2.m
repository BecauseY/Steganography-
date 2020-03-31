%文件名:plotcorr_coef.m
%程序员:郭迟
%编写时间:2003.10.7
%函数功能:这是一个绘制检测水印的相关性图的函数
%输入格式举例:corr_Wcoef=plotcorr_coef2('girlcell.jpg','jpg','girl.jpg','jpg',3,0.1,60)

%参数说明:
%test为待测图像
%original为原始图像
%testMAXseed为实验使用的最大随机数种子
%wavelet为使用的小波函数
%level为小波分解的尺度
%alpha为水印强度
%ratio为算法中d/n的比例
%corr_Wcoef,corr_Dcoef分别为利用不同种子检测出的相关系数的集合
function  [corr_Wcoef,corr_Dcoef]=plotcorr_coef2(test,permission1,original,permission2,do_num,alpha,testMAXseed)
corr_Wcoef=zeros(testMAXseed,1);
corr_Dcoef=zeros(testMAXseed,1);
s=1;
for i=1:testMAXseed
  corr_coef=wavedetect2(test,permission1,original,permission2,i,do_num,alpha);
  corr_Wcoef(s)=corr_coef;
  s=s+1;
end
subplot(111);plot(abs(corr_Wcoef));
title('水印检测阈值分析');
xlabel('种子');
ylabel('相关值');

