function R = REDUCE(I,W)
	reduce_size = round(size(I,2)/2);
	R = zeros(1,reduce_size);
	for i = 1: reduce_size
		%R = W(1)*I(2i-3) + W(2)*I(2i-2) + W(3)*I(2i-1) + W(4)*I(2i) + W(5)*I(2i+1)
		for m=-2:2
			try
				R(i) += W(m+3)*I(2*i+m-1);
			catch
				%DO Nothing
			end_try_catch
		end
		R(i) = uint8(R(i));
	end 
endfunction
