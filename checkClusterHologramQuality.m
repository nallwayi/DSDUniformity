% Function to check the holograms for differnt identified segments 
% 
function checkClusterHologramQuality(cldProps,hologramFileLoc)
global folderHeader fileHeader


if ~exist([folderHeader '\HologramTest\Segment' fileHeader],'dir')
    mkdir([folderHeader '\HologramTest\Segment' fileHeader])
end
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



for cnt = 1:cluster.nClusters
    ind = cluster.clusterInfo == cnt-1;
    clstrTime = holotime(ind);
    rndClstrSampleTime = randsample(clstrTime,10); 
    
    rndClstrSampleHr = floor((rndClstrSampleTime)/3600);
    rndClstrSampleMn = floor((rndClstrSampleTime - rndClstrSampleHr*3600)/60);
    rndClstrSampleSc = (rndClstrSampleTime - rndClstrSampleHr*3600 - ...
        rndClstrSampleMn *60)*1e4;
    mkdir([folderHeader '\HologramTest\Segment' fileHeader '\C' num2str(cnt)])
    
    
for cnt2 = 1:numel(rndClstrSampleSc)
    file=[];
    loc=[];
    if any(strfind( ['*' rndClstrSampleTime(cnt2) '.png']))
        load(fullfile(hologramFileLoc,strfind(['*' rndClstrSampleTime(cnt2) '.png'])))
        file = fullfile(hologramFileLoc,strfind(['*' rndClstrSampleTime(cnt2) '.png']));
        loc = [folderHeader '\HologramTest\Segment' fileHeader '\C' num2str(cnt)];
        copyfile f1 loc
    end
    
end
end

end