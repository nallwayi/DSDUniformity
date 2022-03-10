
%% Functions to look at  PDF's and CDF's
%--------------------------------------------------------------------------
% Creating CDFs for visual comparison 
function []=compareDist(prtcleDiam,cmCmp,lgndName)

figure('Name',['CDF comparison' lgndName]);
title('Compare CDFs of distribution')
xlabel('diameter')
ylabel('CDF')
for cnt=1:length(cmCmp)
    tmp = prtcleDiam(~isnan(prtcleDiam(:,cmCmp(cnt))),cmCmp(cnt))-...
        median(prtcleDiam(~isnan(prtcleDiam(:,cmCmp(cnt))),cmCmp(cnt)));
    [Fx,x] = ecdf(tmp);
    plot(x,Fx,'DisplayName',lgndName)
    hold on

end

figure('Name',['PDF comparison' lgndName]);
title('Compare PDFs of distribution(log bin)')
xlabel('diameter')
ylabel('PDF')
for cnt=1:length(cmCmp)
    pdfinfo = pdfgenerator(prtcleDiam(:,cmCmp(cnt)));
    stairs(pdfinfo.bindiam,pdfinfo.pdf,'DisplayName',lgndName)
    hold on

end

end
%--------------------------------------------------------------------------