%% Functions for performing KS Test with monte carlo samples from global dist

%--------------------------------------------------------------------------
% Function to go the ks test of a dist with the monte carlo sample from the
% main dist

function [h,p,ks2stat] = KSTestWithMonteCarloSample(testDist,mainDist)


% Removing all values below 10 microns
testDist = testDist(testDist>10e-6);

% Generating the random sample
sampleLngth = length(testDist);
if sampleLngth > 30
    sampleDist = generateRandomSample(mainDist,sampleLngth);
    % Performing the KS test
    [h,p,ks2stat] = kstest2(testDist,sampleDist,'alpha',0.10);

else
    h = nan;
    p = nan;
    ks2stat = nan;
%     warning('The length of the dist is too small to perform KS Test')
    return;
end

end

%-----------------------------------------------------------------------