% Function to get the time series of clusters from the segment with 
% differnt quantities
% 2022.02.14
% Modified April 11,2022 to account for cfg file

function plotClusterTimeSeriesForSegments(cldProps)
global cfg

if ~exist(fullfile(cfg.folderHeader,'ClstrSegmentPlots'),'dir')
    mkdir(fullfile(cfg.folderHeader,'ClstrSegmentPlots'))
end

colors = [0.8000    0.8000    0.8000];
colorIndctr = ones(numel(cldProps.holoTime),1) * colors ;
sz = 20;


filelocation = fullfile(cfg.folderHeader,[cfg.clusteringAlgo 'Results']);
filedetailsClstr = dir(fullfile(filelocation,'*.mat'));
filedetailsprtcleDiam = dir(fullfile(cfg.folderHeader,'*.mat'));

searchStrng = cfg.fileHeader;

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




if find(cldProps.holoTime == holotime(end))+1000 > size(cldProps.holoTime,1)
    pltRnge = find(cldProps.holoTime == holotime(1))-1000:...
        size(cldProps.holoTime,1);
elseif find(cldProps.holoTime == holotime(1))-1000 <1
    pltRnge = 1:find(cldProps.holoTime == holotime(end))+1000;
else
    pltRnge = find(cldProps.holoTime == holotime(1))-1000:...
        find(cldProps.holoTime == holotime(end))+1000;
end
altRnge = [str2num(extractBefore(cfg.fileHeader,'_'))-100 ...
    str2num(extractBefore(cfg.fileHeader,'_'))+100];

filename = 'ClstrTSWtNumConc';
f = figure('units','normalized','outerposition',[0 0 1 1]);
yyaxis left
sctrPlt = scatter(cldProps.holoTime(pltRnge),cldProps.concL(pltRnge),...
    sz,colorIndctr(pltRnge,:),'filled');
yyaxis right
plot(cldProps.holoTime(pltRnge),cldProps.GPSHoloAltitude(pltRnge))
ylim(altRnge)
xlim([cldProps.holoTime(pltRnge(1)) cldProps.holoTime(pltRnge(end))])
yyaxis left
hold on


for cnt2 = 1:cluster.nClusters
    ind = cluster.clusterInfo == cnt2-1;
    clstrTime = holotime(ind);
    ind2=nan(sum(ind),1);
    for cnt3 = 1:numel(clstrTime)
%         colorIndctr(cldProps.holoTime== clstrTime(cnt3),:) = customCmap(cnt2,:);
        ind2(cnt3) = find(cldProps.holoTime== clstrTime(cnt3)); 
    end
    sc = scatter(cldProps.holoTime(ind2),cldProps.concL(ind2),...
    sz,customCmap(cnt2+1,:),'filled');
end



hold off
title(['Cluster Time series with Number concentration- Altitude ' ...
    strrep(cfg.fileHeader,'_','\_')])
xlabel('Second of day (s)')
ylabel('Number Concentration (#/cm^3)')
yyaxis right
ylabel('Altitude (m)')
savefig([cfg.folderHeader '/ClstrSegmentPlots/'  filename '_' cfg.fileHeader '.fig'])
close(f)

% With LWC
filename = 'ClstrTSWtLWC';
f = figure('units','normalized','outerposition',[0 0 1 1]);
yyaxis left
sctrPlt = scatter(cldProps.holoTime(pltRnge),cldProps.LWC(pltRnge),...
    sz,colorIndctr(pltRnge,:),'filled');
yyaxis right
plot(cldProps.holoTime(pltRnge),cldProps.GPSHoloAltitude(pltRnge))
ylim(altRnge)
xlim([cldProps.holoTime(pltRnge(1)) cldProps.holoTime(pltRnge(end))])
yyaxis left
hold on


for cnt2 = 1:cluster.nClusters
    ind = cluster.clusterInfo == cnt2-1;
    clstrTime = holotime(ind);
    ind2=nan(sum(ind),1);
    for cnt3 = 1:numel(clstrTime)
%         colorIndctr(cldProps.holoTime== clstrTime(cnt3),:) = customCmap(cnt2,:);
        ind2(cnt3) = find(cldProps.holoTime== clstrTime(cnt3)); 
    end
    sc = scatter(cldProps.holoTime(ind2),cldProps.LWC(ind2),...
    sz,customCmap(cnt2+1,:),'filled');
end



hold off
title(['Cluster Time series with Liquid Water Content- Altitude ' ...
    strrep(cfg.fileHeader,'_','\_')])
xlabel('Second of day (s)')
ylabel('Liquid Water Content (g/m^3)')
yyaxis right
ylabel('Altitude (m)')    
savefig([cfg.folderHeader '/ClstrSegmentPlots/'  filename '_' cfg.fileHeader '.fig'])

close(f)




% Plot for vertical velocity

filename = 'ClstrTSWtVel_W';
f = figure('units','normalized','outerposition',[0 0 1 1]);
yyaxis left
sctrPlt = scatter(cldProps.holoTime(pltRnge),cldProps.velocity_w(pltRnge),...
    sz,colorIndctr(pltRnge,:),'filled');
yyaxis right
plot(cldProps.holoTime(pltRnge),cldProps.GPSHoloAltitude(pltRnge))
ylim(altRnge)
xlim([cldProps.holoTime(pltRnge(1)) cldProps.holoTime(pltRnge(end))])
yyaxis left
hold on


for cnt2 = 1:cluster.nClusters
    ind = cluster.clusterInfo == cnt2-1;
    clstrTime = holotime(ind);
    ind2=nan(sum(ind),1);
    for cnt3 = 1:numel(clstrTime)
%         colorIndctr(cldProps.holoTime== clstrTime(cnt3),:) = customCmap(cnt2,:);
        ind2(cnt3) = find(cldProps.holoTime== clstrTime(cnt3)); 
    end
    sc = scatter(cldProps.holoTime(ind2),cldProps.velocity_w(ind2),...
    sz,customCmap(cnt2+1,:),'filled');
end



hold off
title(['Cluster Time series with Vertical velocity- Altitude ' ...
    strrep(cfg.fileHeader,'_','\_')])
xlabel('Second of day (s)')
ylabel('Vertical velocity (m/s)')
yyaxis right
ylabel('Altitude (m)')    
savefig([cfg.folderHeader '/ClstrSegmentPlots/'  filename '_' cfg.fileHeader '.fig'])

close(f)

% Plot for drizzle

filename = 'ClstrTSWtdrizzleLWC';
f = figure('units','normalized','outerposition',[0 0 1 1]);
yyaxis left
sctrPlt = scatter(cldProps.holoTime(pltRnge),cldProps.drizzleLWC(pltRnge),...
    sz,colorIndctr(pltRnge,:),'filled');
yyaxis right
plot(cldProps.holoTime(pltRnge),cldProps.GPSHoloAltitude(pltRnge))
ylim(altRnge)
xlim([cldProps.holoTime(pltRnge(1)) cldProps.holoTime(pltRnge(end))])
yyaxis left
hold on


for cnt2 = 1:cluster.nClusters
    ind = cluster.clusterInfo == cnt2-1;
    clstrTime = holotime(ind);
    ind2=nan(sum(ind),1);
    for cnt3 = 1:numel(clstrTime)
%         colorIndctr(cldProps.holoTime== clstrTime(cnt3),:) = customCmap(cnt2,:);
        ind2(cnt3) = find(cldProps.holoTime== clstrTime(cnt3)); 
    end
    sc = scatter(cldProps.holoTime(ind2),cldProps.drizzleLWC(ind2),...
    sz,customCmap(cnt2+1,:),'filled');
end



hold off
title(['Cluster Time series with Drizzle LWC- Altitude ' ...
    strrep(cfg.fileHeader,'_','\_')])
xlabel('Second of day (s)')
ylabel('drizzleLWC(g/m^3)')
yyaxis right
ylabel('Altitude (m)')    
savefig([cfg.folderHeader '/ClstrSegmentPlots/'  filename '_' cfg.fileHeader '.fig'])

close(f)

% pltRnge = find(cldProps.holoTime == holotime(1))-500:...
%     find(cldProps.holoTime == holotime(end))+500;
% altRnge = [str2num(extractBefore(cfg.fileHeader,'_'))-100 ...
%     str2num(extractBefore(cfg.fileHeader,'_'))+100];
% figure
% yyaxis left
% sctrPlt = scatter(cldProps.Vals(1,pltRnge),cldProps.Vals(3,pltRnge),...
%     sz,colorIndctr(pltRnge,:),'filled');
% yyaxis right
% plot(cldProps.Vals(1,pltRnge),cldProps.Vals(2,pltRnge))
% ylim(altRnge)
% xlim([cldProps.Vals(1,pltRnge(1)) cldProps.Vals(1,pltRnge(end))])
end
