clear

%Package 
pkg load image;

%Read Image
I = imread("blurry.jpeg");

%convert RGB to grayscale
%G = rgb2gray(I);

%Contrast Enhancement
minima=min(min(I));
maxima=max(max(I));
Scale = 256/double(maxima-minima+1);
G = (I-minima)*Scale;

%First Cut solution - Manual Threshold.
%Find Better ways of finding Thresold Automatically based on image
B= G;
Threshold = 160;
B(B<Threshold) = 0;
B(B>=Threshold) = 255;
B=uint8(B);

%DIY
%Step 1. Get the histogram of original image
hist = imhist(G);

%Plot 
subplot(3,2,1);
imshow(I);
title('Original Grayscale Image');

subplot(3,2,2);
imhist(I);
title('Histogram of Grayscale Image');

subplot(3,2,3);
imshow(G);
title('Histogram of Grayscale Image');

subplot(3,2,4);
imhist(G);
title('Histogram of Contrast Enhance Grayscale Image');

subplot(3,2,5);
imshow(B);
title('Binarized Image');

pause;

