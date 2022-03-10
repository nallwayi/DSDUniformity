%% Conditional Sampling Functions
% -------------------------------------------------------------------------
% Function to do conditional sampling KS test for holograms with similar
% number concentrations


function conditionalSamplingNumConc(prtcleDiam)


llimit = 200;
ulimit = 3000;
bin    = 50;

for cnt =1:size(prtcleDiam,2)
    prtcleCnt(cnt) = sum(~isnan(prtcleDiam(:,cnt)));
end
    
[prtcleCntHist,edges] = histcounts(prtcleCnt,llimit:bin:ulimit);
for cnt = 1: length(prtcleCntHist)
    holoInd = find(prtcleCnt>= edges(cnt) & prtcleCnt<= edges(cnt+1));
    if length(holoInd) >10
        KSTestCrossCompWithHoloId(prtcleDiam,holoInd)
    end
end

end

% -------------------------------------------------------------------------