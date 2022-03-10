
%--------------------------------------------------------------------------
% Performing KS-Test on the partcle diameter array: Cross comparison
function ksTest_cross = ksTestWithScale_CrossComp(prtcleDiam,rwCnt,cmCnt,scale)

ksTest_cross = nan((cmCnt)*(cmCnt-1)/2,length(scale));
figure
for cnt= 1:length(scale)-1
    tmp = reshape(prtcleDiam,rwCnt*scale(cnt),cmCnt/scale(cnt));
    
    tmpInd = 1;
    for cnt2 = 1:cmCnt/scale(cnt)
        for cnt3 = cnt2+1:cmCnt/scale(cnt)
            
            if sum(~isnan(tmp(:,cnt2)))>0 && sum(~isnan(tmp(:,cnt3)))>0
                ksTest_cross(tmpInd,cnt) = kstest2(tmp(~isnan(tmp(:,cnt2)),cnt2)-median(tmp(~isnan(tmp(:,cnt2)),cnt2)),...
                    tmp(~isnan(tmp(:,cnt3)),cnt3)-median(tmp(~isnan(tmp(:,cnt3)),cnt3)));
                tmpInd = tmpInd+1;
            end
        end
    end
    scatter(cnt,sum(ksTest_cross(:,cnt) == 0)/((cmCnt/scale(cnt)-1)*(cmCnt/scale(cnt))/2),'filled','MarkerFaceAlpha',1)
    hold on
end
title('KS TEST: Cross Comparison')
xlabel('scale')
ylabel('Fraction(KS PASS)')

figure
for cnt=1:length(scale)-1
    
    scatter(cnt,sum(ksTest_cross(:,cnt) == 0),'filled','MarkerFaceAlpha',1)
    hold on
end
title('KS TEST: Cross Comparison ')
xlabel('scale')
ylabel('Count(KS PASS)')
end
%--------------------------------------------------------------------------