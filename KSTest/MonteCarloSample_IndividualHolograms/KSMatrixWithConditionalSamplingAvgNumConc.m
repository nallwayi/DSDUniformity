%% Functions for performing KS Test with monte carlo samples of individual 
% -------------------------------------------------------------------------
% Function to do the KS test and get the KSMAtrix for conditional 
% sampling of holograms
% Here the total number of particles in a hologram is reduced to 60 or
% 70 percent of its average value and then compared with each other to get
% the KSMatrix


% Modified April 11,2022 to account for cfg file

function KSMatrixCondConc = KSMatrixWithConditionalSamplingAvgNumConc...
    (ncCutoff,alphaVal,smplgCutoff,prtcleDiam,scale)

% Setting the cutoff to 10 um
prtcleDiam(prtcleDiam<10e-6) =nan;

% Reshaping to the desireed scale 
prtcleDiam= reshape(prtcleDiam,[],size(prtcleDiam,2)/scale);

KSMatrixCondConc  = nan(size(prtcleDiam,2));

numConc = nan(size(prtcleDiam,2),1);
for cnt=1:size(prtcleDiam,2)
    numConc(cnt) = sum(~isnan(prtcleDiam(:,cnt)));
end
cutOffNumConc       = round(ncCutoff * mean(numConc)); %percent cutoff determination
if smplgCutoff ~= -9999
    smplngcutOffNumConc = round(smplgCutoff * mean(numConc));
end

for cnt = 1: size(prtcleDiam,2)
    dist    = prtcleDiam(~isnan(prtcleDiam(:,cnt)),cnt);%-...
%         median(prtcleDiam(~isnan(prtcleDiam(:,cnt)),cnt));
    if ~isempty(dist) && numConc(cnt) >= cutOffNumConc
        if exist('smplngcutOffNumConc','var')
            dist = generateRandomSample(dist,smplngcutOffNumConc);
        end
        for cnt2 = 1:size(prtcleDiam,2)
            testDist = prtcleDiam(~isnan(prtcleDiam(:,cnt2)),cnt2);%-...
%                 median(prtcleDiam(~isnan(prtcleDiam(:,cnt2)),cnt2));
            if ~isempty(testDist) && numConc(cnt2) >= cutOffNumConc
                if exist('smplngcutOffNumConc','var')
                    testDist = generateRandomSample(testDist,smplngcutOffNumConc);
                end
                ksresult = kstest2(dist,testDist,'alpha',alphaVal); 
                KSMatrixCondConc(cnt,cnt2) = ksresult;
%             else 
%                 ksresult = 0.5;
            end  
        end
    end
end

% Removing all nan value holograms
KSMatrixCondConc(isnan(KSMatrixCondConc))=1.2;


end
% -------------------------------------------------------------------------
