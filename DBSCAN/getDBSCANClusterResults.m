% -------------------------------------------------------------------------
% Jan 18, 2022
% This function is no longer needed as customDBSCAN function for MATLAB is
% written
% Sept 17, 2021
% 
% Function to retrieve the cluster info from the DBSCAN results and get the
% average PDF and CDF info of the clusters

% The path to the DBSCAN results is given by
% C:\Users\rashaw-adm\Documents\nithin\AnacondaFiles\DBScanResults\
% Change the pathtomatfiles varibale if the location changes

function getDBSCANClusterResults(prtcleDiam)
global utime ltime altind
% pathtomatfiles=...
%     ['C:\Users\rashaw-adm\Documents\nithin\AnacondaFiles\DBScanResults\' ...
%     num2str(altind) '_' num2str(ltime) '_' num2str(utime) '\'];

pathtomatfiles=...
    ['G:\Other computers\RShaw\nithin\AnacondaFiles\DBScanResults\' ...
    num2str(altind) '_' num2str(ltime) '_' num2str(utime) '\'];
clusterFileInfo = dir(fullfile(pathtomatfiles,'*.mat'));
for cnt=1:numel(clusterFileInfo)
    
    plotTitle = [clusterFileInfo(cnt).name(9:10) ' ' ...
        clusterFileInfo(cnt).name(12:16) '-' ...
        clusterFileInfo(cnt).name(18:22) ];
    cluster = load([pathtomatfiles clusterFileInfo(cnt).name]);
    
    tmp = histcounts(cluster.clusterInfo);
    cmCnt = max(tmp(2:end));
    holoClusters = nan(cluster.nClusters,cmCnt);
    for cnt2 = 1:cluster.nClusters
        ind = find(cluster.clusterInfo == cnt2-1);
        holoClusters(cnt2,1:numel(ind)) = ind;
    end
    cluster.holoClusters =holoClusters;
    if cluster.nClusters >=1
%         save([pwd '\DBSCANResults\Clstr_' plotTitle '.mat'],'cluster')
        averagePDFWithHoloClusters(prtcleDiam,cluster,plotTitle)
        getGammaFitparamsCluster(prtcleDiam,cluster,plotTitle)
    end
end
end
% -------------------------------------------------------------------------
