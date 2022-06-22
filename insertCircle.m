function out_image = insertCircle(Image,circle)
	out_image = Image;
	x0 = circle(1);
	y0 = circle(2);
	r = circle(3);
	out_image(x0,y0) = 0;
	for theta = 0 : pi/16 :2*pi 
		x = round(x0 + r*cos(theta));
		y = round(y0 + r*sin(theta));
		out_image(x,y) = 255;
	end 
end
