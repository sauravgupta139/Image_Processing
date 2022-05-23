%Load image
Im = imread('apple.jpg');

%Translation, x' = [I t] x
I = eye(2); %2x2 identity matrix
t = [30; 40];
[Row,Col,ch] = size(Im);
Im_trans = zeros(Row+t(1),Col+t(2),3);
for k=1:ch
	for i=1:Row
    for j=1:Col
		  x = [i;j;1];
		  x_prime = [I t] * x;
		  row_prime = x_prime(1);
	    col_prime = x_prime(2);	
		  Im_trans(row_prime,col_prime,k) = Im(i,j,k);
	  end
  end
end

%Rotation + Translation, x= Rx + t
theta = 45 * pi/180;
R = [cos(theta), -sin(theta); ...
      sin(theta), cos(theta)];
Im_rot = zeros(Row+t(1),Col+t(2),3);
for k=1:ch
	for i=1:Row
    for j=1:Col
		  x = [i;j;1];
		  x_prime = round([R t] * x);
		  if (x_prime(1) <= 0)
        row_prime = 1;
      else
        row_prime = x_prime(1);
	    end
      if (x_prime(2) <= 0)
        col_prime = 1;	
		  else
        col_prime = x_prime(2);	
      end
      Im_rot(row_prime,col_prime,k) = Im(i,j,k);
	  end
  end
end

%Scaled Rotation + Translation, x= sRx + t
theta = 45 * pi/180;
R = 2*[cos(theta), -sin(theta); ...
      sin(theta), cos(theta)];
Im_srot = zeros(Row+t(1),Col+t(2),3);
for k=1:ch
	for i=1:Row
    for j=1:Col
		  x = [i;j;1];
		  x_prime = round([R t] * x);
		  if (x_prime(1) <= 0)
        row_prime = 1;
      else
        row_prime = x_prime(1);
	    end
      if (x_prime(2) <= 0)
        col_prime = 1;	
		  else
        col_prime = x_prime(2);	
      end
		  Im_srot(row_prime,col_prime,k) = Im(i,j,k);
	  end
  end
end

%Affine Transformation, x= Ax
%shear
%A = [1, 0.5, 0; ...
%     0, 1, 0];
%stretch horizontally
%A = [1, 0, 0; ...
%     0, 2, 0];  
%stretch vertically
A = [2, 0, 0; ...
     0, 1, 0];
Im_affine = zeros(Row,Col,3);
for k=1:ch
	for i=1:Row
    for j=1:Col
		  x = [i;j;1];
		  x_prime = A * x;
		  if (x_prime(1) <= 0)
        row_prime = 1;
      else
        row_prime = x_prime(1);
	    end
      if (x_prime(2) <= 0)
        col_prime = 1;
		  else
        col_prime = x_prime(2);
      end
		  Im_affine(row_prime,col_prime,k) = Im(i,j,k);
	  end
  end
end

%Projective Transformation, x= Hx
H = [2, 0, -3; ...
     0, 2, -3; ...
     0, 0,  1];
Im_projective = zeros(Row,Col,3);
for k=1:ch
	for i=1:Row
    for j=1:Col
		  x = [i;j;1];
		  x_prime = H * x;
		  if (x_prime(1) <= 0)
        row_prime = 1;
      else
        row_prime = round(x_prime(1)/x_prime(3));
	    end
      if (x_prime(2) <= 0)
        col_prime = 1;
		  else
        col_prime = round(x_prime(2)/x_prime(3));
      end
		  Im_projective(row_prime,col_prime,k) = Im(i,j,k);
	  end
  end
end

%Show image
Im_trans = uint8(Im_trans);
Im_rot = uint8(Im_rot);
Im_srot = uint8(Im_srot);
Im_affine = uint8(Im_affine);
Im_projective = uint8(Im_projective);

subplot(2,3,1);
imshow(Im);
subplot(2,3,2);
imshow(Im_trans);
subplot(2,3,3);
imshow(Im_rot);
subplot(2,3,4);
imshow(Im_srot);
subplot(2,3,5);
imshow(Im_affine);
subplot(2,3,6);
imshow(Im_projective);