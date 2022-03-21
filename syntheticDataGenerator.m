%%
% Function to create a synthetic dataset for testing the dsd-uniformity
function [prtcleDiam,syntheticDataInfo] = syntheticDataGenerator(range,meanGaussian,type)

noHolograms = 3000;
range = [0 3000]; % Defining the range
meanGaussian = 300; % Defining the mean

noPrtcles = nan(noHolograms,1);
for cnt = 1:noHolograms
    noPrtcles(cnt) = rndmPrtcleCntSelecter(meanGaussian,range);
end
f = figure;histogram(noPrtcles);
title('Hist for Number of Particles')
xlabel('Number of particles')
% savefig('data_kstest\noPrtclesHist')
% close(f)

noClusters = 3;
gammaParamCluster = [40 0.6;60 0.5;80 0.4];
% gammaMeanSpace  = [30 31];
% gammaShapeSpace = [60 40];
% gammaScaleSpace = gammaMeanSpace./gammaShapeSpace;
% gammaParamSpace = [gammaShapeSpace gammaScaleSpace];

gammaParamSpace = [30 100 30 50];


f=figure;
for cnt =1:noClusters
    x = gamrnd(gammaParamCluster(cnt,1),gammaParamCluster(cnt,2),...
        1e4,1);

    histogram(x)
    hold on
end
title('Hist for differnt gamma clusters')
xlabel('Diameter (\mum)')
% savefig('data_kstest\clstrsHist')
% close(f)


tmp = noHolograms;
noClustrElmnts = nan(noClusters+1,1);
if strcmp(type,'noise')
   noClustrElmnts(end) =  randi([ceil(tmp/2) ceil(0.7*tmp)]);
   tmp  = noHolograms- noClustrElmnts(end);
else
    noClustrElmnts(end) =  randi([ceil(0.1*tmp) ceil(0.3*tmp)]);
    tmp  = noHolograms- noClustrElmnts(end);
end
for cnt =1:noClusters-1
    noClustrElmnts(cnt) = randi([1 tmp-ceil(0.1*tmp)]);
    tmp = noHolograms-sum(noClustrElmnts(1:cnt))-noClustrElmnts(end);
end

    noClustrElmnts(end-1) = noHolograms-nansum(noClustrElmnts);


Cntr = 1;
gammaParams = nan(noHolograms,2);
for cnt = 1:numel(noClustrElmnts)
    for cnt2 = 1:noClustrElmnts(cnt)
        if Cntr <= sum(noClustrElmnts(1:end-1))
            gammaParams(Cntr,:) = gammaParamCluster(cnt,:);
        else
            tmp1 = gammaParamSpace(1):0.1:gammaParamSpace(2);
            tmp2 = gammaParamSpace(3):0.1:gammaParamSpace(4);
            gammaParams(Cntr,1) = tmp1(randi([1 numel(tmp1)]));
            tmp3 = tmp2(randi([1 numel(tmp2)]));
            gammaParams(Cntr,2) = tmp3/gammaParams(Cntr,1);
        end
        Cntr = Cntr+1;
    end
end

rndInd = randperm(noHolograms);
prtcleDiam = nan(max(noPrtcles),noHolograms);
for cnt =1:noHolograms
    prtcleDiam(1:noPrtcles(cnt),rndInd(cnt)) = ...
        gamrnd(gammaParams(cnt,1),gammaParams(cnt,2),...
        noPrtcles(cnt),1);
end


prtcleDiam = prtcleDiam*1e-6;

syntheticDataInfo.noHolograms           = noHolograms;
syntheticDataInfo.noPrtcles             = noPrtcles;
syntheticDataInfo.gammaParamCluster     = gammaParamCluster;
syntheticDataInfo.gammaParamSpace       = gammaParamSpace;
syntheticDataInfo.nPrtclesMeanGaussian 	= meanGaussian;
syntheticDataInfo.nPrtclesRange         = range;
syntheticDataInfo.noClusters            = noClusters;
syntheticDataInfo.noClustrElmnts        = noClustrElmnts(1:end-1);
syntheticDataInfo.noNoiseElmnts         = noClustrElmnts(end);
syntheticDataInfo.rndInd                = rndInd;
syntheticDataInfo.gammaParams           = gammaParams;
end

% Function to geneerate a random count for the number of particles in a  
% hologram. The histogram of the number of particles is assumed gaussian


function noPrtcles =rndmPrtcleCntSelecter(meanGaussian,range)
noPrtcles = -1;
while noPrtcles<0
    noPrtcles = round(normrnd(meanGaussian,round((range(2)-range(1))/6)));
end
end