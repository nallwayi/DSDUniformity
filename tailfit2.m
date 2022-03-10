
function [m,c] = tailfit2(pd)

[x,y]=histgen(pd,200);
y = log(y);
    x = x(~isinf(y));
    y = y(~isinf(y));
    
    fitCDF= @(m,c,x) m*x.^2+c;
    s = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[-Inf,-Inf],...
               'Upper',[Inf,Inf],...
               'Startpoint',[1  1],...
               'Exclude', x<40 | x > 150);
f = fittype(fitCDF,'options',s);
[fit1,gof,fitinfo] = fit(x(:),y(:),f);
   
    fit1.m
    figure(15)    
    plot(x,(y))
    hold on
    plot(x,(fit1.m*x.^2)+(fit1.c),'r-.');  
    hold on
%     hold on
%     plot(x,log(exp(P(2))*exp(-m*x)),'r')    
%     hold off

end