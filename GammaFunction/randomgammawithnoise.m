function [cdf,diam] =randomgammawithnoise()
 
 shape = 37.24;
 scale = 0.5733;
 xdata = gamrnd(shape,scale,1,1e6);
 histgen(xdata)
 noise = normrnd(0,2,[1,1e6]);
 xdata = xdata+noise;
%  xdata(xdata>100) = [];
 xdata(xdata<10) = [];
 histgen(xdata)
 [cdf,diam] = ecdf(xdata);
 
 
 
end