

% --------------------------------------------------------------------------
for cnt=1:100
    for cnt2=1:5
        dist(cnt,cnt2) = gamrnd(5,7)*1e-6;
    end
end

tic
parfor cnt=1:5
    cnt
    dist1 = dist(~isnan(dist(:,cnt)),cnt);
    for cnt2=1:5
        dist2 = dist(~isnan(dist(:,cnt2)),cnt2);
        if length(dist1) >length(dist2)
            dist1 = datasample(dist1,length(dist2),'Replace',false);
        else
            dist2 = datasample(dist2,length(dist1),'Replace',false);
        end
        [h1(cnt,cnt2),ks2stat1(cnt,cnt2),delta(cnt,cnt2)] = ...
            kstest2withdelta(dist1,dist2,0.10);
        [h2(cnt,cnt2),p,ks2stat2(cnt,cnt2)] = ...
            kstest2(dist1,dist2,'alpha',0.10);
    end
end
toc




% -------------------------------------------------------------------------
% Function to perform the KS test for two distributions and calculate the
% KS stats
function [KSResult,KSStat,delta] = kstest2withdelta(dist1,dist2,alpha)

KSStatDist=getKSStatDist(dist1,dist2);
[bincntr,Fdist1,Fdist2,KSStat,delta]=kstest2sample(dist1,dist2);


% [KSStatDistCnt,KSStatDistEdges] = histcounts(KSStatDist,50);
% figure
% stairs(0.5*(KSStatDistEdges(1:end-1)+KSStatDistEdges(2:end)),KSStatDistCnt)
% 
[y,x] = ecdf(KSStatDist);
% figure
% stairs(x,y)
testKSStat = x(find(1-y > alpha, 1, 'last' ));


if KSStat <= testKSStat
    KSResult = 0;
else
    KSResult = 1;
end

% [y1,x1] = ecdf(dist1);
% [y2,x2] = ecdf(dist2);
% figure
% stairs(bincntr,Fdist1,'-.r');
% hold on
% stairs(x1,y1,'-.b');
% hold on
% stairs(bincntr,Fdist2,'r');
% hold on
% stairs(x2,y2,'-b');
% hold off



    function [bincntr,Fdist1,Fdist2,KSStat,delta]=kstest2sample(dist1,dist2)
        if length(dist1)~=length(dist2)
            error('This function only works for two distributions of same size')
        end
        llim = min([dist1;dist2]);
        ulim = max([dist1;dist2]);
        binwdth = (ulim-llim)/(length(dist1)/1);

        bin = llim:binwdth:ulim;
        bincntr = (bin(1:end-1)+bin(2:end))*0.5;
        n   = length(dist1);
        for cnt=1:length(bin)-1
            Fdist1(cnt) = 1/n * sum(dist1<=bin(cnt+1));
            Fdist2(cnt) = 1/n * sum(dist2<=bin(cnt+1));
        end
        KSStat = max(abs(Fdist2-Fdist1));
        delta  = bincntr(abs(Fdist2-Fdist1)==max(abs(Fdist2-Fdist1)));
        if length(delta)>1
            delta = min(delta);
        end
    end


    % Calculate the KS Statistic distribution: using Permutation test
    function KSStatDist=getKSStatDist(dist1,dist2)
        
        ensmblNs = 1e4;
        dist = [dist1;dist2];
        
        KSStatDist = nan(ensmblNs,1);
        for cnt =1:ensmblNs
            dist1 = datasample(dist,length(dist1),'Replace',false);
            dist2 = datasample(dist,length(dist1),'Replace',false);
            [~,~,~,KSStatDist(cnt),~]=kstest2sample(dist1,dist2);
        end
        
        
    end




end
% -------------------------------------------------------------------------

