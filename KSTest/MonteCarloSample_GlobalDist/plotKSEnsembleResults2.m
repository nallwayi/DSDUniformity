
%% Functions for performing KS Test with monte carlo samples from global dist

% -------------------------------------------------------------------------
% Function2 to plot the KS Ensemble results
function plotKSEnsembleResults2(hEnsmblPass)

global utime ltime altind

figure('Name','KS Pass: Ensemble-Scale -1');
scatter(1:length(hEnsmblPass),hEnsmblPass,'filled','MarkerFaceAlpha',1)
title(['KS Pass: ' altind '-' num2str(ltime) '\_ ' num2str(utime) ...
    'Count with scale for ensemble sample 10K'])
xlabel('Individual sample')
ylabel('KSPass count')
end
% -------------------------------------------------------------------------

