clear

%Package 
pkg load image;

%Read Image
%I = imread("images/sunflower.jpg");
I = imread("images/sky.jpg");
%I = imread("images/eiffel.jpg");

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

%Step 2. Apply the gaussian filters to the image
J1 = conv2(G,g1,"same");
J2 = conv2(G,g2,"same");
J3 = conv2(G,g3,"same");
J4 = conv2(G,g4,"same");

%Step3. Take DoG
DoG1 = J2-J1;
DoG2 = J3-J2;
DoG3 = J4-J3;

% Step 4. Find Local Extrema in 3x3x3 Grid - Maxima --> dark blob in white background, Minima --> White blob in dark background
% Remove Low Contrast KeyPoints
% Remove Edges using Hessian Matrix
[row,col] = size(DoG1);
KeyPoints_r = [];
KeyPoints_c = [];
Threshold = 7.68;
r = 10;
ThresholdCurv = (r+1)^2/r;
kernel_size=[3,3]; %3x3 pick odd numbers only
extragap = 16;
startrow = floor(kernel_size(1)/2) + extragap;
startcol = floor(kernel_size(2)/2) + extragap;
for i = 1+startrow: row-startrow
	for j= 1+startcol:col-startcol
		a = [ DoG1(i-1,j-1),DoG1(i-1,j),DoG1(i-1,j+1),...
		       DoG1(i,j-1),  DoG1(i,j),  DoG1(i,j+1),...
			   DoG1(i+1,j-1),DoG1(i+1,j),DoG1(i+1,j+1),... 
		       DoG2(i-1,j-1),DoG2(i-1,j),DoG2(i-1,j+1),...
		       DoG2(i,j-1),              DoG2(i,j+1),...
			   DoG2(i+1,j-1),DoG2(i+1,j),DoG2(i+1,j+1),...
		       DoG3(i-1,j-1),DoG3(i-1,j),DoG3(i-1,j+1),...
		       DoG3(i,j-1),  DoG3(i,j),  DoG3(i,j+1),...
			   DoG3(i+1,j-1),DoG3(i+1,j),DoG3(i+1,j+1) ];
		maxm = max(a);
		minm = min(a);
		if(DoG2(i,j) > maxm || DoG2(i,j) < minm)
			if(abs(DoG2(i,j)) > Threshold) %Contrast Thresholding
				%Build Hessian Matrix and remove edges
				Dxx = DoG2(i,j-1) + DoG2(i,j+1) - 2*DoG2(i,j);
				Dyy = DoG2(i-1,j) + DoG2(i+1,j) - 2*DoG2(i,j);
				Dxy = DoG2(i-1,j-1) + DoG2(i+1,j+1) - 2*DoG2(i+1,j-1) - 2*DoG2(i-1,j+1);
				Det = Dxx*Dyy - Dxy^2; 
				Trace = Dxx+Dyy;
				Curvature = Trace^2 / Det;
				if (Curvature < ThresholdCurv)
					KeyPoints_r = [KeyPoints_r i];
					KeyPoints_c = [KeyPoints_c j];
				end
			end
		end
	end
end

ImageWithKeyPoints = G;
for i = 1 : length(KeyPoints_r)
	circle = [KeyPoints_r(i) KeyPoints_c(i) round(6*k*sigma+1)];
	ImageWithKeyPoints = insertCircle(ImageWithKeyPoints,circle);
end

%Step 5. Sub Pixel Localization

%Step 6. Orientation Assignment
%sigma1 = k*sigma * 1.5;
%gauss = fspecial('gaussian',round(6*sigma1+1),sigma1);
%SD = round(3*sigma1);
%L = conv2(G,gauss,"same");
%L=uint8(L);
%[mag,dir] = imgradient(L);
%Bins=zeros(1,36); % 36 bins of 10 degrees
%for i = 1: length(KeyPoints_r)
%	row = KeyPoints_r(i);
%	col = KeyPoints_c(i);
%	for l = row-SD : row+SD
%		for m = col-SD : col+SD
%			orientation = dir(l,m);
%			if (orientation < 0)
%				orientation += 360;
%			end
%			bin = floor(orientation/10)+1;
%			Hist += Hist + mag(l,m);
%		end
%	end 	
%end

%Plot R G B
%subplot(3,2,1);
%imshow(G);
%title('Original Grayscale Image');
%
%subplot(3,2,2);
%imshow(DoG1);
%title('DoG Filtered Image scale1');
%
%subplot(3,2,3);
%imshow(DoG2);
%title('DoG Filtered Image scale2');
%
%subplot(3,2,4);
%imshow(DoG3);
%title('DoG Filtered Image scale3');
%
%subplot(3,2,5);
imshow(ImageWithKeyPoints);
title('DoG Filtered after thresholding Image scale1');

%subplot(3,2,6);
%imshow(Corner1);
%title('DoG Filtered after thresholding Image scale2');

pause;
