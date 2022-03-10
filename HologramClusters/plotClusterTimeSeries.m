function plotClusterTimeSeries(cldProps)
global folderHeader

colors = [0.8000    0.8000    0.8000];
colorIndctr = ones(numel(cldProps.holoTime),1) * colors ;
sz = 5;

customCmap = [1,1,1;0,0.447,0.741;0.635,0.078,0.184;0.466,0.674,0.188;...
    0.850,0.325,0.098;0.494,0.184,0.556;0.301,0.745,0.933;...
    0.929,0.694,0.125;0 0 1; 0 1 0];

filelocation = fullfile(folderHeader,'DBSCANResults');
filedetailsClstr = dir(fullfile(filelocation,'*.mat'));
filedetailsprtcleDiam = dir(fullfile(folderHeader,'*.mat'));

for cnt=1:length(filedetailsClstr)
    if any(strfind(filedetailsClstr(cnt).name, 'clusterInfo'))
        load(fullfile(filelocation,filedetailsClstr(cnt).name))
    end  
    searchStrng = extractBetween(filedetailsClstr(cnt).name,13,27);
    for cnt2=1:length(filedetailsprtcleDiam)
        if any(strfind(filedetailsprtcleDiam(cnt2).name, ['prtcleDiam_' ...
                searchStrng{1}]))
            load(fullfile(folderHeader,filedetailsprtcleDiam(cnt2).name))
        end
    end
    for cnt2 = 1:cluster.nClusters
        ind = cluster.clusterInfo == cnt2-1;
        clstrTime = holotime(ind);
        for cnt3 = 1:numel(clstrTime)
            colorIndctr(cldProps.holoTime== clstrTime(cnt3),:) = customCmap(cnt2,:);
        end
    end


end




figure
yyaxis left
sctrPlt = scatter(cldProps.holoTime,cldProps.concL,sz,colorIndctr,'filled');
yyaxis right
plot(cldProps.holoTime,cldProps.GPSHoloAltitude)

end