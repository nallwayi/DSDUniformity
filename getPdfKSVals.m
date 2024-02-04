% Function to plot the PDF of KS values in the KS Matrix
%  April 06, 2022

function getPdfKSVals(ensmblKSMatrixCondConc)

ksVals = reshape(ensmblKSMatrixCondConc,1,[]);

ksVals(isnan(ksVals)) = [];
ksVals(ksVals>1) = [];

bins = -0.005:0.01:0.955;
binCntr = (bins(1:end-1)+bins(2:end))*0.5;

[counts,~] = histcounts(ksVals,bins);
PDF = counts/sum(counts); %PDF

f=figure;%('Name','ClusterPDF','units','normalized','outerposition',[0 0 1 1]);
filename = 'PdfKSVal';
%  plot(binCntr,PDF,'LineStyle','none','Color',[0 0 1],...
%         'Marker','.','MarkerSize',5);
bar(binCntr,PDF)
title('PDF of KS vals')
xlabel('KS vals')
ylabel('PDF')
% ylim([0 0.01])

% savefig([folderHeader '/' clusteringAlgo 'Results/'  filename '_' fileHeader  clstrParamsNames '.fig'])
% close(f)

end