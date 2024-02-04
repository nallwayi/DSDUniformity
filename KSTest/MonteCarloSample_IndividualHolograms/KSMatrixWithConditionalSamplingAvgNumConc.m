%% Functions for performing KS Test with monte carlo samples of individual
% -------------------------------------------------------------------------
% Function to do the KS test and get the KSMAtrix for conditional
% sampling of holograms
% Here the total number of particles in a hologram is reduced to 60 or
% 70 percent of its average value and then compared with each other to get
% the KSMatrix


% Modified April 11,2022 to account for cfg file
% Modified May 15, 2023 to process KSmatrix in parts
% Modified May 16,2023 to account for cell type for prtcleDiam
% Modified Nov 21,2023 to add ksmethod
function KSMatrixCondConc = KSMatrixWithConditionalSamplingAvgNumConc...
    (ncCutoff,alphaVal,smplgCutoff,prtcleDiam,scale,nRows,rowInd,ksmethod)



% Reshaping to the desireed scale
% prtcleDiam= reshape(prtcleDiam,[],size(prtcleDiam,2)/scale);


if ~isempty(nRows)
    KSMatrixCondConc  = nan(nRows,size(prtcleDiam,2));
    ksInd             = [rowInd rowInd+nRows-1];
else
    KSMatrixCondConc  = nan(size(prtcleDiam,2));
    ksInd             = [1 size(prtcleDiam,2)];
end



if iscell(prtcleDiam)
    numConc = cellfun('length',prtcleDiam);
else
    numConc = nan(size(prtcleDiam,2),1);
    for cnt=1:size(prtcleDiam,2)
        numConc(cnt) = sum(~isnan(prtcleDiam(:,cnt)));
    end
    % Setting the cutoff to 10 um
    prtcleDiam(prtcleDiam<10e-6) =nan;
end

if ncCutoff<1
    cutOffNumConc = round(ncCutoff * mean(numConc)); %percent cutoff determination
else
    cutOffNumConc = ncCutoff;
end
if smplgCutoff ~= -9999
    smplngcutOffNumConc = round(smplgCutoff * mean(numConc));
end
cntr=1;


for cnt = ksInd(1): ksInd(2)
    if iscell(prtcleDiam)
        dist    = prtcleDiam{1,cnt};
        dist(isnan(dist)) = []; 
    else
        dist    = prtcleDiam(~isnan(prtcleDiam(:,cnt)),cnt);%-...
        %         median(prtcleDiam(~isnan(prtcleDiam(:,cnt)),cnt));
    end
    
    if ~isempty(dist) && numConc(cnt) >= cutOffNumConc
        if exist('smplngcutOffNumConc','var')
            dist = generateRandomSample(dist,smplngcutOffNumConc);
        end
        for cnt2 = 1:size(prtcleDiam,2)
            if iscell(prtcleDiam)
                testDist =  prtcleDiam{1,cnt2};
                testDist(isnan(testDist)) = [];
            else
                testDist = prtcleDiam(~isnan(prtcleDiam(:,cnt2)),cnt2);%-...
                %                 median(prtcleDiam(~isnan(prtcleDiam(:,cnt2)),cnt2));
            end
            
            if ~isempty(testDist) && numConc(cnt2) >= cutOffNumConc
                if exist('smplngcutOffNumConc','var')
                    testDist = generateRandomSample(testDist,smplngcutOffNumConc);
                end
                [ksresult, pValue, KSstatistic] = kstest2(dist,testDist,'alpha',alphaVal);
                if strcmp(ksmethod,'h')
                    KSMatrixCondConc(cntr,cnt2) = ksresult;
                else
                    KSMatrixCondConc(cntr,cnt2) = 1-pValue;
                end
                %             else
                %                 ksresult = 0.5;
            end
        end
    end
    cntr = cntr+1;
    
end

% Removing all nan value holograms
KSMatrixCondConc(isnan(KSMatrixCondConc))=1.2;


end
% -------------------------------------------------------------------------
