% Function to get a movie of the different cluster pdfs of the HOLODEC data in a
% segment.
% 05.22.2022


% Inputs the prtcleDiam that contains all the doplet information from a
% segment

function hologramClusterPDFMovie(prtcleDiam,cluster,customCmap)

global cfg

x = nan(cluster.nClusters,1);
y =  nan(cluster.nClusters,1);

bins = (1:3:100)*1e-6;
binCntr = (bins(1:end-1)+bins(2:end))*0.5;

filename = 'ClstrSpaghettiPlts';

for cnt = 1:cluster.nClusters
    ind = find(cluster.clusterInfo == cnt-1);
    
    pos = 1;
    f=figure('Name','ClusterPDF','units','normalized','outerposition',[0 0 1 1]);
    for cnt2 =1:numel(ind)
        pdArray = prtcleDiam(:,ind(cnt2));
        pdArray(isnan(pdArray)) = [];
        pdArray(pdArray<10e-6) = [];
        
        [counts,bins] = histcounts(pdArray,bins);
        PDF = counts/sum(counts); %PDF
        
        x(cnt,pos:pos+numel(PDF)-1) = binCntr;
        y(cnt,pos:pos+numel(PDF)-1) = PDF;
        pos = pos+numel(PDF);
        
        plot(x(cnt,:)*1e6,y(cnt,:),'LineStyle','-','Color',customCmap(cnt+1,:),...
            'Marker','.','MarkerSize',3);
        leg(cnt) = convertCharsToStrings(['Cluster' num2str(cnt)]);
        pause(0.1)
        
        title('Spaghetti Plots for Clusters')
        xlabel('Diameter (\mum)')
        ylabel('PDF')
        legend(leg);
        xlim([5 100])
    end
end






% pbaspect([1 1 1])

end

