
% Function to retrieve DBSCAN results and use it to get the
% average PDF and CDF info 
%--------------------------------------------------------------------------
% Jan 18, 2022
% Modified April 04,2022 to include OPTICS
% Modified April 11,2022 to account for cfg file

function getClusters(ensmblKSMatrixCondConc,prtcleDiam)
global cfg

if ~exist(fullfile(cfg.folderHeader,[cfg.clusteringAlgo 'Results/']),'dir')
    mkdir(fullfile(cfg.folderHeader,[cfg.clusteringAlgo 'Results/']))
end


if strcmp(cfg.clusteringAlgo,'DBSCAN')
    [eps,minPoints,nClusters,clusterInfo] = ...
        getMaxDBSCANClusters(ensmblKSMatrixCondConc);
elseif strcmp(cfg.clusteringAlgo,'OPTICS')
    
    [eps,minPoints,nClusters,clusterInfo] = ...
        getMaxOPTICSClusters(ensmblKSMatrixCondConc);
end

cluster.clusterInfo = clusterInfo;
cluster.eps = eps;
cluster.minPoints = minPoints;
cluster.nClusters = nClusters;
clstrParamsNames = ['_eps' num2str(eps) '_minPoints_' num2str(minPoints)];

filename = 'clusterInfo';
clusterInfoLoc= ([cfg.folderHeader '/' cfg.clusteringAlgo 'Results/'  filename '_' cfg.fileHeader  ...
        clstrParamsNames '.mat']);
if ~exist(clusterInfoLoc)
    save([cfg.folderHeader '/' cfg.clusteringAlgo 'Results/'  filename '_' cfg.fileHeader  ...
        clstrParamsNames '.mat'],'cluster')
end


tmp = histcounts(cluster.clusterInfo);
cmCnt = max(tmp(2:end));
holoClusters = nan(cluster.nClusters,cmCnt);
for cnt2 = 1:cluster.nClusters
    ind = find(cluster.clusterInfo == cnt2-1);
    holoClusters(cnt2,1:numel(ind)) = ind;
end
cluster.holoClusters =holoClusters;



clusterMtrx = nan(size(prtcleDiam,2));
for cnt=1:cluster.nClusters
    ind = cluster.clusterInfo==cnt-1;
    clusterMtrx(ind,ind) = cnt;
end
clusterMtrx(isnan(clusterMtrx)) = 0;
mtrx = zeros(size(clusterMtrx));
for cnt =1:cluster.nClusters
    mtchngHoloind = clusterMtrx ==cnt & ensmblKSMatrixCondConc < 1 ;
    mtrx(mtchngHoloind) = cnt;
end


customCmap = [1,1,1;0,0.447,0.741;0.635,0.078,0.184;0.466,0.674,0.188;...
    0.850,0.325,0.098;0.494,0.184,0.556;0.301,0.745,0.933;...
    0.929,0.694,0.125;0 0 1; 0 1 0];
% customCmap = [1,1,1;0, 0, 1;0, 0.5, 0;1, 0, 0;0, 0.75, 0.75;0.75, 0, 0.75;...
%     0.75, 0.75, 0;0.25, 0.25, 0.25];


% Creating additional customCmaps for greater cluster sizes
if cluster.nClusters > size(customCmap,1)-1
    temp = customCmap;  
    for cnt = 1:ceil(cluster.nClusters/9)-1
        customCmap = [customCmap;temp(2:end,:)];
    end
end


if ~exist([cfg.folderHeader '/' cfg.clusteringAlgo 'Results/KSMtrxWithClusterInfo_' ...
        cfg.fileHeader  clstrParamsNames '.fig'],'file')
    f=figure('Name','ClusterPDF','units','normalized','outerposition',[0 0 1 1]);
    filename = 'KSMtrxWithClusterInfo';
    
    t=tiledlayout(1,2,'TileSpacing','compact','Padding','compact');
    im1=nexttile;
    pbaspect([1 1 1])
    ensmblKSMatrixCondConc(ensmblKSMatrixCondConc>1) = 1.2;
    image(ensmblKSMatrixCondConc,'CDataMapping','scaled')
    colormap(im1,hot)
    axis square
    set(colorbar, 'ylim', [0 1])
    xlabel('Hologram #')
    ylabel('Hologram #')
    title('KS Matrix')
    
    im2=nexttile;
    pbaspect([1 1 1])
    image(mtrx,'CDataMapping','scaled');
    xlabel('Hologram #')
    ylabel('Hologram #')
    title('Identified Clusters')
    colormap(im2,customCmap(1:cluster.nClusters+1,:));
    axis square
    sgtitle([filename ' ' cfg.fileHeader clstrParamsNames])
    savefig([cfg.folderHeader '/' cfg.clusteringAlgo 'Results/'  filename '_' cfg.fileHeader  clstrParamsNames '.fig'])
    close(f)

end

if ~exist([cfg.folderHeader '/' cfg.clusteringAlgo 'Results/ClstrDistParams_' cfg.fileHeader ...
        clstrParamsNames '.fig'],'file')
    averagePDFWithHoloClusters(prtcleDiam,cluster,customCmap,clstrParamsNames)
    getGammaFitparamsCluster(prtcleDiam,cluster,customCmap,clstrParamsNames)
end

if ~exist([cfg.folderHeader '/' cfg.clusteringAlgo 'Results/ClstrSpaghettiPlts_' cfg.fileHeader ...
        clstrParamsNames '.fig'],'file')
    spaghettiPlotsforClusters(prtcleDiam,cluster,customCmap,clstrParamsNames)
end
end
%--------------------------------------------------------------------------