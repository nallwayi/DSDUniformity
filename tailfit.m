
function [m,c]=tailfit(pd,k)
% dataflag = 'random'; 
dataflag = 'holodec'; 

method = 'pdf';
method = 'cdf';


if strcmp(dataflag,'random')
%     xdata = exprnd(6,1e7,1);  
    shape = 37.24;
    scale = 0.5733;
    xdata = gamrnd(shape,scale,1,3e6);
    xdata(xdata<10) = [];
    xdata(xdata>250) = [];
else
%     load('particledata.mat')
%     xdata= particledata.majsiz*1e6;
%     xdata = pd.majsiz*1e6;
    xdata = pd;
%     xdata(xdata<10) = [];
%     xdata(xdata>250) = [];

end




if strcmp(method,'cdf')
%     [cdf,diam] = ecdf(r);
    [ydata,xdata] = ecdf(xdata);
    x = xdata;
    y = ydata;
    y(x<40 | x>100 ) = [];
    x(x<40 | x>100 ) = [];
    ydata = log(ydata-1);
    y = log(y-1);
    
elseif strcmp(method,'pdf')
    [xdata,ydata]=histgen(xdata,100);
    x = xdata;
    y = ydata;
    ydata= log(ydata);
    
    y(x<40 | x>80 ) = [];
    x(x<40 | x>80 ) = [];
    y = log(y);
end
    

    
%     y = log(y);
    x = x(~isinf(y));
    y = y(~isinf(y));
    P = polyfit(x,y,1);
    yfit = P(1)*x+P(2);
    figure(k)
    plot(xdata,ydata)
    hold on
    plot(x,yfit,'r-.');

    
    
    
    fitCDF= @(m,c,x) m*x+c;
    s = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[-Inf,-Inf],...
               'Upper',[Inf,Inf],...
               'Startpoint',[1  1],...
               'Exclude', x<40 | x> 80);

%     s = fitoptions('Method','NonlinearLeastSquares',...
%                'Lower',-Inf,...
%                'Upper',Inf,...
%                'Startpoint',1,...
%                'Exclude', x<40 | x> 80);

f = fittype(fitCDF,'options',s);
[fit1,gof,fitinfo] = fit(x(:),y(:),f);

%     figure(5)
%     hold on
%     plot(xdata,fit1.m*xdata,'r')
%     plottools
%     
    m = [fit1.m;P(1)];
    c = [fit1.c;P(2)];
%     figure(6)
%     plot(xdata,exp(ydata))   
%     hold on
%     plot(xdata,exp(fit1.m*xdata),'r')
%     hold on
%     plot(xdata,-fit1.m*exp(fit1.m*xdata),'r')    
%     hold off

end