%% Functions for performing KS Test with monte carlo samples of individual
% -------------------------------------------------------------------------
% Function to do the KS test and get the KSMAtrix for conditional
% sampling of holograms
% Here the total number of particles in a hologram is reduced to 60 or
% 70 percent of its average value and then compared with each other to get
% the KSMatrix
% Feb 04, 2024
% This function is is the modified version of
% KSMatrixWithConditionalSamplingAvgNumConc and
% KSMatrixWithConditionalSamplingAvgNumConcLES
% for the SD-LES-SD data
function KSMatrixCondConc = KSMatrixWithConditionalSamplingAvgNumConcLESBIN...
    (ncCutoff,alphaVal,smplgCutoff,prtcleDiam,scale,nRows,rowInd,binnedData,binSmplgCnt,ksmethod)


% Reshaping to the desireed scale
% prtcleDiam= reshape(prtcleDiam,[],size(prtcleDiam,2)/scale);


if ~isempty(nRows)
    KSMatrixCondConc  = nan(nRows,size(prtcleDiam,2));
    ksInd             = [rowInd rowInd+nRows-1];
else
    KSMatrixCondConc  = nan(size(prtcleDiam,2));
    ksInd             = [1 size(prtcleDiam,2)];
end




% Normalization part

multCnt = nan(size(prtcleDiam,2),1);
for cnt=1:size(prtcleDiam,2)
    multCnt(cnt) = sum(prtcleDiam{2,cnt});
end
% Trimming the extremes for calculating the mean value
trimPercent = 0.25;
numConc = multCnt;

multCnt = sort(multCnt(multCnt~=0));
trmdMultCnt = (multCnt(round(trimPercent*numel(multCnt)):...
    round((1-trimPercent)*numel(multCnt)) ));

% Making the mean number concentration equivalent to binSmplgCnt
if binSmplgCnt>0
    fac = mean(trmdMultCnt)/binSmplgCnt;
else
    fac = 1;%mean(trmdMultCnt)/1000;
end
trmdMultCnt = trmdMultCnt /fac;
numConc     = numConc / fac ;
for cnt=1:size(prtcleDiam,2)
    prtcleDiam{2,cnt} = round(prtcleDiam{2,cnt} /fac);
end



if ncCutoff<1
    cutOffNumConc = round(ncCutoff*nanmean(numConc));
else
    cutOffNumConc = ncCutoff;
end

if smplgCutoff ~= -9999
    smplngcutOffNumConc = round(smplgCutoff*nanmean(numConc));
else
    smplngcutOffNumConc=[];
end

cntr=1;


for cnt = ksInd(1): ksInd(2)
    if size(prtcleDiam,1) >1
        dist=[];dist_mult=[];dist_sdcnt=[];
        dist = prtcleDiam{1,cnt};
        dist_mult = prtcleDiam{2,cnt};        
        if binSmplgCnt>0
            dist_sdcnt = sum(dist_mult);
        else
            dist_sdcnt = sum(prtcleDiam{2,cnt}>0);
        end
    else
        dist    = prtcleDiam{1,cnt};
        dist(isnan(dist)) = [];
    end

    if ~isempty(dist) && numConc(cnt) >= cutOffNumConc
        if ~isempty(smplngcutOffNumConc)
            if iscell(prtcleDiam) && size(prtcleDiam,1) >1
                sel = randi(sum(dist_mult),cutOffNumConc,1);
                [dist_mult,~] = histcounts(sel,[0 cumsum(dist_mult)]);
                dist_sdcnt = sum(dist_mult);
            else
                dist = generateRandomSample(dist,smplngcutOffNumConc);
            end
        end
        for cnt2 = 1:size(prtcleDiam,2)
            if size(prtcleDiam,1) >1
                testDist=[];testDist_mult=[];testDist_sdcnt=[];
                    testDist = prtcleDiam{1,cnt2};
                    testDist_mult = prtcleDiam{2,cnt2};                    
                    if binSmplgCnt>0
                        testDist_sdcnt = sum(testDist_mult);
                    else
                        testDist_sdcnt = sum(prtcleDiam{2,cnt2}>0);
                    end
            else
                testDist =  prtcleDiam{1,cnt2};
                testDist(isnan(testDist)) = [];
            end

            if ~isempty(testDist) && numConc(cnt2) >= cutOffNumConc
                if ~isempty(smplngcutOffNumConc)
                    if iscell(prtcleDiam) && size(prtcleDiam,1) >1
                        sel = randi(sum(testDist_mult),cutOffNumConc,1);
                        [testDist_mult,~] = histcounts(sel,[0 cumsum(testDist_mult)]);
                        testDist_sdcnt = sum(testDist_mult);
                    else
                        testDist = generateRandomSample(testDist,smplngcutOffNumConc);
                    end
                end
                [ksresult, pValue, KSstatistic] = kstest2LESSD...
                    (dist,testDist,dist_mult,testDist_mult,dist_sdcnt,testDist_sdcnt,binnedData,'alpha',alphaVal);
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

