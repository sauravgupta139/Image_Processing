clear

%Package 
pkg load image;

%Read Image
I = imread("images/lena.png");

%convert RGB to grayscale
G = rgb2gray(I);

%Add Salt n Pepper Noise
NI = imnoise(G,'salt & pepper',0.1);

%Use Median Filter to filter out the noise.
K = medfilt2(NI);

%DIY - Inefficient Implementation - Algo can be optimized
[Row,Col]= size(NI);
windowWidth = 5; %should be odd
windowHeight = 5; %should be odd
windowDim = windowWidth*windowHeight;
window=zeros(windowDim);
FI = NI;
startRow = floor(windowWidth/2);
startCol = floor(windowHeight/2);
%Do raster scan for window
for r=startRow+1:Row-startRow
	for c=startCol+1:Col-startCol
		i=1;
		%Find median in the given window
		for windowH=r-startRow:r+startRow
			for windowW=c-startCol:c+startCol
				window(i) = NI(windowH,windowW);
				i+=1;
			end
		end
		window = sort(window);
		Median = window(floor(windowDim/2));
		FI(windowH,windowW) = Median; 
	end
end

%Plot 
subplot(2,2,1);
imshow(G);
title('Original Grayscale Image');

subplot(2,2,2);
imshow(NI);
title('Noise Added Image');

subplot(2,2,3);
imshow(K);
title('Median Filtered Image - Builtin');

subplot(2,2,4);
imshow(FI);
title('Median Filtered Image - DIY');

pause;
