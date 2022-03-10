function removeJoiners(cluster,ensmblKSMatrixCondConc)

labels = cluster.clusterInfo;
eps = cluster.eps;
minPoints = cluster.minPoints;


clusterIds = unique(cluster.clusterInfo);
clusterIds(clusterIds <0) = [];


for cnt = 1: numel(clusterIds)
    
    clusterInd = find(labels == cnt-1);
    memberArray=[];
    for cnt2 = 1:size(clusterInd,2)
        memberArray{cnt2} = find(ensmblKSMatrixCondConc(clusterInd(cnt2),:) < eps);
        elementMatchCnt(cnt2) = numel(memberArray{cnt2});

        
    end
    tmp= 1:size(ensmblKSMatrixCondConc,1);
    for cnt2 = 1:size(clusterInd,2)
        tmp =  intersect(memberArray{cnt2},tmp);
        for cnt3 = 1:size(clusterInd,2)
            intrstMtrx(cnt2,cnt3) = numel(intersect(memberArray{cnt2},...
                memberArray{cnt3}));
            
        end
    end
    mnClstrLinks = mean(reshape(intrstMtrx(intrstMtrx>0),1,[]));
    
    elemts2Rmv = clusterInd(elementMatchCnt<mnClstrLinks );
    
    for cnt2 = 1:numel(elemts2Rmv)
        ensmblKSMatrixCondConc(elemts2Rmv(cnt2),:) = 1.2;
        ensmblKSMatrixCondConc(:,elemts2Rmv(cnt2)) = 1.2;
    end
end

end