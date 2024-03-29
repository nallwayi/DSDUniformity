% Function to get the average cluster member dsd parameter values
% Feb 22, 2023


function getClusterPDFProps(cldProps)

global cfg

if ~exist(fullfile(cfg.folderHeader,'ClusterPDFProps'),'dir')
    mkdir(fullfile(cfg.folderHeader,'ClusterPDFProps'))
end

colors = [0.8000    0.8000    0.8000];
colorIndctr = ones(numel(cldProps.holoTime),1) * colors ;
sz = 20;


filelocation = fullfile(cfg.folderHeader,[  cfg.clusteringAlgo 'Results']);
filedetailsClstr = dir(fullfile(filelocation,'*.mat'));
filedetailsprtcleDiam = dir(fullfile(cfg.folderHeader,'*.mat'));

searchStrng = cfg.fileHeader;

% Loading the files
for cnt=1:length(filedetailsClstr)
    if any(strfind(filedetailsClstr(cnt).name, ['clusterInfo_' cfg.fileHeader]))
        load(fullfile(filelocation,filedetailsClstr(cnt).name))
    end
end
for cnt=1:length(filedetailsprtcleDiam)
    if any(strfind(filedetailsprtcleDiam(cnt).name, ['prtcleDiam_' ...
            cfg.fileHeader] ))
        load(fullfile(cfg.folderHeader,filedetailsprtcleDiam(cnt).name))
    end
end

customCmap = [1,1,1;0,0.447,0.741;0.635,0.078,0.184;0.466,0.674,0.188;...
    0.850,0.325,0.098;0.494,0.184,0.556;0.301,0.745,0.933;...
    0.929,0.694,0.125;0 0 1; 0 1 0];

% Creating additional customCmaps for greater cluster sizes
if cluster.nClusters > size(customCmap,1)-1
    temp = customCmap;
    for cnt = 1:ceil(cluster.nClusters/9)-1
        customCmap = [customCmap;temp(2:end,:)];
    end
end



% Segmentiing regions with onset of drizzzle
cutoffDWC = 0.02; %gm/cm^3
drizzInd = find(cldProps.holoDrizzle > cutoffDWC);
clusteredInd=[];
for cnt = 1:cluster.nClusters
    ind = find(cluster.clusterInfo == cnt-1);
    clusteredInd = [clusteredInd;ind'];
    clstrTime = holotime(ind);
    ind2=nan(sum(ind),1);
    ind3=nan(sum(ind),1);
    for cnt2 = 1:numel(clstrTime)
        colorIndctr(cldProps.holoTime== clstrTime(cnt2),:) = customCmap(cnt,:);
        ttmp = find(cldProps.holoTime== clstrTime(cnt2));
        if ismember(ttmp,drizzInd)
            ind3(cnt2) = ttmp;
        else
            ind2(cnt2) = ttmp;
        end
        
        
    end
    ind2(isnan(ind2))=[];
    ind3(isnan(ind3))=[];
    
    
    vars = cldProps.Properties.VariableNames;
    fnames = {'holoMean';'holoInterQuartileRange'; 'holoStd'; 'holoskewness'; 'holoRange'; 'holoRelDisp'};
    for cnt3=1:length(fnames)
        clstrPDFProps.(fnames{cnt3})(cnt,1) = mean(cldProps.(vars{strcmp(vars,fnames{cnt3})})([ind2 ;ind3]));
    end
end

% Calculating values for the entire segment that satisfy the 70 percent
% threshold
prtcleDiam(prtcleDiam<10e-6) =nan;
cutOff = round(0.7*sum(~isnan(reshape(prtcleDiam,1,[])))/size(prtcleDiam,2));
% Find the holograms above the 70 percent threshold

lessThanThresh=[];
for cnt=1:size(prtcleDiam,2)
    
    prtclDiamArray = prtcleDiam(:,cnt);
    prtclDiamArray(isnan(prtclDiamArray)) = [];
    prtclDiamArray(prtclDiamArray < 10e-6) = [];
    
    if length(prtclDiamArray) < cutOff
        lessThanThresh = [lessThanThresh; cnt];
    end
    
end

unclusteredInd = setdiff(find(cluster.clusterInfo ==-1),lessThanThresh);
greaterThanThresh  = setdiff(1:size(prtcleDiam,2),lessThanThresh);

entireSegment = reshape(prtcleDiam(:,greaterThanThresh),1,[]);
entireSegment(isnan(entireSegment))=[];
entireSegmentMean     = mean(entireSegment)*1e6;
clstrPDFProps.holoMean(end+1,1) = mean(entireSegment);
clstrPDFProps.holoInterQuartileRange(end+1,1) = iqr(entireSegment);
clstrPDFProps.holoStd(end+1,1) = std(entireSegment);
clstrPDFProps.holoskewness(end+1,1) = skewness(entireSegment);
clstrPDFProps.holoRange(end+1,1) = range(entireSegment); 
clstrPDFProps.holoRelDisp(end+1,1) = std(entireSegment)/mean(entireSegment);

clstrPDFProps = struct2table( clstrPDFProps );




clustrFrac.totalHolograms = size(prtcleDiam,2);
clustrFrac.clusteredHolograms = length(clusteredInd);
clustrFrac.unClusterdHolograms = length(unclusteredInd);
clustrFrac.belowThreshHolograms = length(lessThanThresh);
clustrFrac.classifiedFraction = length(clusteredInd)/...
    (length(clusteredInd) + length(unclusteredInd));
clustrFrac.threshEliminatedFraction = length(lessThanThresh)/...
    size(prtcleDiam,2);

%sanity check
if (length(clusteredInd) + length(unclusteredInd) + length(lessThanThresh))...
        ~=  size(prtcleDiam,2)
    warning('Calc error')
    clustrFrac.calcError = true;
end
save([cfg.folderHeader '/ClusterPDFProps/clstrPDFProps_' cfg.fileHeader '.mat'],'clstrPDFProps','clustrFrac');

end