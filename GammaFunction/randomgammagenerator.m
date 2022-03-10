function [diam,cdf] = randomgammagenerator(shape,scale)

 x = gamrnd(shape,scale,1,1e6);
%  p = gamcdf(x,shape,scale);
[cdf,diam] = ecdf(x);
 plot(diam,cdf)
end