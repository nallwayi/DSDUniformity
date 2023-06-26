% Function to plot the cluster members of a segment with respect to any two
% variables of interest
% Modified April 11,2022 to account for cfg file
% Modified July 15,2022 to distinguish holograms with threshold level
% drizzle embryo concentration
% Modified Feb 21, 2023 to add the entire segment values 


function plotClusterMembersWrt2CldProps(cldProps,var1,var2)


global cfg

if ~exist(fullfile(cfg.folderHeader,'ClstrSegmentPlots'),'dir')
    mkdir(fullfile(cfg.folderHeader,'ClstrSegmentPlots'))
end

colors = [0.8000    0.8000    0.8000];
colorIndctr = ones(numel(cldProps.holoTime),1) * colors ;
sz = 20;


filelocation = fullfile(cfg.folderHeader,[  cfg.clusteringAlgo 'Results']);
filedetailsClstr = dir(fullfile(filelocation,'*.mat'));
filedetailsprtcleDiam = dir(fullfile(cfg.folderHeader,'*.mat'));

searchStrng = cfg.fileHeader;

%  Loading the files
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
 

filename = ['ClstWrt_' var1 '_' var2];
f = figure('units','normalized','outerposition',[0 0 1 1]);
hold on


for cnt2 = 1:cluster.nClusters
    ind = cluster.clusterInfo == cnt2-1;
    clstrTime = holotime(ind);
    ind2=nan(sum(ind),1);
    ind3=nan(sum(ind),1);
    for cnt3 = 1:numel(clstrTime)
%         colorIndctr(cldProps.holoTime== clstrTime(cnt3),:) = customCmap(cnt2,:);
        ttmp = find(cldProps.holoTime== clstrTime(cnt3));
        if ismember(ttmp,drizzInd)
            ind3(cnt3) = ttmp;
        else
            ind2(cnt3) = ttmp;
        end

        
    end
    ind2(isnan(ind2))=[];
    ind3(isnan(ind3))=[];
    
    sc = scatter(cldProps.(var1)(ind2),cldProps.(var2)(ind2),...
    sz,customCmap(cnt2+1,:),'filled');
    sc2=scatter(cldProps.(var1)(ind3),cldProps.(var2)(ind3),...
    (sz+5),customCmap(cnt2+1,:),'filled');
    sc2.Marker = '^';
%     sc2.MarkerEdgeColor = 'black';
end


% Plotting the parameter for the entire segment

entireSegment = reshape(prtcleDiam,1,[]);
entireSegment(isnan(entireSegment))=[];
entireSegmentMean     = mean(entireSegment);



if strcmp(var2,'holoInterQuartileRange')
    entireSegmentIQR = iqr(entireSegment);
    scatter(entireSegmentMean,entireSegmentIQR,100,'k','filled')
elseif strcmp(var2,'holoStd')
    entireSegmentStd = std(entireSegment);
    scatter(entireSegmentMean,entireSegmentStd,100,'k','filled')
elseif strcmp(var2,'holoskewness')    
    entireSegmentSkewness = skewness(entireSegment);   
    scatter(entireSegmentMean,entireSegmentSkewness,100,'k','filled')  
elseif strcmp(var2,'holoRange') 
    entireSegmentRange = range(entireSegment);   
    scatter(entireSegmentMean,entireSegmentRange,100,'k','filled')  
elseif strcmp(var2,'holoRelDisp')
    entireSegmentRelDisp = std(entireSegment)/mean(entireSegment);
    scatter(entireSegmentMean,entireSegmentRelDisp,100,'k','filled')
end


hold off
title(['Cluster Info with ' var1 ' and ' var2 '- Altitude ' ...
    strrep(cfg.fileHeader,'_','\_')])
xlabel(var1)
ylabel(var2)
savefig([cfg.folderHeader '/ClstrSegmentPlots/'  filename '_' cfg.fileHeader '.fig'])
close(f)


end