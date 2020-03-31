# 文件说明：
9999.jpg     载体图像

test.txt     隐秘信息

9999test.bmp 含有隐秘信息的图像

secret.txt    从9999test.bmp中提取的信息

lsbget.m     从9999test.bmp中提取数据到secret.txt中

lsbhide.m    把test.txt的信息藏到9999test.bmp里面

compare.m    将9999.jpg和9999test.bmp图片矩阵相减，得到隐写的位置，把结果图片放大能看到隐写位置