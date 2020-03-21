clear

%Package 
pkg load image;

%Read Image
I = imread("lena.png");

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

%Plot R G B
subplot(2,2,1);
imshow(G);
title('Grayscale Component');

%Plot Grayscale
subplot(2,2,2);
imshow(J2);
title('Prewitt edge - Builtin Function');

%Plot edge x
subplot(2,2,3);
imshow(Jx);
title('Prewitt edge - Edge at x direction - DIY');

%Plot egde y
subplot(2,2,4);
imshow(Jy);
title('Prewitt edge - Edge at y direction - DIY');

