%% Function to get the average CDF of the individual holgram ensembles

% -------------------------------------------------------------------------
% Sept 20, 2021
% Function to get the get the average CDF of the individual holgram
% ensembles

function [bincntr,ensmblCDF] = getensmblCDFs(prtcleDiam)

% Setting ensemble cutoff
ensmblNs = 1e3;

% Setting the cutoff to 10 um
prtcleDiam(prtcleDiam<10e-6) =nan;
numConc = nan(size(prtcleDiam,2),1);
for cnt=1:size(prtcleDiam,2)
    numConc(cnt) = sum(~isnan(prtcleDiam(:,cnt)));
end
cutOffNumConc     = round(0.7 * mean(numConc)); %percent cutoff determination

for cnt = 1: size(prtcleDiam,2)  
    dist    = prtcleDiam(~isnan(prtcleDiam(:,cnt)),cnt);
    if ~isempty(dist) && numConc(cnt) >= cutOffNumConc        
        for cnt2 = 1:ensmblNs
            distRnd = generateRandomSample(dist,cutOffNumConc);
            [bincntr(1,:),CDF(cnt2,:)] = getbinCDF(distRnd);
%             [y,x] = ecdf(distRnd);
%             plot(x,y);hold on
        end
        ensmblCDF(cnt,:) = nanmean(CDF);
    end
end


for cnt = 1 :size(prtcleDiam,2)
	if sum(ensmblCDF(cnt,:)) == 0
        ensmblCDF(cnt,:) = nan;
	end
end

end
% -------------------------------------------------------------------------