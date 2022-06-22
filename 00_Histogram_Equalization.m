clear

%Package 
pkg load image;

%Read Image
I = imread("images/lena.png");

%convert RGB to grayscale
G = rgb2gray(I);

%Built in function
I_builtin = histeq(G);

%DIY
%Step 1. Get the histogram of original image
hist_before = imhist(G);

%Step 2. Calculate Cumulative Distribution function of Original Image
[Row,Col] = size(G);
N= Row*Col;
sum = 0.0;
for i=1 : size(hist_before,1)
	sum += hist_before(i)*1.0/N;
	CDF_before(i) = sum;
end

%Step 3.
I_equalized = zeros(Row,Col);
no_of_bins = 255;
for i=1 : Row
	for j=1:Col
		I_equalized(i,j) = uint8(CDF_before(G(i,j))*no_of_bins);
	end
end

%convert matrxix to uint8 for display
I_equal = uint8(I_equalized);

hist_after = hist(reshape(I_equalized,[],1),256)';

%Step 2. Calculate Cumulative Distribution function of Histogram Equalized Image
sum = 0.0;
for i=1 : size(hist_after,1)
	sum += hist_after(i)*1.0/N;
	CDF_after(i) = sum;
end

%Plot 
subplot(3,3,1);
imshow(G);
title('Original Grayscale Image');

subplot(3,3,2);
imhist(G);
title('Histogram of Grayscale Image');

subplot(3,3,3);
plot(CDF_before);
title('Original Image CDF');

subplot(3,3,4);
imshow(I_builtin);
title('After Histogram Equalization - Image (Builtin Method)');

subplot(3,3,5);
imhist(I_builtin);
title('After Histogram Equalization - Histogram (Builtin Method)');

subplot(3,3,6);
plot(CDF_after);
title('After Histogram Equalization - CDF');

subplot(3,3,7);
imshow(I_equal);
title('After Histogram Equalization - Image (DIY)');

subplot(3,3,8);
imhist(I_equal);
title('After Histogram Equalization - Histogram (DIY)');

subplot(3,3,9);
plot(CDF_after);
title('After Histogram Equalization - CDF');

pause;

