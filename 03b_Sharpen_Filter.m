clear

%Read Image
I = imread("images/lena.png");

%Package 
pkg load image;

%convert RGB to grayscale
G = rgb2gray(I);

%Take Sharpen Filter
f=[-0.5 -1 -0.5; -1 7 -1; -0.5 -1 -0.5;];

%Apply Sharpen Filter to Gray Scale
S = conv2(G,f,"same");
S = uint8(S);

%Apply Sharpen Filter to RGB Image
SR = conv2(I(:,:,1),f,"same");
SG = conv2(I(:,:,2),f,"same");
SB = conv2(I(:,:,3),f,"same");
SR = uint8(SR);
SG = uint8(SG);
SB = uint8(SB);
Row = size(G,1);
Col = size(G,2);
SRGB = zeros(Row,Col,3);
SRGB(:,:,1) = SR;
SRGB(:,:,2) = SG;
SRGB(:,:,3) = SB;
SRGB= uint8(SRGB);

%Plot R G B
subplot(2,2,1);
imshow(I);
title('Original RGB Image');

%Plot Grayscale
subplot(2,2,2);
imshow(G);
title('Grayscale Component');

%Plot Sharpened GrayScale Image
subplot(2,2,3);
imshow(S);
title('Sharpened GrayScale Image');

%Plot Sharpened Color Image
subplot(2,2,4);
imshow(SRGB);
title('Sharpened Color Image');

pause;
