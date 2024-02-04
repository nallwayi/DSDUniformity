% function to get the histogram of all cluster transitions- Markov Chain
% like
% July 18,2022

function linkCntr = clusterLinks(cluster)
global cfg


linkCntr = zeros(cluster.nClusters,cluster.nClusters+1);
clusters = cluster.clusterInfo;
clusters = clusters+1;
clusters(clusters ==0) = max(clusters)+1;
for cnt=1:cluster.nClusters    
    ind = find(clusters == cnt);
    
    for cnt2 = 1:numel(ind)
        if ind(cnt2)<numel(clusters)
            tmp = clusters(ind(cnt2)+1);
        else
            tmp = clusters(1);
        end
        linkCntr(cnt,tmp) = linkCntr(cnt,tmp)+1;
    end
    
end



% Plotting the results

% Creating the cmap
customCmap = [1,1,1;0,0.447,0.741;0.635,0.078,0.184;0.466,0.674,0.188;...
    0.850,0.325,0.098;0.494,0.184,0.556;0.301,0.745,0.933;...
    0.929,0.694,0.125;0 0 1; 0 1 0];

% Creating additional customCmaps for greater cluster sizes
if cluster.nClusters > size(customCmap,1)-1
    temp = customCmap;  
    for cnt = 1:ceil(cluster.nClusters/9)-1
        customCmap = [customCmap;temp(2:end,:)];
    end
end

figure;
b = bar(linkCntr(:,1:end-1),'stacked','FaceColor','flat');

for cnt = 1:size(linkCntr,1)
    b(cnt).CData = customCmap(cnt+1,:);
    leg(cnt) = join(["C" num2str(cnt)]);
end
legend(leg)
xlabel('Clusters,n')
ylabel('n+1 link counts')

linkPlt = fullfile(cfg.folderHeader,['/' cfg.clusteringAlgo 'Results/'...
    '/ClstrLinksHist' cfg.fileHeader '.fig']);

savefig(linkPlt)

end