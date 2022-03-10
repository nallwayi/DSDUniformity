%% Conditional Sampling Functions -- Part2 
% -------------------------------------------------------------------------
% Function to do the KS test only if within the range of number
% concentration. Here all the holograms that dosent satisfy the requirement
% are blackened out

function KSMatrixCondConc=KSMatrixWithConditionalSamplingNumConc(prtcleDiam,scale,tolerance)

prtcleDiam= reshape(prtcleDiam,[],size(prtcleDiam,2)/scale);

KSMatrixCondConc  = nan(size(prtcleDiam,2));
for cnt = 1: size(prtcleDiam,2)
    dist    = prtcleDiam(~isnan(prtcleDiam(:,cnt)),cnt);%-...
%         median(prtcleDiam(~isnan(prtcleDiam(:,cnt)),cnt));
    numConc = length(dist);
    llim    = numConc-numConc*tolerance/100;
    ulim    = numConc+numConc*tolerance/100;
    
    if ~isempty(dist)
        for cnt2 = 1:size(prtcleDiam,2)
            testDist = prtcleDiam(~isnan(prtcleDiam(:,cnt2)),cnt2);%-...
%                 median(prtcleDiam(~isnan(prtcleDiam(:,cnt2)),cnt2));
            if length(testDist) >= llim && length(testDist) <= ulim...
                    && ~isempty(testDist)
                ksresult = kstest2(dist,testDist,'alpha',0.10); 
            else 
                ksresult = 1.2;
            end
            KSMatrixCondConc(cnt,cnt2) = ksresult;
        end
    end
end

% Removing all nan value holograms
KSMatrixCondConc(isnan(KSMatrixCondConc))=1.2;

end
% -------------------------------------------------------------------------