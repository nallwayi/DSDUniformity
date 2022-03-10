% Function to complie all the functions to visualize all the information
% about the clusters of a segment
% 2022.03.03

function clusterVisualization(cldProps)
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



end