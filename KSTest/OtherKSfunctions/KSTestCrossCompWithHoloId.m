%% Conditional Sampling Functions
% -------------------------------------------------------------------------

% Function to do KS test for single holograms by hologram numbers
% The numbers are defined by similar number concentrations

function KSTestCrossCompWithHoloId(prtcleDiam,holoInd)
    KSMtrx = nan(length(holoInd));
for cnt=1:length(holoInd)
    dist1 = prtcleDiam(~isnan(prtcleDiam(:,holoInd(cnt))),holoInd(cnt));
    
    for cnt2=1:length(holoInd)
        dist2 = prtcleDiam(~isnan(prtcleDiam(:,holoInd(cnt2))),holoInd(cnt2));
        if ~isempty(dist1) && ~isempty(dist2)       
            [h,p,ks2stat] = kstest2(dist1,dist2,'alpha',0.10);
            KSMtrx(cnt,cnt2) = h; 
        end
    end
end

KSMtrx(isnan(KSMtrx))=1;
figure('Name','KS Matrix');
image(KSMtrx,'CDataMapping','scaled')
axis square
plottools
end
% -------------------------------------------------------------------------