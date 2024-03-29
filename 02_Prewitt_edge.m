clear

%Package 
pkg load image;

%Read Image
I = imread("images/lena.png");

%convert RGB to grayscale
G = rgb2gray(I);

%Use existing package 
J2 = edge(G,"Prewitt");

%DIY
%Smoothen w.r.t x - Average
%sx = [1;1;1];
%Take first order derivative w.r.t x and y - Central Difference
%dx = [1 0 -1];
%convolution of sx and dx
fx=[1 0 -1; 1 0 -1; 1 0 -1;];

%Smoothen w.r.t y - Average
%sy = [1 1 1];
%Take first order derivative w.r.t x and y - Central Difference
%dy = [1; 0; -1];
%convolution of sx and dx
fy=[1 1 1; 0 0 0; -1 -1 -1;];

Jx = filter2(fx,G);
Jy = filter2(fy,G);

%Mod of x and y
Jx_square = Jx.^2;
Jy_square = Jy.^2;
Jmod = round(sqrt(Jx_square+Jy_square));

%Thresholding - output to zero if less than threshold
Jth = Jmod;
Threshold=100;
Jth(Jth<=Threshold)=0;

%Plot R G B
subplot(2,2,1);
imshow(I);
title('Original RGB Image');

%Plot Grayscale
subplot(2,2,2);
imshow(G);
title('Grayscale Component');

subplot(2,2,3);
imshow(Jth);
title('Prewitt edge - DIY');

subplot(2,2,4);
imshow(J2);
title('Prewitt edge - Builtin Function');

pause;
