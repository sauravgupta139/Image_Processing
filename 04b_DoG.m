clear

%Package 
pkg load image;

%Read Image
I = imread("images/zebra.jpg");

%convert RGB to grayscale
G = rgb2gray(I);

%DIY
%Step 1. Do gaussian filtering at different values of sigma
sigma=1.6;
k = sqrt(2);
g1 = fspecial('gaussian',round(6*sigma+1),sigma);
g2 = fspecial('gaussian',round(6*k*sigma+1),k*sigma);
g3 = fspecial('gaussian',round(6*k^2*sigma+1),k^2*sigma);
g4 = fspecial('gaussian',round(6*k^3*sigma+1),k^3*sigma);

%Step 2. Apply the filter
J1 = conv2(G,g1,"same");
J2 = conv2(G,g2,"same");
J3 = conv2(G,g3,"same");
J4 = conv2(G,g4,"same");

%Step 3. Take DoG
DoG1 = J2-J1;
DoG2 = J3-J2;
DoG3 = J4-J3;
%surf(g)

%Step 4. Zero Crossing Points
z = zerocrossings(DoG1);

%Step 5. Thresholding - output to zero if less than threshold
Threshold=0.75*mean(abs(DoG1(:)));
a = abs(DoG1) > Threshold;
T = a&z;

%Plot R G B
subplot(3,2,1);
imshow(I);
title('Original RGB Image');

subplot(3,2,2);
imshow(DoG1);
title('DoG Filtered Image scale1');

subplot(3,2,3);
imshow(DoG2);
title('DoG Filtered Image scale2');

subplot(3,2,4);
imshow(DoG3);
title('DoG Filtered Image scale3');

%Plot Grayscale
subplot(3,2,5);
imshow(z);
title('Edges using DoG1 - w/o Threshold');

subplot(3,2,6);
imshow(T);
title('Edges using DoG1 - After Thresholding');

%subplot(3,2,4);
%surf(DoG);
%title('DoG Filter');


pause;
