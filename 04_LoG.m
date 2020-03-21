clear

%Package 
pkg load image;

%Read Image
I = imread("lena.png");

%convert RGB to grayscale
G = rgb2gray(I);

%Use existing package. Ready made function - threshold 0.75 * Mean of absolute value of LoG filter response, sigma 2 
J2 = edge(G,"LoG");

%DIY
%Step 1. Create laplacian of gaussian filter with sigma =2, Matrix Size = 6*sigma+1 to cover 99.7%
g = fspecial('log',13,2);

%Step 2. Apply the filter
J = conv2(G,g,"same");

%Step 3. Zero Crossing Points
z = zerocrossings(J);

%Step 4. Thresholding - output to zero if less than threshold
Threshold=0.7*mean(abs(J(:)));
a = abs(J) > Threshold;
J1 = a&z;

%Plot R G B
subplot(2,2,1);
imshow(I);
title('Original RGB Image');

%Plot Grayscale
subplot(2,2,2);
imshow(G);
title('Grayscale Component');

subplot(2,2,3);
imshow(J1);
title('Edges using LoG - DIY');

subplot(2,2,4);
imshow(J2);
title('Edges using LoG -Builtin Function');

