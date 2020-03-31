
    seed = 1983;
    row = 384;
    list = 384;
    test = 'embed.png';
    original = 'girl.jpg';
    wavelet = 'db6';
    level = 2;
    alpha = 0.1;



    %---------------------------R层作为水印图像
    mark = imread('9999.jpg');
    mark = double(mark)/255;
    mark_R = mark(:,:,1);
    %---------------------------将水印图像二值化
    mark_R =  round(mark_R);
    [height,width] = size(mark_R);
    %---------------------------计算扩频的系数
    times = 384*384 / (height*width);
    %---------------------------将水印图像转成一维并扩频
    for i = 1:height
        for j = 1:width
            for k=1:times
                S_mark((i-1)*width*times + (j-1)*times + k)= mark_R(i,j);
            end
        end
    end
    %-----------------------生成随机序列（代替m序列）
    rand('seed',seed);
    sz = size(S_mark,2);
    m_sequence = rand(1,sz);
    %-----------------------随机序列二值化
    for i=1:sz
        if m_sequence(i)>=0.5
            m_sequence(i)=1;
        else
            m_sequence(i)=0;
        end
    end
    %-----------------------------------异或操作得到gold码
    goldcode=xor(S_mark,m_sequence); 
    %-----------------------------------还原成2维
    spread_mark = reshape(goldcode,[row,list]);

    [S_C,S_S]=wavedec2(spread_mark,level,wavelet);
    S_CA=appcoef2(S_C,S_S,wavelet,level);
    [M2,N2]=size(S_CA);
    CAmin2=min(min(S_CA));
    CAmax2=max(max(S_CA));
    S_CA=(1/(CAmax2-CAmin2))*(S_CA-CAmin2);
    d=max(size(S_CA));
    [S_U,S_sigma,S_V]=svd(S_CA);
    V2=S_V;
    U2=S_U;
    sigma_tilda=alpha*flipud(sort(rand(d,1)));
    watermark=U2*diag(sigma_tilda,0)*V2';


    %--------------------------------------------
    dataoriginal=imread(original);
    datatest=imread(test);
    dataoriginal=double(dataoriginal)/255;
    datatest=double(datatest)/65535;
    dataoriginal=dataoriginal(:,:,1);
    datatest=datatest(:,:,1);
    %提取加有水印的图像的小波低频系数
    [watermarkimagergb,watermarkimage,waterCA,watermark2,S_sigma,S_C,S_S]=wavemarksvd(original,'temp.png',seed,wavelet,level,alpha);
    %提取待测图像的小波低频系数
    [row,list]=size(datatest);
    [C,S]=wavedec2(datatest,level,wavelet);
    CA_test=appcoef2(C,S,wavelet,level);
    %提取原始图像的小波低频系数
    [C,S]=wavedec2(dataoriginal,level,wavelet);
    realCA=appcoef2(C,S,wavelet,level);
    %生成两种水印
    realwatermark=waterCA-realCA;
    testwatermark=CA_test-realCA;
    %-------------------------------------------
    [S_U,S_sigma2,S_V] = svd(testwatermark);
    S_CA2 = S_U*S_sigma*S_V';
    S_CA2=reshape(S_CA2,1,S_S(1,1)*S_S(1,2));
    S_C(1,1:S_S(1,1)*S_S(1,2))=S_CA2;
    spread_mark2 = waverec2(S_C,S_S,wavelet);
    spread_mark2 = round(abs(spread_mark2));
    goldcode2 = reshape(spread_mark2,[1,row*list]);

    [S_U3,S_sigma3,S_V3] = svd(realwatermark);
    S_CA3 = S_U3*S_sigma*S_V3';
    S_CA3=reshape(S_CA3,1,S_S(1,1)*S_S(1,2));
    S_C(1,1:S_S(1,1)*S_S(1,2))=S_CA3;
    spread_mark3 = waverec2(S_C,S_S,wavelet);
    spread_mark3 = round(abs(spread_mark3));
    goldcode3 = reshape(spread_mark3,[1,row*list]);


    %error = double(goldcode) - goldcode2;
    error = goldcode3 - goldcode2;
    correct_rate = length(find(error==0))/(384*384)
