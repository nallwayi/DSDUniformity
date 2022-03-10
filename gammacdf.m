function [scale,shape]=gammacdf(xdata,ydata,weights)



% a = 3; % Scale parameter
% b      = 3; %Shape parameter
% x = 0:0.1:10;
% CDF2 = @(x) (1- symsum(((a.*x).^k .* exp(-a.*x))/factorial(k),k,0,b-1));
% syms k
% fitCDF = @(a,b,k,x) (1- symsum(((a.*x).^k .* exp(-a.*x))/factorial(k),k,0,b-1))
fitCDF= @(iscale,shape,x) gammainc(x*iscale,shape,'lower');
% /gamma(b);
% 
% s = fitoptions('Method','NonlinearLeastSquares',...
%                'Lower',[0,0],...
%                'Upper',[Inf,Inf],...
%                'Startpoint',[1  1],...
%                'Weights',weights,...
%                'Exclude', xdata<10);
%            
s = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[0,0],...
               'Upper',[Inf,Inf],...
               'Startpoint',[0.1  0.1],...
               'Exclude', xdata < 10e-6);
f = fittype(fitCDF,'options',s);
[f,goodness] = fit(xdata, ydata, f);
coeffs = coeffvalues(f);
scale = 1/coeffs(1);
shape = coeffs(2);

% figure
% % plot(f,xdata,ydata)
% plot(f)
% hold on
% plot(xdata,ydata)
% hold off


% % Weighted least squares
% 
% modelFun = @(coeff,x) gammainc(x*coeff(1),coeff(2),'lower');
% start = [0; 0];
% wnlm = fitnlm(xdata,ydata,modelFun,start);
% % wnlm = fitnlm(xdata,ydata,modelFun,start,'Weight',weights)
% 
% % scale = wnlm.Coefficients(1,1);
% % shape = wnlm.Coefficients(2,1);
% 
% xx = (0:100)';
% plot(xdata,ydata,'k-');
% hold on
% line(xx,predict(wnlm,xx),'color','b')

end