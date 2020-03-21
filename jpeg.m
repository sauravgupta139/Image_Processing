clear

%Install Package from here - https://octave.sourceforge.io/
pkg load image;
pkg load signal;

%Load Image
I = imread("lena.png");

%RGB to YCbCr
Y = rgb2ycbcr(I);

%Downsampling Cb Cr
Y_d = Y;
Y_d(:,:,2) = 2*round(Y_d(:,:,2)/2);
Y_d(:,:,3) = 2*round(Y_d(:,:,3)/2);

%2D Dicrete Cosine Transform

%8x8 Quantization Table
p =1; %Knob - lossy factor
Q= p*[16 11 10 16 24 40 51 61; ...
      12 12 14 19 26 28 60 55; ...
      14 13 16 24 40 57 69 56; ...
      14 17 22 29 51 87 80 62; ...
      18 22 37 56 68 109 103 77; ...
      24 35 55 64 81 104 113 92; ...
      49 64 78 87 103 121 120 101; ...
      72 92 95 98 112 100 103 99];


%PAD Imaage to make it multiple of 8x8 if required'
Row = size(Y_d,1);
Col = size(Y_d,2);
M = mod(8-mod(Row,8),8);
N = mod(8-mod(Col,8),8);
Y_d = padarray(Y_d,[M,N],0,'post');

%DCT Compress
for coloryuv=1:3 %for each Y Cb Cr
	for j=1:8:size(Y_d,2)-7
		for k=1:8:size(Y_d,2)
			Y_tmp = Y_d(j:j+7,k:k+7,coloryuv); %split image in units of 8x8
			freq = dct2(Y_tmp); %2D DCT
			Compressed = round(freq./Q); %Quantized Data
			freq1 = Q.* Compressed; %UnQuantized
			Uncompressed(j:j+7,k:k+7,coloryuv) = idct2(freq1);
		end
	end
end

I_Retrieved = ycbcr2rgb(uint8(Uncompressed));

%Plot R G B
subplot(2,2,1);
imshow(I);
title('RGB Component');

%Plot Y Cb Cr
subplot(2,2,2);
imshow(Y);
title('Y Cb Cr Component');

%Plot Y Cb Cr
subplot(2,2,3);
imshow(Y_d);
title('Cb Cr Compressed by factor of 2');

%Plot R G B
subplot(2,2,4);
imshow(I_Retrieved);
title('Retrieved JPEG image');

imwrite(I_Retrieved,"lena_compressed.jpg");
