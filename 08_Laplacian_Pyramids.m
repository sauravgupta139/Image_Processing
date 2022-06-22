clear

%Package 
pkg load image;

%Read Image
I = imread("images/lena.png");

%convert RGB to grayscale
G = rgb2gray(I);

%Use existing package to reduce
g1 = impyramid(G,"reduce");

% DIY - to expand
%Step 1. Create 1D Gaussian Mask
a=0.375;
g = [0.25-0.5*a,0.25,a,0.25,0.25-0.5*a];

%Step 2. Apply 1D Convolution Mask for each col
Row = size(g1,1);
Col = size(g1,2);
J1 = zeros(Row*2,Col);
for i=1 : Col
	A = EXPAND(g1(:,i)',g);
	J1(:,i) = A';
end

%Step 3. Apply 1D Convolution Mask for each row
J = zeros(Row*2,Col*2);
for i=1 : Row*2
	J(i,:) = EXPAND(J1(i,:),g);
end

%convert double to uint8
J=uint8(J);
L1 = G - J;

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
title('Gaussian Pyramid Reduction and then Expansion');

subplot(2,2,4);
imshow(L1);
title('Laplacian Pyramid Difference between original and Reduced-Expanded Image');


pause;
