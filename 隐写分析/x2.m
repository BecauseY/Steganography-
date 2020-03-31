%输入格式： [r,P]=x2('girllsb.bmp')
function [r,P]=x2(input) 
cover=imread(input);
cover=double(cover);
cover=uint8(cover);
S=[];
P_value=[];
interval=384/20;
 for j=0:19
    count=imhist(cover(:,floor(j* interval)+1:floor((j+1)* interval)));
    h_length=size(count);
    p_num=floor(h_length/2);
    r=0;
    k=0;
    for i = 1:p_num
        h=(count(2*i-1,1)+count(2*i,1))/2;
        q=(count(2*i-1,1)-count(2*i,1))/2;
        if h ~= 0        
            r=r+q*q/h;
            k=k+1;
        end
    end
    P=1-chi2cdf(r,k-1);
    S=[S r];
    P_value=[P_value P];
 end
 x_label=1:1:20
 figure,
 subplot(211),plot(x_label,S,'LineWidth',2),title('X^2统计');
 subplot(212),plot(x_label,P_value,'LineWidth',2),title('p值');
