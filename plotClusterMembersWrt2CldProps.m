% Function to plot the cluster members of a segment with respect to any two
% variables of interest

function plotClusterMembersWrt2CldProps(cldProps,var1,var2)


global folderHeader fileHeader

if ~exist(fullfile(folderHeader,'ClstrSegmentPlots'),'dir')
    mkdir(fullfile(folderHeader,'ClstrSegmentPlots'))
end

colors = [0.8000    0.8000    0.8000];
colorIndctr = ones(numel(cldProps.holoTime),1) * colors ;
sz = 20;


filelocation = fullfile(folderHeader,'DBSCANResults');
filedetailsClstr = dir(fullfile(filelocation,'*.mat'));
filedetailsprtcleDiam = dir(fullfile(folderHeader,'*.mat'));

searchStrng = fileHeader;

%  Loading the files
for cnt=1:length(filedetailsClstr)
    if any(strfind(filedetailsClstr(cnt).name, ['clusterInfo_' fileHeader]))
        load(fullfile(filelocation,filedetailsClstr(cnt).name))
    end  
end
for cnt=1:length(filedetailsprtcleDiam)
    if any(strfind(filedetailsprtcleDiam(cnt).name, ['prtcleDiam_' ...
            fileHeader] ))
        load(fullfile(folderHeader,filedetailsprtcleDiam(cnt).name))
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

filename = ['ClstWrt_' var1 '_' var2];
f = figure('units','normalized','outerposition',[0 0 1 1]);
hold on


for cnt2 = 1:cluster.nClusters
    ind = cluster.clusterInfo == cnt2-1;
    clstrTime = holotime(ind);
    ind2=nan(sum(ind),1);
    for cnt3 = 1:numel(clstrTime)
%         colorIndctr(cldProps.holoTime== clstrTime(cnt3),:) = customCmap(cnt2,:);
        ind2(cnt3) = find(cldProps.holoTime== clstrTime(cnt3)); 
    end
    sc = scatter(cldProps.(var1)(ind2),cldProps.(var2)(ind2),...
    sz,customCmap(cnt2+1,:),'filled');
end


hold off
title(['Cluster Info with ' var1 ' and ' var2 '- Altitude ' ...
    strrep(fileHeader,'_','\_')])
xlabel(var1)
ylabel(var2)
savefig([folderHeader '/ClstrSegmentPlots/'  filename '_' fileHeader '.fig'])
close(f)


end