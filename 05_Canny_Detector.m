clear

%Package 
pkg load image;

%Read Image
I = imread("lena.png");

%convert RGB to grayscale
G = rgb2gray(I);

%Use existing package. Ready made function - threshold 0.75 * Mean of absolute value of LoG filter response, sigma 2 
J2 = edge(G,"Canny");

%DIY
%Step 1. Sobel Filter Smoothening 
fx=[1 0 -1;2 0 -2;1 0 -1];
fy=[1 2 1;0 0 0;-1 -2 -1];
Gx = conv2(G,fx,"same");
Gy = conv2(G,fy,"same");

%Step 2. Find Magnitude
Gmag = round(sqrt(Gx.^2+Gy.^2));
Gmax = max(Gmag(:)); %find max
Gmag ./= Gmax; %normalize w.r.t max
%angle
Gtheta = pi - mod(atan2(Gy,Gx)-pi,pi);

%Step 3 and 4. Nonmax Supression and Hysterisis thresholding
ThresholdLow=0.7*mean(abs(Gmag(:)));
ThresholdHigh = mean(abs(Gmag(:)));
J1 = nonmax_supress(Gmag,Gtheta,ThresholdLow,ThresholdHigh); %builtin function in octave 

%Plot R G B
subplot(2,2,1);
imshow(I);
title('Original RGB Image');

%Plot Grayscale
subplot(2,2,2);
imshow(G);
title('Grayscale Component');

%Plot edge x
subplot(2,2,3);
imshow(J1);
title('Edges using Canny - DIY');

%Plot egde y
subplot(2,2,4);
imshow(J2);
title('Edges using Canny -Builtin Function');

