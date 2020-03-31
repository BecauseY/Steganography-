function [row, col, j] = hashreplacement(matrix, quantity, key1, key2, key3)
%%随机置换函数:利用md5函数产生随机的无碰撞的像素选择策略
%%matrix为载体矩阵，quantity为嵌入的信息位数，key1,key2,key3为三个密钥

[X, Y] = size(matrix);
row = zeros([1, quantity]);
col = zeros([1, quantity]);
j = zeros([1,quantity]);
for i = 1:quantity
    v = round(i/X);
    u = mod(i, X);
    v = mod(v+md52num(md(u+key1)),Y);
    u = mod(u+md52num(md(v+key2)),X);
    v = mod(v+md52num(md(u+key3)),Y);
    j(i) = v * X + u + 1;
    col(i) = mod(j(i), Y);
    row(i) = floor(j(i)/Y);
    row(i) = double(uint8(row(i)))+1;
    if col(i) == 0
        col(i) = Y;
        row(i) = row(i)-1;
    end
end

end
