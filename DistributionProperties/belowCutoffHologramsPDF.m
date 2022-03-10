% -------------------------------------------------------------------------
% Function to plot the PDFs of the hologram below the cutoff
%  Oct 8, 2021
function belowCutoffHologramsPDF(prtcleDiam,belowCutoffHolograms,plotTitle,cluster)


f=figure('Name','ClusterPDF','units','normalized','outerposition',[0 0 1 1]);
filename = ['PDFHologramsbwCutoff_' plotTitle '_eps_ ' ...
    num2str(cluster.eps) '_minpnts_'  num2str(cluster.minPoints)];
for cnt =1:numel(belowCutoffHolograms)
    [binCntr,PDF] = ...
        getPDFDistribution(prtcleDiam(:,belowCutoffHolograms(cnt)),'log');
    plot(binCntr,PDF,'b')
    hold on
end
hold off
title('PDF of holograms below the cutoff')
xlabel('Diameter (\mum)')
ylabel('PDF')
legend(['# holograms -' num2str(numel(belowCutoffHolograms))])
prefix = pwd;
mkdir([prefix '\DBSCANResults\' plotTitle '\'])
savefig([prefix '\DBSCANResults\'  plotTitle '\' filename '.fig'])
close(f)
end