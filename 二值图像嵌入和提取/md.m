function y = md(num)
fid = fopen('D:\temp.txt','w');
fprintf(fid,'%d',num);
y = md5('D:\temp.txt');
fclose(fid);
delete('D:\temp.txt');