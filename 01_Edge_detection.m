clear

%Read Image
I = imread("lena.png");

%Package 
pkg load image;

%convert RGB to grayscale
G = rgb2gray(I);

%Take first order derivative w.r.t x and y - Central Difference
fx=[-1 0 1];
fy=[-1; 0; 1];
%Backward Difference
%fx = [-1 1];
%fy = [-1;1];

%Forward Difference
%fx = [1 -1];
%fy = [1;-1];

J1 = filter2(fx,G);
J2 = filter2(fy,G);

%Plot R G B
subplot(2,2,1);
imshow(I);
title('RGB Component');

%Plot Grayscale
subplot(2,2,2);
imshow(G);
title('Grayscale Component');

%Plot edge x
subplot(2,2,3);
imshow(J1);
title('Edge at x direction');

%Plot egde y
subplot(2,2,4);
imshow(J2);
title('Edge at y direction');

