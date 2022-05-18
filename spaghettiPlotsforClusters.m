% Function to get the spaghetti plots of the different cluster elements
% April 05,2022
% Modified April 11,2022 to account for cfg file

function spaghettiPlotsforClusters(prtcleDiam,cluster,customCmap,clstrParamsNames)
global cfg

x = nan(cluster.nClusters,1);
y =  nan(cluster.nClusters,1);

bins = (1:3:100)*1e-6;
binCntr = (bins(1:end-1)+bins(2:end))*0.5;
for cnt = 1:cluster.nClusters
    ind = find(cluster.clusterInfo == cnt-1);
    
    pos = 1;
    for cnt2 =1:numel(ind)
        pdArray = prtcleDiam(:,ind(cnt2));
        pdArray(isnan(pdArray)) = [];
        pdArray(pdArray<10e-6) = [];
        
        [counts,bins] = histcounts(pdArray,bins);
        PDF = counts/sum(counts); %PDF
        
        x(cnt,pos:pos+numel(PDF)-1) = binCntr;
        y(cnt,pos:pos+numel(PDF)-1) = PDF;
        pos = pos+numel(PDF);
        
    end
end

 x  = x *1e6; %conversion to micrometers
% x(x==0)=nan;
% y(x==0)=nan;

f=figure;%('Name','ClusterPDF','units','normalized','outerposition',[0 0 1 1]);
filename = 'ClstrSpaghettiPlts';
for cnt=1:size(x,1)
    plot(x(cnt,:),y(cnt,:),'LineStyle','-','Color',customCmap(cnt+1,:),...
        'Marker','.','MarkerSize',3);
    hold on
    leg(cnt) = convertCharsToStrings(['Cluster' num2str(cnt)]);
end
hold on
plot(1:60,zeros(1,60),'k')
hold off
title('Spaghetti Plots for Clusters')
xlabel('Diameter (\mum)')
ylabel('PDF')
legend(leg);
xlim([5 60])
% pbaspect([1 1 1])
savefig([cfg.folderHeader '/' cfg.clusteringAlgo 'Results/'  filename '_' cfg.fileHeader  clstrParamsNames '.fig'])
close(f)
end

