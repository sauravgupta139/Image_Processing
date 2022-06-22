clear

%Package 
pkg load image;

%Read Image
I = imread("images/chess.jpg");

%convert RGB to grayscale
G = rgb2gray(I);

%DIY
%Step 1. Take first order derivative - Central Difference
%fx=1/3*[-1 0 1; -1 0 1; -1 0 1;];
%fy=1/3*[-1 -1 -1; 0 0 0; 1 1 1;];
%Ix = conv2(G,fx,"same");
%Iy = conv2(G,fy,"same");
[Ix,Iy] = gradient(G);

%Calculate Elements of M
Jx_square = Ix.^2;
Jy_square = Iy.^2;
Jxy = Ix.*Iy;

%Step 2. Do Gausssian smoothening
sigma=1;
gs = fspecial('gaussian',6*sigma+1,sigma); % size of window = 6*sigma
%Jx_square = filter2(gs,Jx_square");
%Jy_square = filter2(gs,Jy_square");
Jx_square = conv2(Jx_square,gs,"same");
Jy_square = conv2(Jy_square,gs,"same");
Jxy = filter2(gs,Jxy);

% Compute determinant and trace of M; and cornerness measure R
k=0.05;
detM = Jx_square.*Jy_square-Jxy.^2;
traceM = Jx_square + Jy_square;
R1 = detM - k*(traceM).^2;

%R - determinant
R2 = detM;%\traceM;

%Threshold --> R > Rmin 
Rmin1 = 100;
Corner1=R1;
Corner1(Corner1<=Rmin1)=0;

Rmin2=200;
Corner2=R2;
Corner2(Corner2<=Rmin2)=0;

%Plot R G B
subplot(3,2,1);
imshow(I);
title('Original RGB Image');

%Plot Grayscale
subplot(3,2,2);
imshow(G);
title('Grayscale Component');

subplot(3,2,3);
imshow(Ix);
title('Derivative along x ');

subplot(3,2,4);
imshow(Iy);
title('Derivative along y ');

subplot(3,2,5);
imshow(Corner1);
title('HCD - Default');

subplot(3,2,6);
imshow(Corner2);
title('HCD - Determinant ');

%imwrite(Corner1,"Chess_Corner_HCD.jpg");
%imwrite(Corner2,"Chess_Corner_Det.jpg");

pause;
