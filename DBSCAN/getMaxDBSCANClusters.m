% Function to get the combination that maximizes the number of clusters
% for a given KS Matrix. It also saves the all the possible hyperparameter
% combination tried in the DBSCAN results folder
%  2022.03.09

function [eps,minPoints,nClusters,clusterInfo] = ...
    getMaxDBSCANClusters(ensmblKSMatrixCondConc)
global folderHeader fileHeader

filename = 'clusterMtrx';
clusterInfoLoc= ([folderHeader '/DBSCANResults/'  filename '_' fileHeader  ...
    '.mat']);
if ~exist(clusterInfoLoc,'file')
    eps = 0.07:0.01:0.3;
    minPoints = 10:1:50;
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
    
    save([folderHeader '/DBSCANResults/'  filename '_' fileHeader  ...
        '.mat'],'eps','minPoints','nClusters','labels','clstrElemnts')
else
    load([folderHeader '/DBSCANResults/'  filename '_' fileHeader  ...
        '.mat'])
end


if ~exist([folderHeader '/DBSCANResults/ClstrSizeWtMinPtsEps_' ...
        fileHeader '.fig'])
    
    % minpoints vs eps vs noclusters plot
    f = figure;
    filename = 'ClstrSizeWtMinPtsEps';
    [MINPOINTS,EPS] = meshgrid(minPoints,eps);
    pcolor(MINPOINTS,EPS,nClusters)
    %     plot(minPoints,nClusters,'-*b')
    title(['MinPoints- eps-nClusters ' strrep(fileHeader,'_','\_')])
    xlabel('MinPoints')
    ylabel('Eps')
    colorbar
    savefig([folderHeader '/DBSCANResults/'  filename '_' fileHeader '.fig'])
    close(f)
    
end

ind = find(nClusters == max(reshape(nClusters,1,[])),1);
indRw = rem(ind,size(nClusters,1));
indCm = ceil(ind/size(nClusters,1));

eps = eps(indRw);
minPoints = minPoints(indCm);
clusterInfo = reshape(labels(indRw,indCm,:),1,[]);
nClusters = nClusters(indRw,indCm);

end