%% Functions for performing KS Test with monte carlo samples of individual 
% -------------------------------------------------------------------------
% Function to plot the KS test results of conditional number concentration
% sampling: Here monte carlo samples of holograms with number concentration
% greter than 0.7 times average is compared. 1.2 represents the removed
% holograms
function plotensembleKSMatrixlSamplingAvgNumConc(ensmblKSMatrixCondConc)
global altind ltime utime
% Optimising for viewing
ensmblKSMatrixCondConc(ensmblKSMatrixCondConc==2) = 1.2;

figure('Name','KS Matrix','Units', 'Normalized', 'OuterPosition', [0 0 1 1])
image(ensmblKSMatrixCondConc,'CDataMapping','scaled')
c = hot;
colormap(c)
axis square
caxis([0 1.2])
colorbar
title(['KS Matrix: ' altind '-' num2str(ltime) '\_' num2str(utime) ...
 '    70 % cutoff 1k ensemble'])

% plottools
end
% -------------------------------------------------------------------------