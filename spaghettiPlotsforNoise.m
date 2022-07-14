
% Function to get the spaghetti plots of the different noise elements
% April 26,2022

function spaghettiPlotsforNoise(prtcleDiam,cluster,clstrParamsNames)
global cfg

x = nan(cluster.nClusters,1);
y =  nan(cluster.nClusters,1);

bins = (1:3:66)*1e-6;
binCntr = (bins(1:end-1)+bins(2:end))*0.5;

ind = find(cluster.clusterInfo == -1);

pos = 1;
for cnt2 =1:numel(ind)
    pdArray = prtcleDiam(:,ind(cnt2));
    pdArray(isnan(pdArray)) = [];
    pdArray(pdArray<10e-6) = [];
    
    [counts,bins] = histcounts(pdArray,bins);
    PDF = counts/sum(counts); %PDF
    
    x(pos:pos+numel(PDF)-1) = binCntr;
    y(pos:pos+numel(PDF)-1) = PDF;
    pos = pos+numel(PDF);
    
end


x  = x *1e6; %conversion to micrometers
% x(x==0)=nan;
% y(x==0)=nan;

f=figure;%('Name','ClusterPDF','units','normalized','outerposition',[0 0 1 1]);
filename = 'NoiseSpaghettiPlts';
    plot(x(:),y(:),'LineStyle','-','Color',[0.635 0.078 0.184],...
        'Marker','.','MarkerSize',3);
    hold on
    leg= 'Unclusterred holograms';

% title('Spaghetti Plots for Unclusterred holograms')
xlabel('Diameter (\mum)')
ylabel('PDF')
legend(leg);
xlim([5 60])
pbaspect([1 1 1])
savefig([cfg.folderHeader '/' cfg.clusteringAlgo 'Results/'  filename '_' cfg.fileHeader  clstrParamsNames '.fig'])
close(f)
end

