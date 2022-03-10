%% Functions for performing KS Test with monte carlo samples from global dist

%--------------------------------------------------------------------------
% Function to get the ensemble KS test results of a testDist
% If the dists are same then
% the p values are higher
% KS stat is low
% h is 0 for KS pass and 1 for KS fail 

function [hEnsmblPass] = ensembleKSTest(testDist,mainDist,ensmblNs)


 hEnsmbl       = nan(ensmblNs,1);
 pEnsmbl       = nan(ensmblNs,1);
 ks2statEnsmbl = nan(ensmblNs,1);
for cnt =1: ensmblNs
    [hEnsmbl(cnt),pEnsmbl(cnt),ks2statEnsmbl(cnt)] = ...
        KSTestWithMonteCarloSample(testDist,mainDist);
end


hEnsmblPass = sum(hEnsmbl==0);
% pEnsmbl = mean(pEnsmbl);
% ks2statEnsmbl = mean(ks2statEnsmbl);

% figure
% hist(hEnsmbl)
% figure
% hist(pEnsmbl)
% figure
% hist(ks2statEnsmbl)
end


%--------------------------------------------------------------------------