clear

%Package 
pkg load image;

%Read Image
I = imread("images/lena.png");

%convert RGB to grayscale
G = rgb2gray(I);

%Use existing package. Ready made function - threshold 0.75 * Mean of absolute value of LoG filter response, sigma 2 
J2 = impyramid(G,"reduce");

%DIY
%Step 1. Create 1D Gaussian Mask
a=0.375;
g = [0.25-0.5*a,0.25,a,0.25,0.25-0.5*a];

%Step 2. Apply 1D Convolution Mask for each row
Row = size(G,1);
Col = size(G,2);
J1 = zeros(Row,round(Col/2));
for i=1 : Row
	J1(i,:) = REDUCE(G(i,:),g);
end

%Step 3. Apply 1D Convolution Mask for each col
J = zeros(round(Row/2),round(Col/2));
for i=1 : round(Col/2)
	A = REDUCE(J1(:,i)',g);
	J(:,i) = A';
end

%convert double to uint8
J=uint8(J);

%Print entropy
entropy(G);

%Plot 
subplot(2,2,1);
imshow(G);
title('Original Grayscale Image');

subplot(2,2,2);
imhist(G);
title('Histogram of Grayscale Image');

subplot(2,2,3);
imshow(J);
title('Gaussian Pyramid Compression - DIY');

subplot(2,2,4);
imshow(J2);
title('Gaussian Pyramid Compression -Builtin Function');


pause;
