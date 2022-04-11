%% Scale and Shape parameters of clusters

% -------------------------------------------------------------------------
% Sept 22, 2021
% Function to get the sclae and shape parameter of a cluster
% Modified April 11,2022 to account for cfg file

function getGammaFitparamsCluster(prtcleDiam,cluster,customCmap,clstrParamsNames)
global cfg

holoClusters = cluster.holoClusters;

% 
% f=figure('Name','Gammafit','units','normalized','outerposition',[0 0 1 1])
% subplot(1,2,1)
im2 = nexttile;

scale = nan(cluster.nClusters+2,size(prtcleDiam,2));
shape = nan(cluster.nClusters+2,size(prtcleDiam,2));
% scale = nan(cluster.nClusters,size(holoClusters,2));
% shape = nan(cluster.nClusters,size(holoClusters,2));
for cnt =1:size(holoClusters,1)
    clusterHoloId = holoClusters(cnt,~isnan(holoClusters(cnt,:)));
%     scale = [];
%     shape = [];

	for cnt2 = 1:numel(clusterHoloId)
        [y,x] = ecdf(prtcleDiam(~isnan(prtcleDiam(:,clusterHoloId(cnt2))),clusterHoloId(cnt2)));
        [scale(cnt,cnt2),shape(cnt,cnt2)]=gammacdf(x*1e6,y,[]);
	end
    
   P = scatter(scale(cnt,:),shape(cnt,:),'filled','MarkerFaceAlpha',1);
   if cnt+1 <= size(customCmap,1)
       P.MarkerFaceColor = customCmap(cnt+1,:);
   end
   hold on
   mshape(cnt) = nanmedian(shape(cnt,:));
   mscale(cnt) = nanmedian(scale(cnt,:));


	leg(cnt) = ...
        convertCharsToStrings(['Cluster' num2str(cnt)]);
	c(cnt,:) = get(P,'CData');
end

% Determining the cutoff number conc
numConc = nan(size(prtcleDiam,2),1);
for cnt=1:size(prtcleDiam,2)
    numConc(cnt) = sum(~isnan(prtcleDiam(:,cnt)));
end
cutOffNumConc     = round(0.7 * mean(numConc)); %percent cutoff determination

% Fit for the data from holograms part of no clusters
tmp = reshape(holoClusters,1,[]);
tmp = tmp(~isnan(tmp));
NoClusterHoloId = setdiff(1:size(prtcleDiam,2),tmp);

% Removing the holograms that do not meet the cutoff of 70 percent
tmp2=[];
for cnt2 = 1:numel(NoClusterHoloId)
     if sum(~isnan(prtcleDiam(:,NoClusterHoloId(cnt2)))) < ...
             cutOffNumConc
         tmp2 = [tmp2;NoClusterHoloId(cnt2)] ;
     end
end
NoClusterHoloId = setdiff(NoClusterHoloId,tmp2);

for cnt2 = 1:numel(NoClusterHoloId)
	[y,x] = ecdf(prtcleDiam(~isnan(prtcleDiam(:,NoClusterHoloId(cnt2))),...
        NoClusterHoloId(cnt2)));
	[scale(end-1,cnt2),shape(end-1,cnt2)]=gammacdf(x*1e6,y,[]);    
end
P = scatter(scale(end-1,:),shape(end-1,:),'filled','MarkerFaceAlpha',1);
mshape(end+1) = nanmedian(shape(end-1,:));
mscale(end+1) = nanmedian(scale(end-1,:));
hold on
leg(end+1) = ["Not Cluster"];
c(end+1,:) = get(P,'CData');

% Fit for the data from entire segment


% EntireSedId = union(NoClusterHoloId,reshape(holoClusters,1,[]));
% EntireSedId = EntireSedId(~isnan(EntireSedId));
% for cnt2 = 1:numel(EntireSedId)
% 	[y,x] = ecdf(prtcleDiam(~isnan(prtcleDiam(:,EntireSedId(cnt2))),...
%         EntireSedId(cnt2)));
% 	[scale(end,cnt2),shape(end,cnt2)]=gammacdf(x*1e6,y,[]);
% end
% P = scatter(scale(end,:),shape(end,:),'filled','MarkerFaceAlpha',1);
% mshape(end+1) = nanmedian(shape(end,:));
% mscale(end+1) = nanmedian(scale(end,:));
% leg(end+1) = ["Entire Segment"];
% c(end+1,:) = get(P,'CData');


hold off
pbaspect([1 1 1])
title('Scale vs Shape')
xlabel('Scale')
ylabel('Shape')
xlim([0 1.5])
ylim([0 200])
legend(leg);
% plottools
filename = 'ClstrDistParams';
sgtitle([filename '_' cfg.fileHeader  clstrParamsNames ])
savefig([cfg.folderHeader '/' cfg.clusteringAlgo 'Results/'  filename '_' cfg.fileHeader  clstrParamsNames '.fig'])
close

% subplot(1,2,2)
% x = 0:0.1:60;
% for cnt=1:size(holoClusters,1)+2
% 	y = gampdf(x,mshape(cnt),mscale(cnt));
%     plot(x,y,'Color',c(cnt,:),'LineWidth',2)
%     hold on
% end
% hold off
% pbaspect([1 1 1])
% title('Median PDFs from gamma fits')
% xlabel('Diameter(/mum)')
% ylabel('PDF')
% legend(leg);

% sgtitle([plotTitle ' eps: ' num2str(cluster.eps) ...
%     ' minpnts: '  num2str(cluster.minPoints)]) 
% pause(2)
% filename = ['GammaFitwtClusters_' plotTitle '_eps_ ' num2str(cluster.eps) ...
%     ' minpnts_'  num2str(cluster.minPoints)];
% prefix = pwd;
% mkdir([prefix '/DBSCANResults/' plotTitle '/'])
% savefig([prefix '/DBSCANResults/' plotTitle '/' filename '.fig'])
% % pause(15)
% close(f);
% plottools

% Whisker plot
% f= figure('Name','BoxPlot','units','normalized','outerposition',[0 0 1 1])
% subplot(1,2,1);boxplot(scale(1:end-2,:)');xlabel('Cluster');ylabel('Scale');
% pbaspect([1 1 1]);ylim([0 1.5])
% subplot(1,2,2);boxplot(shape(1:end-2,:)');xlabel('Cluster');ylabel('Shape');
% pbaspect([1 1 1]);ylim([0 200])
% 
% 
% sgtitle([plotTitle ' eps: ' num2str(cluster.eps) ...
%     ' minpnts: '  num2str(cluster.minPoints)]) 
% pause(2)
% filename = ['BoxPlotClusters' plotTitle '_eps_ ' num2str(cluster.eps) ...
%     ' minpnts_'  num2str(cluster.minPoints)];
% prefix = pwd;
% % mkdir([prefix '/DBSCANResults/' plotTitle '/'])
% % savefig([prefix '/DBSCANResults/' plotTitle '/' filename '.fig'])
% close(f);



end

