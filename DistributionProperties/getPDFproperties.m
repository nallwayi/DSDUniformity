%% Functions to look at  PDF's and CDF's

%--------------------------------------------------------------------------
% Function to get the PDF properties
function [PDFStats] = getPDFproperties(prtcleDiam,cmCmp)


for cnt=1:length(cmCmp)
    diamMedn(cnt) = median(prtcleDiam(~isnan(prtcleDiam(:,cmCmp(cnt))),cmCmp(cnt)));
    diamStd(cnt)  = std(prtcleDiam(~isnan(prtcleDiam(:,cmCmp(cnt))),cmCmp(cnt)));
    diamSkw(cnt)  = skewness(prtcleDiam(~isnan(prtcleDiam(:,cmCmp(cnt))),cmCmp(cnt)));
    
    tmp = prtcleDiam(prtcleDiam(:,cmCmp(cnt))>30e-6,cmCmp(cnt));
    lwc(cnt) = 997e3*4/3*pi*sum(tmp.^3)/8/11.2700*1e6;
    
end

% PDF of the liquid water content
[lwcHist,lwcedges] = histcounts(lwc,0:0.01:0.6);
PDF_LWC = lwcHist/sum(lwcHist);
sum(PDF_LWC)

% PDF of the Skewness
[skwHist,skwedges] = histcounts(diamSkw,0:0.5:10);
PDF_Skw = skwHist/sum(skwHist);
% sum(skwHist/length(cmCmp))
sum(PDF_Skw)

PDFStats.diamMedn  = diamMedn;
PDFStats.diamStd   = diamStd;
PDFStats.diamSkw   = diamSkw;
PDFStats.lwc       = lwc;

PDFStats.PDF_LWC_edges  = lwcedges;
PDFStats.PDF_LWC_val    = PDF_LWC;

PDFStats.PDF_Skw_edges  = skwedges;
PDFStats.PDF_Skw_val    = PDF_Skw;

end
%--------------------------------------------------------------------------