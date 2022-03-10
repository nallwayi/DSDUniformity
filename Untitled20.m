







%--------------------------------------------------------------------------
% Jan 18, 2022
% 
% Function to retrieve DBSCAN results and use it to get the
% average PDF and CDF info 
function getDBSCANClusters(ensmblKSMatrixCondConc,prtcleDiam)
global folderHeader fileHeader

if ~exist(fullfile(folderHeader,'/DBSCANResults/'),'dir')
    mkdir(fullfile(folderHeader,'/DBSCANResults/'))
end

eps = 0.1;
minPoints = 10:1:50;
graph = ensmblKSMatrixCondConc;
graph(graph>1) = nan;


for cnt = 1:length(minPoints)
    [nClusters(cnt),labels(cnt,:)] = ...
        customDBSCAN(eps, minPoints(cnt), graph);
    
    clusters = unique(labels(cnt,labels(cnt,:) > -1));
    noiseElements = sum(isnan(labels));
    for cnt2 = 1:length(clusters)
        clstrElemnts(cnt,cnt2) = sum(labels(cnt,:) == clusters(cnt2));
    end
    
end




if ~exist([folderHeader '/DBSCANResults/ClstrSizeWtMinPts_' ...
        fileHeader '.fig'],'file')
    
    % minpoints vs noclusters plot
    f = figure;
    filename = 'ClstrSizeWtMinPts';
    plot(minPoints,nClusters,'-*b')
    title(['MinPoints- nClusters eps-0.1' fileHeader])
    xlabel('MinPoints')
    ylabel('nClusters')
    savefig([folderHeader '/DBSCANResults/'  filename '_' fileHeader '.fig'])
    close(f)
    
end



[nClusters,maxInd] = max(nClusters);
clusterInfo = labels(maxInd,:);
minPoints = minPoints(maxInd);


cluster.clusterInfo = clusterInfo;
cluster.eps = eps;
cluster.minPoints = minPoints;
cluster.nClusters = nClusters;
clstrParamsNames = ['_eps' num2str(eps) '_minPoints_' num2str(minPoints)];

filename = 'clusterInfo';
clusterInfoLoc= ([folderHeader '/DBSCANResults/'  filename '_' fileHeader  ...
        clstrParamsNames '.mat']);
if ~exist(clusterInfoLoc)
    save([folderHeader '/DBSCANResults/'  filename '_' fileHeader  ...
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


if ~exist([folderHeader '/DBSCANResults/KSMtrxWithClusterInfo_' ...
        fileHeader  clstrParamsNames '.fig'],'file')
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
    sgtitle([filename ' ' fileHeader clstrParamsNames])
    savefig([folderHeader '/DBSCANResults/'  filename '_' fileHeader  clstrParamsNames '.fig'])
    close(f)

end

if ~exist([folderHeader '/DBSCANResults/ClstrDistParams_' fileHeader ...
        clstrParamsNames '.fig'],'file')
    averagePDFWithHoloClusters(prtcleDiam,cluster,customCmap,clstrParamsNames)
    getGammaFitparamsCluster(prtcleDiam,cluster,customCmap,clstrParamsNames)
end
end
%--------------------------------------------------------------------------