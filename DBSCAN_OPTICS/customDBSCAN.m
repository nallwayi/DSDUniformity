%-------------------------------------------------------------------------- 
% Function to implement the DBSCAN algorithm
%  Ref : Ester, M., Kriegel, H. P., Sander, J., & Xu, X. (1996, August).
%        A density-based algorithm for discovering clusters in large spatial
%        databases with noise. In kdd (Vol. 96, No. 34, pp. 226-231).
% -------------------------------------------------------------------------

function [nClusters,labels] = customDBSCAN(eps, minPoints, graph)


labels = nan(size(graph,1),1);
nClusters = 0;

for point = 1:size(graph,1)

    if ~isnan(labels(point))
        continue
    end
    [isCluster,labels] = expandCluster(graph, point, labels,...
        nClusters, eps, minPoints);
    if isCluster
        nClusters = nClusters+1;
    end
end

end


function [isCluster,labels] = expandCluster(graph, point, labels, nClusters, eps, minPoints)

row = graph(point,:);
neighbors = find(row < eps);

if length(neighbors) < minPoints
    isCluster =  false;
    labels(point) = -1 ; % Noise
    return
else
    
%   Adding neighbors to cluster
    for cnt2 = 1:length(neighbors)
        labels(neighbors(cnt2)) = nClusters;
    end
    neighbors(neighbors == point) = [];
  
%   Making each neighbor point as the central point and repating the
%   process
    while ~isempty(neighbors)
        currentPoint = neighbors(1);
        currentrow = graph(currentPoint,:);
        newNeighbors = find(currentrow < eps);
        
        if length(newNeighbors) >= minPoints
            for cnt2 = 1:length(newNeighbors)
                resultPoint = newNeighbors(cnt2);
                if isnan(labels(resultPoint)) || labels(resultPoint) ==-1
                    if isnan(labels(resultPoint))
                        neighbors = [neighbors resultPoint];
                    end
                    labels(resultPoint) = nClusters;
                end
            end
        end
        neighbors(neighbors == currentPoint) = [];
    end
    isCluster = true;
end

end