% -------------------------------------------------------------------------
%  Sept 09, 2021
%  Function to get the average PDF of a hologram Clusters
%  The function returns the PDF plots of the different hologram Clusters 
function averagePDFWithHoloClusters(prtcleDiam,cluster,customCmap,clstrParamsNames)
global folderHeader fileHeader

holoClusters = cluster.holoClusters;


% Average PDFs of different clusters
for cnt =1:size(holoClusters,1)
    clusterHoloId = holoClusters(cnt,~isnan(holoClusters(cnt,:)));
	binCntr =[];
	PDF= [];
    binCntrCDF=[];
    CDF = [];
	for cnt2 = 1:numel(clusterHoloId)
        [binCntr(cnt2,:),PDF(cnt2,:)] = ...
            getPDFDistribution(prtcleDiam(:,clusterHoloId(cnt2)),'normal'); 
        [binCntrCDF(cnt2,:),CDF(cnt2,:)] = ...
            getbinCDF(prtcleDiam(:,clusterHoloId(cnt2)));
	end
        
	mnbinCntr(cnt,:) = nanmean(binCntr);
	mnPDF(cnt,:)  = nanmean(PDF); 
	stdPDF(cnt,:) = nanstd(PDF);
    
    mnbinCntrCDF(cnt,:) = nanmean(binCntrCDF);
    mnCDF(cnt,:)  = nanmean(CDF); 
    stdCDF(cnt,:) = nanstd(CDF);
end

%  Average PDFs of the holograms couside the cluster

binCntr =[];
PDF= [];
binCntrCDF=[];
CDF = [];
tmp = reshape(holoClusters,1,[]);
tmp = tmp(~isnan(tmp));
NoClusterHoloId = setdiff(1:size(prtcleDiam,2),tmp);

% Determining the cutoff number conc
numConc = nan(size(prtcleDiam,2),1);
for cnt=1:size(prtcleDiam,2)
    numConc(cnt) = sum(~isnan(prtcleDiam(:,cnt)));
end
cutOffNumConc     = round(0.7 * mean(numConc)); %percent cutoff determination

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
    [binCntr(cnt2,:),PDF(cnt2,:)] = ...
        getPDFDistribution(prtcleDiam(:,NoClusterHoloId(cnt2)),'normal'); 
    [binCntrCDF(cnt2,:),CDF(cnt2,:)] = getbinCDF(prtcleDiam(:,NoClusterHoloId(cnt2)));
    
end
mnbinCntr(end+1,:) = nanmean(binCntr);
mnPDF(end+1,:)  = nanmean(PDF); 
stdPDF(end+1,:) = nanstd(PDF);

mnbinCntrCDF(end+1,:) = nanmean(binCntrCDF);
mnCDF(end+1,:)  = nanmean(CDF); 
stdCDF(end+1,:) = nanstd(CDF);


%  Average PDF of the entire segment

	binCntr =[];
	PDF= [];
    binCntrCDF=[];
    CDF = [];
    EntireSedId = union(NoClusterHoloId,reshape(holoClusters,1,[]));
    EntireSedId = EntireSedId(~isnan(EntireSedId));
for cnt2 = 1:numel(EntireSedId)
    [binCntr(cnt2,:),PDF(cnt2,:)] = ...
        getPDFDistribution(prtcleDiam(:,cnt2),'normal'); 
    [binCntrCDF(cnt2,:),CDF(cnt2,:)] = getbinCDF(prtcleDiam(:,cnt2));
    
end
mnbinCntr(end+1,:) = nanmean(binCntr);
mnPDF(end+1,:)  = nanmean(PDF); 
stdPDF(end+1,:) = nanstd(PDF);

mnbinCntrCDF(end+1,:) = nanmean(binCntrCDF);
mnCDF(end+1,:)  = nanmean(CDF); 
stdCDF(end+1,:) = nanstd(CDF);





%  Average PDF of holograms below the cutoff

	binCntr =[];
	PDF= [];
    binCntrCDF=[];
    CDF = [];
tmp2 = reshape(holoClusters,1,[]);
tmp2(isnan(tmp2)) = [];
tmp2 = [NoClusterHoloId tmp2];
belowCutoffHolograms = setdiff(1:numel(numConc),tmp2);
% belowCutoffHologramsPDF(prtcleDiam,belowCutoffHolograms,plotTitle,cluster);
    
for cnt2 = 1:numel(belowCutoffHolograms)
    [binCntr(cnt2,:),PDF(cnt2,:)] = ...
        getPDFDistribution(prtcleDiam(:,cnt2),'normal'); 
    [binCntrCDF(cnt2,:),CDF(cnt2,:)] = getbinCDF(prtcleDiam(:,cnt2));
    
end
mnbinCntr(end+1,:) = nanmean(binCntr);
mnPDF(end+1,:)  = nanmean(PDF); 
stdPDF(end+1,:) = nanstd(PDF);

mnbinCntrCDF(end+1,:) = nanmean(binCntrCDF);
mnCDF(end+1,:)  = nanmean(CDF); 
stdCDF(end+1,:) = nanstd(CDF);


%  Weighted mean of the clusters
tmp1=[];
tmpPDF=[];
tmpCDF=[];
for cnt2 =1:size(holoClusters,1)
    tmp1(cnt2) = sum(~isnan(holoClusters(cnt2,:)));
    tmpPDF(cnt2,:) = mnPDF(cnt2,:)*tmp1(cnt2);
    tmpCDF(cnt2,:) = mnCDF(cnt2,:)*tmp1(cnt2);
    tmpStdPDF(cnt2,:) = stdPDF(cnt2,:)*tmp1(cnt2);
    tmpStdCDF(cnt2,:) = stdCDF(cnt2,:)*tmp1(cnt2);
end

mnbinCntr(end+1,:) = mnbinCntr(1,:);
mnPDF(end+1,:)  = sum(tmpPDF)/sum(tmp1);
stdPDF(end+1,:) = sum(tmpStdPDF)/sum(tmp1);

mnbinCntrCDF(end+1,:) = mnbinCntrCDF(1,:);
mnCDF(end+1,:)  = sum(tmpCDF)/sum(tmp1); 
stdCDF(end+1,:) = sum(tmpStdCDF)/sum(tmp1);


% Plotting the average PDFs with standard deviation for different bands
f=figure('Name','ClusterPDF','units','normalized','outerposition',[0 0 1 1]);
t=tiledlayout(1,2,'TileSpacing','compact','Padding','compact');
im1=nexttile;
leg="";
c = [1 1 1];
for cnt =1:size(holoClusters,1)+4
    P = plot(mnbinCntr(cnt,:), mnPDF(cnt,:),'LineWidth', 1);
    if cnt+1 <= size(customCmap,1)
        P.Color = customCmap(cnt+1,:);
    end
    hold on
    mnbinCntr2 = [mnbinCntr(cnt,:), fliplr(mnbinCntr(cnt,:))];
    patch = fill(mnbinCntr2, [mnPDF(cnt,:)+stdPDF(cnt,:),...
        fliplr(mnPDF(cnt,:)-stdPDF(cnt,:))],get(P,'color'));
    set(patch, 'edgecolor', 'none');
    set(patch, 'FaceAlpha', 0.5);
    hold on;
    
    if cnt<=size(holoClusters,1)
        leg(end) = ...
            convertCharsToStrings(['Cluster' num2str(cnt) '-' ...
            num2str(sum(~isnan(holoClusters(cnt,:))))]);
        leg(end+1:end+2) = [""; ""];
        c(cnt+1,:) = get(P,'color');
    elseif cnt==size(holoClusters,1)+1
%         c(cnt+1,:) = get(P,'color');
        leg(end:end+1) = ['Not Cluster-' num2str(numel(NoClusterHoloId));""];
    elseif cnt==size(holoClusters,1)+2
        leg(end+1:end+2) = ["Entire Segment";""];
    elseif cnt==size(holoClusters,1)+3
        leg(end+1:end+2) = ...
            ['belowCutoff-' num2str(numel(belowCutoffHolograms));""]; 
    else
        leg(end+1:end+2) = ...
            ["Weighted mean";""]; 
    end
    
end


pbaspect([1 1 1])
title('Average PDF with Clusters')
xlabel('Diameter (\mum)')
ylabel('PDF')
legend(leg);


% % Plotting the average CDF's with standard deviation for different bands
% % figure('Name','ClusterCDF');
% 
% subplot(1,2,2)
% leg="";
% c = [1 1 1];
% for cnt =1:size(holoClusters,1)+4
%     P = plot(mnbinCntrCDF(cnt,:), mnCDF(cnt,:),'LineWidth', 1);
%     P.Color = customCmap(cnt+1,:);
%     hold on
%     mnbinCntrCDF2 = [mnbinCntrCDF(cnt,:), fliplr(mnbinCntrCDF(cnt,:))];
%     patch = fill(mnbinCntrCDF2, [mnCDF(cnt,:)+stdCDF(cnt,:),...
%         fliplr(mnCDF(cnt,:)-stdCDF(cnt,:))],get(P,'color'));
%     set(patch, 'edgecolor', 'none');
%     set(patch, 'FaceAlpha', 0.5);
%     hold on;
%     
%     if cnt<=size(holoClusters,1)
%         leg(end) = ...
%             convertCharsToStrings(['Cluster' num2str(cnt) '-' ...
%             num2str(sum(~isnan(holoClusters(cnt,:))))]);
%         leg(end+1:end+2) = [""; ""];
%         c(cnt+1,:) = get(P,'color');
%     elseif cnt==size(holoClusters,1)+1
% %         c(cnt+1,:) = get(P,'color');
%         leg(end:end+1) = ['Not Cluster-' num2str(numel(NoClusterHoloId));""];
%     elseif cnt==size(holoClusters,1)+2
%         leg(end+1:end+2) = ["Entire Segment";""];
%     elseif cnt==size(holoClusters,1)+3
%         leg(end+1:end+2) = ...
%             ['belowCutoff-' num2str(numel(belowCutoffHolograms));""];  
%     else
%         leg(end+1:end+2) = ...
%             ["Weighted mean";""]; 
%     end
% 
%     
% end
% 
% pbaspect([1 1 1])
% title('Average CDF with Clusters')
% xlabel('Diameter (\mum)')
% ylabel('CDF')
% legend(leg,'location','southeast');




% sgtitle([plotTitle ' eps: ' num2str(cluster.eps) ...
%     ' minpnts: '  num2str(cluster.minPoints)])
% pause(2)
% filename = ['APDFACDFwtClusters_' plotTitle '_eps_ ' num2str(cluster.eps) ...
%     ' minpnts_'  num2str(cluster.minPoints)];
% prefix = pwd;
% mkdir([prefix '\DBSCANResults\' plotTitle '\'])
% savefig([prefix '\DBSCANResults\'  plotTitle '\' filename '.fig'])
% close(f);
% mkdir([prefix '\DBSCANResults\ClustersDetails'])
% save([prefix '\DBSCANResults\ClustersDetails\ClstrMtrxDetails' plotTitle '_eps_ ' ...
%     num2str(cluster.eps) '_minpnts_'  num2str(cluster.minPoints) '.mat'],...
%     'clusterMtrx','c','cluster')
% save([prefix '\DBSCANResults\ClustersDetails\ClstrPDFDetails' plotTitle '_eps_ ' ...
%     num2str(cluster.eps) '_minpnts_'  num2str(cluster.minPoints) '.mat'],...
%     'mnbinCntr','mnPDF','stdPDF','NoClusterHoloId','leg')


  end

% -------------------------------------------------------------------------