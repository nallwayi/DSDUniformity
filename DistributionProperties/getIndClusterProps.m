% Function to calulate the ind hologram dist properties for different
% clusters and get the box plots for the same
% Aug 24, 2023


function getIndClusterProps(cldProps)

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
    fnames = {'concL';'LWC';'velocity_w';'holoMean';'holoInterQuartileRange'; 'holoStd'; 'holoskewness'; 'holoRange'; 'holoRelDisp'};
    tmp=[];
    for cnt3=1:length(fnames)
        try
            tmp = clstrIndvPDFProps.(fnames{cnt3});
        end
        tmp.(['C' num2str(cnt)]) = (cldProps.(vars{strcmp(vars,fnames{cnt3})})([ind2 ;ind3]));
        clstrIndvPDFProps.(fnames{cnt3}) = tmp;
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

ttmp=[];
for cnt=1:numel(unclusteredInd);
    ttmp(cnt) = find(cldProps.holoTime== holotime(unclusteredInd(cnt)));
end

for cnt=1:length(fnames)
    clstrIndvPDFProps.(fnames{cnt}).uncls=  (cldProps.(vars{strcmp(vars,fnames{cnt})})([ttmp]))
end
entireSegment = reshape(prtcleDiam(:,greaterThanThresh),1,[]);
entireSegment(isnan(entireSegment))=[];
entireSegment(entireSegment<10e-6)=[];
entireSegmentMean     = mean(entireSegment)*1e6;


%sanity check
if (length(clusteredInd) + length(unclusteredInd) + length(lessThanThresh))...
        ~=  size(prtcleDiam,2)
    warning('Calc error')
    clustrFrac.calcError = true;
end
save([cfg.folderHeader '/ClusterPDFProps/clstrIndvPDFProps_' cfg.fileHeader '.mat'],'clstrIndvPDFProps');
% plotBoxPlots(clstrIndvPDFProps,customCmap)
end



function plotBoxPlots(clstrIndvPDFProps,customCmap)
global cfg
fnames = fieldnames(clstrIndvPDFProps);
customCmap(1,:)=[];
for cnt=1:length(fnames)
    data = clstrIndvPDFProps.(fnames{cnt});

    
    data = struct2cell(data);
    clstrSz = cellfun('length',data);
    colmnSz = max(clstrSz);
    clstrIndvPDFMtrx = NaN(colmnSz,numel(data));

    for cnt2 = 1:numel(data)
        clstrIndvPDFMtrx(1:clstrSz(cnt2),cnt2) = data{cnt2};
    end

%     figure
%     boxplot(clstrIndvPDFMtrx)

    % Create a figure with custom size and background color
   f=  figure;

    % Create a box plot with customized settings and colors
    boxplot(clstrIndvPDFMtrx, 'Labels', fieldnames(clstrIndvPDFProps.(fnames{cnt})), ...
        'Notch', 'on',  ...
        'Colors', customCmap, 'Widths', 0.15,'PlotStyle','compact')
    % Add labels and title
    xlabel('Clusters', 'FontWeight', 'bold', 'FontSize', 12);
    ylabel(fnames{cnt}, 'FontWeight', 'bold', 'FontSize', 12);
    title('', 'FontWeight', 'bold', 'FontSize', 14);

    set(gca, 'FontWeight', 'bold', 'FontSize', 10);



%     % Add a legend
%     legend('Group A', 'Group B', 'Group C', 'Location', 'Best');
% 
%     % Adjust the plot box aspect ratio for better appearance
%     pbaspect([1, 1, 1]);
%     %

savefig([cfg.folderHeader '/ClusterPDFProps/clstrIndvPDFProps_' fnames{cnt} '_' cfg.fileHeader '.fig'])
exportgraphics(f,[cfg.folderHeader '/ClusterPDFProps/clstrIndvPDFProps_' fnames{cnt} '_' cfg.fileHeader '.png']);
close(f)
end
end


