clear

%Package 
pkg load image;

%Read Image
Ia = imread("images/apple.jpg");
Ib = imread("images/orange.jpg");

%convert RGB to grayscale
IGa = rgb2gray(Ia);
IGb = rgb2gray(Ib);

%Direct Blending
Fullsize = size(Ia,2);
Halfsize = round(Fullsize/2);
Md = [Ib(:,1:Halfsize), Ia(:,Halfsize+1:Fullsize)];

%Pad Data to make image divisible by 8
Row = size(IGa,1);
Col = size(IGa,2);
Row_extra = mod(8-mod(Row,8),8);
Col_extra = mod(8-mod(Col,8),8);
%append extra row x col to the image
for i = 1:Col_extra
	IGa = [IGa, IGa(:,Col)];
end
TMP = [];
for i = 1:Row_extra
	TMP = [TMP; IGa(Row,:)];
end
IGa = [IGa ; TMP];

Row = size(IGb,1);
Col = size(IGb,2);
Row_extra = mod(8-mod(Row,8),8);
Col_extra = mod(8-mod(Col,8),8);
%append extra row x col to the image
for i = 1:Col_extra
	IGb = [IGb, IGb(:,Col)];
end
TMP = [];
for i = 1:Row_extra
	TMP = [TMP; IGb(Row,:)];
end
IGb = [IGb ; TMP];

%Builtin Method Gaussian Pyramid
g1a = impyramid(IGa,'reduce');
g1b = impyramid(IGb,'reduce');
g2a = impyramid(g1a,'reduce');
g2b = impyramid(g1b,'reduce');
g3a = impyramid(g2a,'reduce');
g3b = impyramid(g2b,'reduce');

%Laplacian Pyramid
%Level 1
L1a = IGa - EXPAND_2D(g1a);
L1b = IGb - EXPAND_2D(g1b);
%Level 2
L2a = g1a - EXPAND_2D(g2a);
L2b = g1b - EXPAND_2D(g2b);
%Level 3
L3a = g2a - EXPAND_2D(g3a);
L3b = g2b - EXPAND_2D(g3b);
%Level 4
L4a = g3a;
L4b = g3b;

%combine L1a and L1b vertically
Fullsize=size(L1a,2);
Halfsize=round(Fullsize/2);
L1 = [L1b(:,1:Halfsize),L1a(:,Halfsize+1:Fullsize)];

%combine L2a and L2b vertically
Fullsize=size(L2a,2);
Halfsize=round(Fullsize/2);
L2 = [L2b(:,1:Halfsize),L2a(:,Halfsize+1:Fullsize)];

%combine L3a and L3b vertically
Fullsize=size(L3a,2);
Halfsize=round(Fullsize/2);
L3 = [L3b(:,1:Halfsize),L3a(:,Halfsize+1:Fullsize)];

%combine L4a and L4b vertically
Fullsize=size(L4a,2);
Halfsize=round(Fullsize/2);
L4 = [L4b(:,1:Halfsize),L4a(:,Halfsize+1:Fullsize)];

%Decoding Laplacian Pyramid
g4 = L4;
g3 = EXPAND_2D(g4) + L3;
g2 = EXPAND_2D(g3) + L2;
g1 = EXPAND_2D(g2) + L1;

%Plot 
subplot(3,2,1);
imshow(IGa);
title('Original Grayscale Image - 1');

subplot(3,2,2);
imshow(IGb);
title('Original Grayscale Image - 2');

subplot(3,2,3);
imshow(L1a);
title('Laplacian Pyramid Difference Image 1');

subplot(3,2,4);
imshow(L1b);
title('Laplacian Pyramid Difference Image 2');

subplot(3,2,5);
imshow(Md);
title('Direct Blending Image 1 and 2');

subplot(3,2,6);
imshow(g1);
title('Laplacian Pyramid Blending Image 1 and 2');


pause;
