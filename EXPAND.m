function R = EXPAND(I,W)
	expand_size = size(I,2)*2;
	R = zeros(1,expand_size);
	for i = 1: expand_size
		%R(i) = W(1)*I((i-1)/2) + W(3)*I((i+1)/2)+ W(5)*I((i+3)/2)
		%R(i) =  W(2)*I(i/2) + W(4)*I((i+2)/2)
		if mod(i,2)==0
			for m=1:2
				try
					R(i) += W(2*m)*I((i+2*m-2)/2);
				catch
					%DO Nothing
				end_try_catch
			end
		else
			for m=1:3
				try
					R(i) += W(2*m-1)*I((i+2*m-3)/2);
				catch
					%DO Nothing
				end_try_catch
      end
		end
		R(i) = 2*uint8(R(i));
	end 
endfunction
