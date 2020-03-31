% 输入格式举例: [ row, col] = randinterval( test, 60,1983)
% 参数说明:
% matrix 为载体矩阵 
% count 为要嵌入的信息的数量( 要选择的像素数量) 
% key 为密钥 
% row 为伪随机输出的像素行标 
% col 为伪随机输出的像素列标
function [ row, col] = randinterval( matrix, count, key) 
% 计算间隔的位数
[ m, n] = size( matrix) ;
interval1 = floor( m* n /count) + 1;
interval2 = interval1 - 2;
if interval2 == 0  
    error( ' 载体太小不能将秘密信息隐藏进去! ' ) ;
end
% 生成随机序列 
rand( 'seed' , key) ;
a = rand( 1, count) ; 
% 初始化
row = zeros( [ 1 count] ) ;
col = zeros( [ 1 count] ) ;
% 计算 row 和 col
r = 1;
c =1;
row( 1, 1) = r;
col( 1, 1) = c; 
for i = 2:count
    if a( i) >=0.5
        c = c + interval1;
    else
        c = c + interval2;
    end
    if c > n
        r = r +1;
        if r > m     
            error(' 载体太小不能将秘密信息隐藏进去! ' ) ;
        end
        c = mod( c, n) ;
        if c ==0
            c = 1;
        end
    end
row( 1, i) = r;
col( 1, i) = c;
end 