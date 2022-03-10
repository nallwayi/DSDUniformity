%% Functions for performing KS Test with monte carlo samples of individual 
% -------------------------------------------------------------------------
% Function to generate the KSMatrix multiple times and average them to get 
% the ensemble sample result: Here used for comparing holorams with num
% conc at least 0.7 times the average value 

function ensmblKSMatrixCondConc = ensembleKSMatrixlSamplingAvgNumConc(prtcleDiam,scale)

% Defining ensemble parameters
ensmblNs = 1e3;
ensmblKSMatrixCondConc=zeros(size(prtcleDiam,2));
tic
parfor cnt = 1:ensmblNs
    KSMatrixCondConc = KSMatrixWithConditionalSamplingAvgNumConc(prtcleDiam,scale);
    ensmblKSMatrixCondConc = ensmblKSMatrixCondConc + KSMatrixCondConc;
end
toc

% Normalizing the ensemble sum
ensmblKSMatrixCondConc = ensmblKSMatrixCondConc/ensmblNs;
end
% -------------------------------------------------------------------------