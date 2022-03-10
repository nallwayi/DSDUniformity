%% Functions to look at  PDF's and CDF's

%--------------------------------------------------------------------------
% Function to plot the generated PDF properties
function plotPDFproperties(KSPassPDFStats,KSFailPDFStats)


figure('Name','Median_Std');
scatter(KSPassPDFStats.diamMedn,KSPassPDFStats.diamStd,'filled','MarkerFaceAlpha',1)
hold on
scatter(KSFailPDFStats.diamMedn,KSFailPDFStats.diamStd,'filled','MarkerFaceAlpha',1)
hold off
title('Median vs Std  of the PDFs')
xlabel('Median')
ylabel('Standard deviation')
legend('KSPass','KSFail')
plottools

figure('Name','Median_lwc');
scatter(KSPassPDFStats.diamMedn*1e6,KSPassPDFStats.lwc,'filled','MarkerFaceAlpha',1)
hold on
scatter(KSFailPDFStats.diamMedn*1e6,KSFailPDFStats.lwc,'filled','MarkerFaceAlpha',1)
hold off
title('Median vs lwc  of the PDFs')
xlabel('Median (\mum)')
ylabel('lwc (g/m^3)')
legend('KSPass','KSFail')
plottools

figure('Name','Median_Skewness');
scatter(KSPassPDFStats.diamMedn*1e6,KSPassPDFStats.diamSkw,'filled','MarkerFaceAlpha',1)
hold on
scatter(KSFailPDFStats.diamMedn*1e6,KSFailPDFStats.diamSkw,'filled','MarkerFaceAlpha',1)
title('Median vs Skewness  of the PDFs')
xlabel('Median ')
ylabel('Skewness')
legend('KSPass','KSFail')
plottools


% getting the pdf of the liquid water content
figure('Name','PDF_LWC');

stairs(0.5*(KSPassPDFStats.PDF_LWC_edges(1:end-1)+...
    KSPassPDFStats.PDF_LWC_edges(2:end)),KSPassPDFStats.PDF_LWC_val)
hold on
stairs(0.5*(KSFailPDFStats.PDF_LWC_edges(1:end-1)+...
    KSFailPDFStats.PDF_LWC_edges(2:end)),KSFailPDFStats.PDF_LWC_val)
hold off
title('PDF of lwc >30e-6')
xlabel('lwc (g/m^3)')
ylabel('PDF')
legend('KSPass','KSFail')
plottools


%  getting the pdf of the Skewness
figure('Name','PDF_Skewness');

stairs(0.5*(KSPassPDFStats.PDF_Skw_edges(1:end-1)...
    +KSPassPDFStats.PDF_Skw_edges(2:end)),KSPassPDFStats.PDF_Skw_val)
hold on
stairs(0.5*(KSFailPDFStats.PDF_Skw_edges(1:end-1)...
    +KSFailPDFStats.PDF_Skw_edges(2:end)),KSFailPDFStats.PDF_Skw_val)
hold off
title('PDF of Skewness ')
xlabel('Skewness')
ylabel('PDF')
legend('KSPass','KSFail')
plottools

end
%--------------------------------------------------------------------------