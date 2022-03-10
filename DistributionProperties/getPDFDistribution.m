% -------------------------------------------------------------------------
% 07.26.2021
% Modified on Sept 09, 2021 - Bug fix related to the normalization of the
% PDF- Check again
% Modified on Dec 10, 2021- Bud fix related to PDF. Always the area under a
% PDF should be one

% Function to get the PDF of the distribution 
% It can have equally space bins or log bins
function [binCntr,PDF] = getPDFDistribution(prtcleDiamArry,type)


% Conversion to micro meter and removing nan values
prtcleDiamArry = prtcleDiamArry(~isnan(prtcleDiamArry));
prtcleDiamArry  = prtcleDiamArry  *1e6;
prtcleDiamArry  = prtcleDiamArry(prtcleDiamArry>10);

if strcmp(type,'log')
    prtcleDiamArry = log(prtcleDiamArry);
    llim = 0;
    ulim = 4.1;%5.3; % Corresponding to 200 microns
    binwdth = 0.1;    
else
    llim = 0;
    ulim = 60;%200; %  200 microns
    binwdth = 3;
end


edges = llim:binwdth:ulim;



dNdX =zeros(length(edges)-1,1);
for cnt=1:length(edges)-1
    binwdth(cnt) = (edges(cnt+1)-edges(cnt));
    dNdX(cnt) = sum(prtcleDiamArry>=edges(cnt) & prtcleDiamArry <edges(cnt+1))...
         /binwdth(cnt);
%     nFac(cnt) = sum(prtcleDiamArry>=edges(cnt) & prtcleDiamArry <edges(cnt+1)) * binwdth(cnt);
end



if strcmp(type,'log')
    edges  = exp(edges);
end
binCntr =( edges(2:end) + edges(1:end-1)) * 0.5;

% Normalization
% dNdX  = dNdX /sum(nFac);
PDF  = dNdX / sum(prtcleDiamArry >= llim & prtcleDiamArry <= ulim);
% stairs((binCntr),dNdX)
% sum(dNdX)
if sum(PDF.*binwdth') <0.9999999999 & sum(PDF.*binwdth') >1.000000001 
    kk=sum(PDF.*binwdth');
    error('Area under PDF is not one')
end
end

% -------------------------------------------------------------------------