% 输入格式举例:  F=compare('9999.jpg','9999test.bmp')
% 参数说明:
% original 是原始载体图像
% hided 是隐秘后的图像 
% F 是差值矩阵
function  F=compare(original,hided) % 读取原始载体图像矩阵
W=imread(original) ;
W=double(W)/255; 
% 读取隐秘后图像矩阵
E=imread(hided) ;
E=double(E)/255;
% 将两图像矩阵相减, 显示效果 
F=E-W; 
% 注意, MATLAB 中矩阵相减只支持 double 型
imshow(mat2gray(F)) 