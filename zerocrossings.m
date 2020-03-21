function z = zerocrossings(f)
	z0 = f<0;                 #Negative
	[R,C] = size(f);
	z = zeros(R,C);
	z(1:R-1,:) |= z0(2:R,:);  #Grow
	z(2:R,:)   |= z0(1:R-1,:);
	z(:,1:C-1) |= z0(:,2:C);
	z(:,2:C)   |= z0(:,1:C-1);

	z &= !z0; #Positive zero-crossing
endfunction
