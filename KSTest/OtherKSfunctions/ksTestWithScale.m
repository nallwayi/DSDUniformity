%% Functions for performing KS Tests
%--------------------------------------------------------------------------
% Performing KS-Test by comparing with the general dist
function ksTest = ksTestWithScale(prtcleDiam,rwCnt,cmCnt,scale)
ksTest = nan((cmCnt),length(scale));
masterDist = reshape(prtcleDiam,rwCnt*scale(end),cmCnt/scale(end));

figure

for cnt= 1:length(scale)-1
    tmp = reshape(prtcleDiam,rwCnt*scale(cnt),cmCnt/scale(cnt));   
    tmpInd = 1;
    for cnt2 = 1:cmCnt/scale(cnt)           
            if sum(~isnan(tmp(:,cnt2)))>0 
%                 ksTest(tmpInd,cnt) = kstest2(tmp(~isnan(tmp(:,cnt2)),cnt2).^2-median(tmp(~isnan(tmp(:,cnt2)),cnt2).^2),...
%                     masterDist(~isnan(masterDist(:,1)),1).^2-median(masterDist(~isnan(masterDist(:,1)),1).^2));
                 [h,p,ks2stat]= kstest2(tmp(~isnan(tmp(:,cnt2)),cnt2)-median(tmp(~isnan(tmp(:,cnt2)),cnt2)),...
                    masterDist(~isnan(masterDist(:,1)),1)-median(masterDist(~isnan(masterDist(:,1)),1)),'alpha',0.10);
                ksTest(tmpInd,cnt) = h;
                ksTest_pval(tmpInd,cnt) = p;
                ksTest_ks2stat(tmpInd,cnt) = ks2stat;
                
                
%                 dist1 = tmp(~isnan(tmp(:,cnt2)),cnt2);
%                 dist2 = masterDist(~isnan(masterDist(:,1)),1);
%                 ksTest(tmpInd,cnt) = kstest2(dist1,dist2);
                tmpInd = tmpInd+1;
            end
    end
    scatter(cnt,sum(ksTest(:,cnt) == 0)/((cmCnt/scale(cnt))),'filled','MarkerFaceAlpha',1)
    hold on
end
title('KS TEST: Comparison with avg dist ')
xlabel('scale')
ylabel('Fraction(KS PASS)')

figure

for cnt=1:length(scale)-1
    
    scatter(cnt,sum(ksTest(:,cnt) == 0),'filled','MarkerFaceAlpha',1)
    hold on
end
title('KS TEST: Comparison with avg dist')
xlabel('scale')
ylabel('Count(KS PASS)')
end
%--------------------------------------------------------------------------