%% Functions for performing KS Test with monte carlo samples of individual 
% -------------------------------------------------------------------------
% Function to generate the KSMatrix multiple times and average them to get 
% the ensemble sample result: Here used for comparing holorams with num
% conc at least 0.7 times the average value 

% Modified April 11,2022 to account for cfg file


function ensmblKSMatrixCondConc = ensembleKSMatrixlSamplingAvgNumConc(prtcleDiam,scale)
global cfg

% Setting params vals
% ensmblNs = 1e3;
ensmblNs = cfg.ensmblNs;
ncCutoff = cfg.ncCutoff;
alphaVal = cfg.alphaVal;
smplgCutoff = cfg.smplgCutoff;

ensmblKSMatrixCondConc=zeros(size(prtcleDiam,2));
tic
parfor cnt = 1:ensmblNs
    KSMatrixCondConc = KSMatrixWithConditionalSamplingAvgNumConc...
        (ncCutoff,alphaVal,smplgCutoff,prtcleDiam,scale);
    ensmblKSMatrixCondConc = ensmblKSMatrixCondConc + KSMatrixCondConc;
end
toc

% Normalizing the ensemble sum
ensmblKSMatrixCondConc = ensmblKSMatrixCondConc/ensmblNs;
end
% -------------------------------------------------------------------------