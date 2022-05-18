% Function to get the max clusters using OPTICS algorithm
% 04.04.2022
% Edited on 05.18.2022 to link the python code

function [eps,minPoints,nClusters,clusterInfo] = ...
    getMaxOPTICSClusters(ensmblKSMatrixCondConc)
global cfg

loc = cfg.folderHeader;
if exist(fullfile(loc,['OPTICSResults/cluster_OPTICS_' cfg.fileHeader '.mat']))==2
    load(fullfile(loc,['OPTICSResults/cluster_OPTICS_' cfg.fileHeader '.mat']))
else
    % loc = fullfile(pwd,'/OPTICSResults');
    pyscrptpath = 'G:/My Drive/Research_LaptopFiles/DSD_uniformity/getOPTICSClusters.py';
    filename = ['\EnsembleKSMatrix_1k_'  cfg.fileHeader ...
        '_NumConc_70%_0-P_1-F_1.2_N.mat'];
    loc = strrep(loc,'\','/');
    if isunix
    else
        [~,cmdout] = system(['python3 ' pyscrptpath ' "'...
            loc '/" "' filename '"'])
    end
    % loc = 'G:\My Drive\Research_LaptopFiles\DSD_uniformity\ACE_ENA_Results\AE_ST';
    load(fullfile(loc,['OPTICSResults/cluster_OPTICS_' cfg.fileHeader '.mat']))
end
nClusters = numel(unique(clusterInfo))-1;

end