% Function to get the combination that maximizes the number of clusters
% for a given KS Matrix. It also saves the all the possible hyperparameter
% combination tried in the DBSCAN results folder
%  2022.03.09
% Modified April 11,2022 to account for cfg file

function [eps,minPoints,nClusters,clusterInfo] = ...
    getMaxDBSCANClusters(ensmblKSMatrixCondConc)
global cfg

filename = 'clusterMtrx';
clusterInfoLoc= ([cfg.folderHeader '/DBSCANResults/'  filename '_' cfg.fileHeader  ...
    '.mat']);
if ~exist(clusterInfoLoc,'file')
    %     eps = 0.07:0.01:0.3;
    % %     eps = 0.1;
    %     minPoints = 10:1:100;
    eps = cfg.eps;
    minPoints = cfg.minPoints;
    graph = ensmblKSMatrixCondConc;
    graph(graph>1) = nan;
    
    
    
    for cnt = 1:length(eps)
        
        for cnt2 = 1:length(minPoints)
            [nClusters(cnt,cnt2),labels(cnt,cnt2,:)] = ...
                customDBSCAN(eps(cnt), minPoints(cnt2), graph);
            
            clusters = unique(labels(cnt,cnt2,labels(cnt,cnt2,:) > -1));
            noiseElements = sum(sum(isnan(labels(cnt,cnt2,:))));
            for cnt3 = 1:length(clusters)
                clstrElemnts(cnt,cnt2,cnt3) = sum(labels(cnt,cnt2,:) == clusters(cnt3));
            end
            
        end
    end
    
    save([cfg.folderHeader '/DBSCANResults/'  filename '_' cfg.fileHeader  ...
        '.mat'],'eps','minPoints','nClusters','labels','clstrElemnts')
else
    load([cfg.folderHeader '/DBSCANResults/'  filename '_' cfg.fileHeader  ...
        '.mat'])
end


if ~exist([cfg.folderHeader '/DBSCANResults/ClstrSizeWtMinPtsEps_' ...
        cfg.fileHeader '.fig'])
    
    %     minpoints vs eps vs noclusters plot
    f = figure;
    filename = 'ClstrSizeWtMinPtsEps';
    if numel(eps)==1
        plot(minPoints,nClusters,'-*b')
        xlabel('MinPoints')
        ylabel('nClusters')
    else
%         [MINPOINTS,EPS] = meshgrid(minPoints,eps);
        imagesc(minPoints,eps,nClusters)
        xlabel('MinPoints')
        ylabel('Eps')
        colorbar
        set(gca,'YDir','normal')
    end
    title(['MinPoints- eps-nClusters ' strrep(cfg.fileHeader,'_','\_')])
    
    savefig([cfg.folderHeader '/DBSCANResults/'  filename '_' cfg.fileHeader '.fig'])
    close(f)
    
end

ind = find(nClusters' == max(reshape(nClusters,1,[])),1);
indCm = rem(ind,size(nClusters,2));
indRw = ceil(ind/size(nClusters,2));

eps = eps(indRw);
minPoints = minPoints(indCm);
clusterInfo = reshape(labels(indRw,indCm,:),1,[]);
nClusters = nClusters(indRw,indCm);

end