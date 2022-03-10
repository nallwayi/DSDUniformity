%% Functions for performing KS Test with monte carlo samples from global dist

% -------------------------------------------------------------------------
% Function to plot the KS Ensemble results

function plotKSEnsembleResults(passPrcnt,passNs)
figure('Name','KS Pass: Ensemble');
scatter(0:length(passPrcnt)-1,passPrcnt,'filled','MarkerFaceAlpha',1)
title('KS Pass: Percentage with scale for ensemble sample 5K')
xlabel('Scale (2^n)')
ylabel('KSPass percent')


figure('Name','KS Pass: Ensemble');
scatter(0:length(passNs)-1,passNs,'filled','MarkerFaceAlpha',1)
title('KS Pass: Count with scale for ensemble sample 5K')
xlabel('Scale (2^n)')
ylabel('KSPass count')

end

%--------------------------------------------------------------------------