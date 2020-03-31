%lsb顺序提取
% 输入格式举例: result=lsbget('9999test.bmp',128,'secret.txt')
% 参数说明: 
% output 是信息隐秘后的图像
% len_total 是秘密消息的长度 
% goalfile 是提取出的秘密消息文件
% result 是提取的消息

function result=lsbget(output,len_total,goalfile)
%读取图片
ste_cover=imread(output) ;
ste_cover=double(ste_cover) ; 
% 判断嵌入消息量是否过大
[m,n]=size(ste_cover) ; 
frr=fopen(goalfile,'a') ; 
% p 作为消息嵌入位数计数器, 将消息序列写回文本文件
p=1; 
for f2=1:n  
    for f1=1:m
        if bitand(ste_cover(f1,f2),1)==1      
            result(p,1)=1;
        else
            result(p,1)=0;
        end
        if p==len_total
            break;
        end
        p=p+1;
    end
        if p==len_total
            break;
        end
end
fwrite(frr,result,'ubit1');
fclose(frr);