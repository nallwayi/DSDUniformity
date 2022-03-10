
%% Functions for performing KS Tests
% Edited on 2022.03.09
%--------------------------------------------------------------------------
% Creating a matrix of KS-Test results for single holograms
function ksMatrix = KSMatrix(prtcleDiam)

ksMatrix = nan(size(prtcleDiam,2));
% tmp = reshape(prtcleDiam,rwCnt,cmCnt);
tmp = prtcleDiam;
tmp(tmp<10e-6) = nan;

for cnt = 1:size(prtcleDiam,2)
    dist1 = tmp(~isnan(tmp(:,cnt)),cnt);
    if ~isempty(dist1) && numel(dist1) > 35
        parfor cnt2 = 1:size(prtcleDiam,2)
            
            dist2 = tmp(~isnan(tmp(:,cnt2)),cnt2);
            if ~isempty(dist2) && numel(dist2) > 35
                %                     ksMatrix(cnt,cnt2) = kstest2(tmp(~isnan(tmp(:,cnt)),cnt)-median(tmp(~isnan(tmp(:,cnt)),cnt)),...
                %                         tmp(~isnan(tmp(:,cnt2)),cnt2)-median(tmp(~isnan(tmp(:,cnt2)),cnt2)),...
                %                         'Alpha',0.20);
                ksMatrix(cnt,cnt2) = kstest2(dist1,dist2,'Alpha',0.05);
            end
        end
    end
end

end
%--------------------------------------------------------------------------