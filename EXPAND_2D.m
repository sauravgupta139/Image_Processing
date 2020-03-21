function J = EXPAND_2D(I)
	%Step 1. Create 1D Gaussian Mask
	a=0.375;
	g = [0.25-0.5*a,0.25,a,0.25,0.25-0.5*a];

	%Step 2. Apply 1D Convolution Mask for each col
	Row = size(I,1);
	Col = size(I,2);
	J1 = zeros(Row*2,Col);
	for i=1 : Col
		A = EXPAND(I(:,i)',g);
		J1(:,i) = A';
	end
	
	%Step 3. Apply 1D Convolution Mask for each row
	J = zeros(Row*2,Col*2);
	for i=1 : Row*2
		J(i,:) = EXPAND(J1(i,:),g);
	end
	
	%convert double to uint8
	J = uint8(J);
endfunction
