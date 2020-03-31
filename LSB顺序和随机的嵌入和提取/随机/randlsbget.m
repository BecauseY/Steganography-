% 输入格式举例:  result = randlsbget('9999testrand.bmp' ,128, 'secretrand.txt' , 2001) 
% 参数说明:
% output 是信息隐秘后的图像 
% len_total 是秘密消息的长度 
% goalfile 是提取出的秘密消息文件
% key 是随机间隔函数的密钥 
% result 是提取的消息
function result = randlsbget( output, len_total, goalfile, key)
ste_cover = imread( output) ;
ste_cover = double( ste_cover) ;
% 判断嵌入消息量是否过大
[m,n] = size( ste_cover) ; 
frr = fopen( goalfile, 'a' ) ; 
% p 作为消息嵌入位数计数器, 将消息序列写回文本文件
p =1;
% 调用随机间隔函数选取像素点
[ row, col] = randinterval( ste_cover, len_total, key) ; 
for i = 1:len_total
    if bitand( ste_cover( row( i) , col( i) ) , 1) == 1    
        result( p,1) = 1;
    else
        result( p,1) = 0;
    end
    if p == len_total
        break;
    end
    p = p +1;
end
fwrite(frr,result,'ubit1');
fclose( frr) ; 