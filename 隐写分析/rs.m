%输入格式： rate=rs('rand.bmp')
%主函数：
function rate=rs(input) 
cover=imread(input);
cover=double(cover);
cover=cover(:)';
[m,n] = size(cover);
cover1=cover;
k = n/4;

R = zeros(2, 4); %用来存储两组RS的四个值
M = [1;0;0;1]; %用来实现随即翻转
bloc = zeros(4, 1);
for j = 1 : k        %做非负和非正翻转，再计算相关性
    bloc=cover1((j-1)*4+1:j*4);  %每四个像素放在一起
    summ(1) = f(bloc);
    summ(2) = f(posturn(bloc,M));
    summ(3) = f(negturn(bloc,M));
    if summ(2) > summ(1)  %Rm
        R(1,1) = R(1,1) + 1;
    end
    if summ(2) < summ(1)  %Sm
        R(1,2) = R(1,2) + 1;
    end
    if summ(3) > summ(1)  %R_m
        R(1,3) = R(1,3) + 1; 
    end
    if summ(3) < summ(1)  %S_m
        R(1,4) = R(1,4) + 1;
    end
end

cover2 = posturn(cover1, ones(n, 1));  %先对载体全做正翻转，接着做非负和非正翻转，再计算相关性
for j = 1 : k        
    bloc=cover2((j-1)*4+1:j*4);  
    summ(1) = f(bloc);
    summ(2) = f(posturn(bloc,M));
    summ(3) = f(negturn(bloc,M));
    if summ(2) > summ(1)  %Rm
        R(2,1) = R(2,1) + 1;
    end
    if summ(2) < summ(1)  %Sm
        R(2,2) = R(2,2) + 1;
    end
    if summ(3) > summ(1)  %R_m
        R(2,3) = R(2,3) + 1; 
    end
    if summ(3) < summ(1)  %S_m
        R(2,4) = R(2,4) + 1;
    end
end
R = R/k;
dpz = R(1,1) - R(1,2); dpo = R(2,1) - R(2,2);
dnz = R(1,3) - R(1,4); dno = R(2,3) - R(2,4);
C = [2 * (dpo + dpz), (dnz - dno - dpo - 3 * dpz), (dpz - dnz)];
r = roots(C);
p = r./(r - 0.5);
rate=p(2);

end


%其他函数：
% 计算相关复杂度
function y = f(x)  
n = length(x);
y = sum(abs(x(1:n-1) - x(2:n)));
end

%非负翻转,F1变换和F0变换
function y = posturn(x, M)  
M=M';
y = x + (1 - 2 * mod(x, 2)) .* M;
end

% 非正翻转，F-1变换和F0变换
function y = negturn(x, M) 
M=M';
y = x + (2 * mod(x, 2) - 1) .* M;
end