function result= md52num(md5code)
%%将md5码转换成数字

result=0;
for i=1:32
    result=result+ tablec(md5code(i))*i;
end
end

