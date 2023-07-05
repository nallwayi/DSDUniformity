%% Functions for performing KS Test with monte carlo samples of individual 
% -------------------------------------------------------------------------
% Function to generate the KSMatrix multiple times and average them to get 
% the ensemble sample result: Here used for comparing holorams with num
% conc at least 0.7 times the average value 

% Modified April 11,2022 to account for cfg file
% Modified May 15, 2023 to process KSmatrix in parts
% Modified June 27, 2023 to process KSmatrix in parts- II 

function ensmblKSMatrixCondConc = ensembleKSMatrixlSamplingAvgNumConc(prtcleDiam,scale)
global cfg

% Setting params vals
% ensmblNs = 1e3;
ensmblNs = cfg.ensmblNs;
ncCutoff = cfg.ncCutoff;
alphaVal = cfg.alphaVal;
smplgCutoff = cfg.smplgCutoff;
microphysicsScheme = cfg.microphysicsScheme;

if ~isfield(cfg,'nRows') || isnan(cfg.nRows)
    ensmblKSMatrixCondConc=zeros(size(prtcleDiam,2));
    nRows= [];
    rowInd = [];
  
else
    rowInd = cfg.rowInd;
    if cfg.rowInd+cfg.nRows-1 < size(prtcleDiam,2)
        ensmblKSMatrixCondConc  = zeros(cfg.nRows,size(prtcleDiam,2));
        nRows= cfg.nRows;
    else
        ensmblKSMatrixCondConc  = zeros(length(cfg.rowInd:size(prtcleDiam,2)),...
            size(prtcleDiam,2));
        nRows= length(cfg.rowInd:size(prtcleDiam,2));
    end
    
    
end

parfor cnt = 1:ensmblNs
    
    KSMatrixCondConc = KSMatrixWithConditionalSamplingAvgNumConcLES...
        (ncCutoff,alphaVal,smplgCutoff,prtcleDiam,scale,nRows,rowInd,microphysicsScheme);
    ensmblKSMatrixCondConc = ensmblKSMatrixCondConc + KSMatrixCondConc;
end


% Normalizing the ensemble sum
ensmblKSMatrixCondConc = ensmblKSMatrixCondConc/ensmblNs;
end
% -------------------------------------------------------------------------