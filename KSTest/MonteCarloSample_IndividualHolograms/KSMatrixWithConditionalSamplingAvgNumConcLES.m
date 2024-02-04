%% Functions for performing KS Test with monte carlo samples of individual
% -------------------------------------------------------------------------
% Function to do the KS test and get the KSMAtrix for conditional
% sampling of holograms
% Here the total number of particles in a hologram is reduced to 60 or
% 70 percent of its average value and then compared with each other to get
% the KSMatrix
% May 17,2023
% This function is is the modified version of 
% KSMatrixWithConditionalSamplingAvgNumConc for the SD-LES data

function KSMatrixCondConc = KSMatrixWithConditionalSamplingAvgNumConcLES...
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



if iscell(prtcleDiam)
    SDCnt = cellfun('length',prtcleDiam(1,:));

    numConc = nan(size(prtcleDiam,2),1);
    for cnt=1:size(prtcleDiam,2)
        numConc(cnt) = sum(prtcleDiam{2,cnt});
%         tmp =prtcleDiam{2,cnt};
%         tmp(tmp<1e-2) = 0;
%         try
%             tmp = tmp/min(tmp(tmp~=0));
%         end
%
%         prtcleDiam{2,cnt} = round(tmp);
    end

    % Trimming the extremes for calculating the mean value
    trimPercent = 0.25;

    numConcS = sort(numConc(numConc~=0));
    trmdnumConc = (numConcS(round(trimPercent*numel(numConc)):...
        round((1-trimPercent)*numel(numConc)) ));

    % Making the mean number concentration equivalent to binSmplgCnt
    fac = mean(trmdnumConc)/binSmplgCnt;
    trmdnumConc = trmdnumConc /fac;
    numConc     = numConc / fac ;
    for cnt=1:size(prtcleDiam,2)
        prtcleDiam{2,cnt} = round(prtcleDiam{2,cnt} /fac); 
    end
    %     if strcmp(microphysicsScheme,'sd')
    %         numConc = numConc/min(numConc);
%         numConc(numConc <1e3) = NaN;
%     end
else
    % Setting the cutoff to 10 um
    prtcleDiam(prtcleDiam<10e-6) =nan;
    numConc = nan(size(prtcleDiam,2),1);
    for cnt=1:size(prtcleDiam,2)
        numConc(cnt) = sum(~isnan(prtcleDiam(:,cnt)));
    end

end



if ncCutoff<1
    if iscell(prtcleDiam) && size(prtcleDiam,1) >1
        cutOffNumConc = round(ncCutoff*mean(trmdnumConc));
%         cutOffNumConc = round(ncCutoff*nanmean(numConc));
    else
        cutOffNumConc = round(ncCutoff * nanmean(numConc)); %percent cutoff determination
    end
else
    cutOffNumConc = ncCutoff;
end

if smplgCutoff ~= -9999
    if iscell(prtcleDiam) && size(prtcleDiam,1) >1
        smplngcutOffNumConc = round(smplgCutoff*mean(trmdnumConc));
%         smplngcutOffNumConc = round(smplgCutoff*nanmean(numConc));
    else
        smplngcutOffNumConc = round(smplgCutoff * nanmean(numConc));
    end
else
    smplngcutOffNumConc=[];
end
cntr=1;

SDcutOff = 10;

for cnt = ksInd(1): ksInd(2)
    if iscell(prtcleDiam)
        if size(prtcleDiam,1) >1
            dist=[];mult1=[];
            if SDCnt(cnt) > SDcutOff
                dist = prtcleDiam{1,cnt};
                mult1 = prtcleDiam{2,cnt};
            end
%             dist(isnan(dist)) = [];
        else
            dist    = prtcleDiam{1,cnt};
            dist(isnan(dist)) = [];
        end
    else
        dist    = prtcleDiam(~isnan(prtcleDiam(:,cnt)),cnt);%-...
        %         median(prtcleDiam(~isnan(prtcleDiam(:,cnt)),cnt));
    end
    
    if ~isempty(dist) && numConc(cnt) >= cutOffNumConc
        if ~isempty(smplngcutOffNumConc)
            if iscell(prtcleDiam) && size(prtcleDiam,1) >1
                sel = randi(sum(mult1),cutOffNumConc,1);
                [mult1,~] = histcounts(sel,[0 cumsum(mult1)]);
            else
                dist = generateRandomSample(dist,smplngcutOffNumConc);
            end

        end
        for cnt2 = 1:size(prtcleDiam,2)
            if iscell(prtcleDiam)
                if size(prtcleDiam,1) >1
                    testDist=[];mult2=[];
                    if SDCnt(cnt2) > SDcutOff
                        testDist = prtcleDiam{1,cnt2};
                        mult2 = prtcleDiam{2,cnt2};
                    end
%                     testDist(isnan(dist)) = [];
                else
                    testDist =  prtcleDiam{1,cnt2};
                    testDist(isnan(testDist)) = [];
                end
            else
                testDist = prtcleDiam(~isnan(prtcleDiam(:,cnt2)),cnt2);%-...
                %                 median(prtcleDiam(~isnan(prtcleDiam(:,cnt2)),cnt2));
            end
            
            if ~isempty(testDist) && numConc(cnt2) >= cutOffNumConc
                if ~isempty(smplngcutOffNumConc)
                    if iscell(prtcleDiam) && size(prtcleDiam,1) >1
                        sel = randi(sum(mult2),cutOffNumConc,1);
                        [mult2,~] = histcounts(sel,[0 cumsum(mult2)]);
                    else
                        testDist = generateRandomSample(testDist,smplngcutOffNumConc);
                    end
                end
                [ksresult, pValue, KSstatistic] = kstest2LES(dist,testDist,mult1,mult2,binnedData,'alpha',alphaVal);
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
