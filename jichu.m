clc;
clear; 
%读取图片
img1=imread('C:\Users\12943\Desktop\信息隐藏\图片\1085.jpg')
%RGB图像分层
img1R=img1(:,:,1)
img1G=img1(:,:,2)
img1B=img1(:,:,3)
%RGB图像合并
img2=cat(3,img1R,img1G,img1B)

%显示图像
subplot(321),imshow(img1),title('原始图像')
subplot(322),imshow(img2),title('拼接图像')

%转换灰度图像和二值图像
img3=rgb2gray(img1)
imwrite(img3, 'gray.bmp') 
img4=im2bw(img1,0.3)
subplot(323),imshow(img3),title('灰度图像')
subplot(324),imshow(img4),title('二值图像')

%大小
[row,col]=size(img1)

%函数
%t=0:0.01*pi:2*pi
%plot(t,sin(t));
%title('0到2∏的正弦曲线','FontSize',16);
%xlabel('t=0到2 ∏');
%ylabel('sin(t)');
%text(pi,sin(pi),'\leftarrow sin(t)=0');

img5=dct2(img1R)
subplot(325),imshow(img5),title('正变换图像')
img6=idct2(img1G)
subplot(326),imshow(img6),title('逆变换图像')