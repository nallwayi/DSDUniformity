% Function to get the gamma parameters of different clusters, box plots of
% differnt variables and process rates
% Aug 22, 2023

function getProcessRatesForClusters(cldProps)
global cfg


if ~exist(fullfile(cfg.folderHeader,'ClusterPDFProps'),'dir')
    mkdir(fullfile(cfg.folderHeader,'ClusterPDFProps'))
end

colors = [0.8000    0.8000    0.8000];
colorIndctr = ones(numel(cldProps.holoTime),1) * colors ;
sz = 20;


filelocation = fullfile(cfg.folderHeader,[  cfg.clusteringAlgo 'Results']);
filedetailsClstr = dir(fullfile(filelocation,'*.mat'));
filedetailsprtcleDiam = dir(fullfile(cfg.folderHeader,'*.mat'));

searchStrng = cfg.fileHeader;

% Loading the files
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

customCmap = [0,0.447,0.741;0.635,0.078,0.184;0.466,0.674,0.188;...
    0.850,0.325,0.098;0.494,0.184,0.556;0.301,0.745,0.933;...
    0.929,0.694,0.125;0 0 1; 0 1 0];

% Creating additional customCmaps for greater cluster sizes
if cluster.nClusters > size(customCmap,1)-1
    temp = customCmap;
    for cnt = 1:ceil(cluster.nClusters/9)-1
        customCmap = [customCmap;temp(2:end,:)];
    end
end

if exist([cfg.folderHeader '/ClusterPDFProps/clstrProcessRates_' cfg.fileHeader '.mat'],'file')
    load([cfg.folderHeader '/ClusterPDFProps/clstrProcessRates_' cfg.fileHeader '.mat'])
else
    
% Calculating values for the entire segment that satisfy the 70 percent
% threshold
prtcleDiam(prtcleDiam<10e-6) =nan;
cutOff = round(0.7*sum(~isnan(reshape(prtcleDiam,1,[])))/size(prtcleDiam,2));
% Find the holograms above the 70 percent threshold
lessThanThresh=[];
for cnt=1:size(prtcleDiam,2)

    prtclDiamArray = prtcleDiam(:,cnt);
    prtclDiamArray(isnan(prtclDiamArray)) = [];
    prtclDiamArray(prtclDiamArray < 10e-6) = [];

    if length(prtclDiamArray) < cutOff
        lessThanThresh = [lessThanThresh; cnt];
    end

end

unclusteredInd = setdiff(find(cluster.clusterInfo ==-1),lessThanThresh);
greaterThanThresh  = setdiff(1:size(prtcleDiam,2),lessThanThresh);

cluster.clusterInfo(lessThanThresh) = -2; 
clusteredInd = find(cluster.clusterInfo>-1);

% Segmentiing regions with onset of drizzzle
cutoffDWC = 0.02; %gm/cm^3
drizzInd = find(cldProps.holoDrizzle > cutoffDWC);
% clusteredInd=[];
for cnt = 1:cluster.nClusters
    ind = find(cluster.clusterInfo == cnt-1);
%     clusteredInd = [clusteredInd;ind'];
    clstrTime = holotime(ind);
    ind2=nan(sum(ind),1);
    ind3=nan(sum(ind),1);
    for cnt2 = 1:numel(clstrTime)
        colorIndctr(cldProps.holoTime== clstrTime(cnt2),:) = customCmap(cnt,:);
        ttmp = find(cldProps.holoTime== clstrTime(cnt2));
        if ismember(ttmp,drizzInd)
            ind3(cnt2) = ttmp;
        else
            ind2(cnt2) = ttmp;
        end

    end
    ind2(isnan(ind2))=[];
    ind3(isnan(ind3))=[];

    gammaparamsCDF=[];
    gammaparamsPDF=[];
    gamCntrbn_PDF=[];
    gamCntrbn_CDF=[];
    PL_CDF=[];
    PL_PDF=[];
    auto_ts_PDF=[];
    auto_ts_CDF=[];
    for cnt4=1:numel(ind)
        prtclDiamArray = prtcleDiam(:,ind(cnt4));
        prtclDiamArray(isnan(prtclDiamArray)) = [];
        prtclDiamArray(prtclDiamArray < 10e-6) = [];

        % CDF gamma fit
        [y,x] = ecdf(prtclDiamArray);
    	[scale,shape]=gammacdf(x*1e6/2,y,[]);
        gammaparamsCDF(cnt4,:) = [shape scale];
        ttmp = find(cldProps.holoTime== clstrTime(cnt4));
        [PL_CDF(cnt4),gamCntrbn_CDF(cnt4),auto_ts_CDF(cnt4)] = calculateAutoConversionRate(gammaparamsCDF(cnt4,:),...
            cldProps.LWC(ttmp),cldProps.concL(ttmp));


        %PDF gamma fit
        gammaparamsPDF(cnt4,:) = gamfit(prtclDiamArray*1e6/2);
        [PL_PDF(cnt4),gamCntrbn_PDF(cnt4),auto_ts_PDF(cnt4)] = calculateAutoConversionRate(gammaparamsPDF(cnt4,:),...
            cldProps.LWC(ttmp),cldProps.concL(ttmp));
    end

    try
        tmp = clstrProcessRates.gammaparamsCDF;
    end
    tmp.(['C' num2str(cnt)]) = gammaparamsCDF;
    clstrProcessRates.gammaparamsCDF = tmp;

    try
        tmp = clstrProcessRates.PL_CDF;
    end
    tmp.(['C' num2str(cnt)]) = PL_CDF;
    clstrProcessRates.PL_CDF = tmp;

    try
        tmp = clstrProcessRates.gamCntrbn_CDF;
    end
    tmp.(['C' num2str(cnt)]) = gamCntrbn_CDF;
    clstrProcessRates.gamCntrbn_CDF = tmp;

    try
        tmp = clstrProcessRates.auto_ts_CDF;
    end
    tmp.(['C' num2str(cnt)]) = auto_ts_CDF;
    clstrProcessRates.auto_ts_CDF = tmp;

    try
        tmp = clstrProcessRates.gammaparamsPDF;
    end
    tmp.(['C' num2str(cnt)]) = gammaparamsPDF;
    clstrProcessRates.gammaparamsPDF = tmp;

    try
        tmp = clstrProcessRates.PL_PDF;
    end
    tmp.(['C' num2str(cnt)]) = PL_PDF;
    clstrProcessRates.PL_PDF = tmp;

    try
        tmp = clstrProcessRates.gamCntrbn_PDF;
    end
    tmp.(['C' num2str(cnt)]) = gamCntrbn_PDF;
    clstrProcessRates.gamCntrbn_PDF = tmp;

    try
        tmp = clstrProcessRates.auto_ts_PDF;
    end
    tmp.(['C' num2str(cnt)]) = auto_ts_PDF;
    clstrProcessRates.auto_ts_PDF = tmp;

end

%% UNCLUSTERED
clstrTime = holotime(unclusteredInd);
% ttmp=[];
% for cnt=1:length(clstrTime)
%     ttmp(cnt) = find(cldProps.holoTime== clstrTime(cnt));
% end
gammaparamsCDF=[];
gammaparamsPDF=[];
gamCntrbn_PDF=[];
gamCntrbn_CDF=[];
PL_CDF=[];
PL_PDF=[];
auto_ts_PDF=[];
auto_ts_CDF=[];
for cnt4=1:numel(unclusteredInd)
    prtclDiamArray = prtcleDiam(:,unclusteredInd(cnt4));
    prtclDiamArray(isnan(prtclDiamArray)) = [];
    prtclDiamArray(prtclDiamArray < 10e-6) = [];

    % CDF gamma fit
    [y,x] = ecdf(prtclDiamArray);
    [scale,shape]=gammacdf(x*1e6/2,y,[]);
    gammaparamsCDF(cnt4,:) = [shape scale];
    ttmp = find(cldProps.holoTime== clstrTime(cnt4));
    [PL_CDF(cnt4),gamCntrbn_CDF(cnt4),auto_ts_CDF(cnt4)] = calculateAutoConversionRate(gammaparamsCDF(cnt4,:),...
        cldProps.LWC(ttmp),cldProps.concL(ttmp));

    %PDF gamma fit
    gammaparamsPDF(cnt4,:) = gamfit(prtclDiamArray*1e6/2);
    [PL_PDF(cnt4),gamCntrbn_PDF(cnt4),auto_ts_PDF(cnt4)] = calculateAutoConversionRate(gammaparamsPDF(cnt4,:),...
        cldProps.LWC(ttmp),cldProps.concL(ttmp));
end
clstrProcessRates.gammaparamsCDF.uncls = gammaparamsCDF;
clstrProcessRates.gamCntrbn_CDF.uncls = gamCntrbn_CDF;
clstrProcessRates.auto_ts_CDF.uncls = auto_ts_CDF;
clstrProcessRates.PL_CDF.uncls = PL_CDF;

clstrProcessRates.gammaparamsPDF.uncls = gammaparamsPDF;
clstrProcessRates.PL_PDF.uncls = PL_PDF;
clstrProcessRates.gamCntrbn_PDF.uncls = gamCntrbn_PDF;
clstrProcessRates.auto_ts_PDF.uncls = auto_ts_PDF;

    %%
entireSegment = reshape(prtcleDiam(:,greaterThanThresh),1,[]);
entireSegment(isnan(entireSegment))=[];
entireSegment(entireSegment<10e-6)=[];
entireSegmentMean     = mean(entireSegment)*1e6;


[vec,ind] = intersect(cldProps.holoTime,holotime(greaterThanThresh));

 

entireSegLWC = nanmean(cldProps.LWC(ind));
entireSegNd =  nanmean(cldProps.concL(ind));
[y,x] = ecdf(entireSegment);
[scale,shape]=gammacdf(x*1e6/2,y,[]);
entireSegGammaparamsCDF = [shape scale];
entireSegGammaparamsPDF = gamfit(entireSegment*1e6/2);

clstrProcessRates.gammaparamsCDF_ES = entireSegGammaparamsCDF;
clstrProcessRates.gammaparamsPDF_ES = entireSegGammaparamsPDF;

[PL,gamCntrbn_CDF,auto_ts] = calculateAutoConversionRate(entireSegGammaparamsCDF,...
            entireSegLWC,entireSegNd);
clstrProcessRates.PL_CDF_ES = PL;
clstrProcessRates.auto_ts_CDF_ES = auto_ts;
clstrProcessRates.gamCntrbn_CDF_ES = gamCntrbn_CDF;


[PL,gamCntrbn_PDF,auto_ts] = calculateAutoConversionRate(entireSegGammaparamsPDF,...
            entireSegLWC,entireSegNd);
clstrProcessRates.PL_PDF_ES = PL;
clstrProcessRates.auto_ts_PDF_ES = auto_ts;
clstrProcessRates.gamCntrbn_PDF_ES = gamCntrbn_PDF;

%sanity check
if (length(clusteredInd) + length(unclusteredInd) + length(lessThanThresh))...
        ~=  size(prtcleDiam,2)
    warning('Calc error')
    clustrFrac.calcError = true;
end
save([cfg.folderHeader '/ClusterPDFProps/clstrProcessRates_' cfg.fileHeader '.mat'],'clstrProcessRates');

end
plotProcessRate(customCmap,prtcleDiam,cluster,clstrProcessRates)

end




function plotProcessRate(customCmap,prtcleDiam,cluster,clstrProcessRates)
global cfg
datay = clstrProcessRates.PL_PDF;





for cnt=1:cluster.nClusters
    y = datay.(['C' num2str(cnt)]);
    ymean(cnt+1) = mean(y);
end
ymean(end) = mean(datay.uncls);

%Grid avg

ESValy = clstrProcessRates.PL_PDF_ES;

%sum of indv
ESIndy = mean(ymean);



% For Box plot

data = struct2cell(clstrProcessRates.PL_PDF);
ES = clstrProcessRates.PL_PDF_ES;
lbls = fieldnames(clstrProcessRates.PL_PDF);
lbls(end)=[]; 


%  customCmap = [0,0.447,0.741;0.635,0.078,0.184;0.466,0.674,0.188;...
%     0.850,0.325,0.098;0.494,0.184,0.556;0.301,0.745,0.933;...
%     0.929,0.694,0.125;0 0 1; 0 1 0];
customCmap(end+1,:) = [0 0 0];
clstrSz = cellfun('length',data);
colmnSz = max(clstrSz);
clstrIndvPDFMtrx = NaN(colmnSz,numel(data));


f = figure;
h=boxplot( data{(end),1}', 'positions',1,'labels', ['Uncls'],'Notch', 'off',  ...
    'Colors', [0.72,0.72,0.72],'PlotStyle','compact','symbol', '');
customizeBoxplot(h,data{(end),1}')
hold on
AllProcessRates=[];
TrmdProcessRates=[];
for cnt2 = 1:numel(data)-1

    AllProcessRates = [AllProcessRates;data{(cnt2),1}' ];
    h= boxplot( data{(cnt2),1}', 'positions',cnt2+1,'labels', ['C' (cnt2)],'Notch', 'off',  ...
        'Colors', [customCmap(cnt2,:)],'PlotStyle','compact','symbol', '');
    customizeBoxplot(h,data{(cnt2),1}')
    namePR{cnt2}= (['C' num2str(cnt2)]);
    meanPR(cnt2) = mean(data{(cnt2),1}');
    medianPR(cnt2) = median(data{(cnt2),1}');

    TrmdProcessRates = [TrmdProcessRates; rmoutliers(data{(cnt2),1}','percentiles',[5 95] )];
    meanPR_outliersRmd(cnt2) = mean(rmoutliers(data{(cnt2),1}','percentiles',[5 95]));
    medianPR_outliersRmd(cnt2) = median(rmoutliers(data{(cnt2),1}','percentiles',[5 95]));
    Prcnt2ES(cnt2) = sum(abs(log10(data{(cnt2),1}')-log10(ES)) <=0.5)/...
        length(data{(cnt2),1}')*100; 
end


AllProcessRates = [AllProcessRates;data{(end),1}' ];
TrmdProcessRates = [TrmdProcessRates;rmoutliers(data{(end),1}','percentiles',[5 95])];

ESInd =  mean(AllProcessRates); 

namePR{end+1}= (['uncls']);
meanPR(end+1) = mean(data{(end),1}');
medianPR(end+1) = median(data{(end),1}');
meanPR_outliersRmd(end+1) = mean(rmoutliers(data{(end),1}','percentiles',[5 95]));
medianPR_outliersRmd(end+1) = median(rmoutliers(data{(end),1}','percentiles',[5 95]));
Prcnt2ES(end+1) = sum(abs(log10(data{(end),1}')-log10(ES)) <=0.5)/...
        length(data{(end),1}')*100; 


namePR{end+1}= (['AvgInd']);
meanPR(end+1) =  mean(AllProcessRates);
medianPR(end+1) =  median(AllProcessRates);
meanPR_outliersRmd(end+1) = mean(TrmdProcessRates);
medianPR_outliersRmd(end+1) = median(TrmdProcessRates);
Prcnt2ES(end+1) =NaN;

namePR{end+1}= (['ESAvg']);
meanPR(end+1) = ES;
medianPR(end+1) = NaN;
meanPR_outliersRmd(end+1) = NaN;
medianPR_outliersRmd(end+1) = NaN;
Prcnt2ES(end+1) =sum(Prcnt2ES(1:end-1).*clstrSz'/sum(clstrSz));

namePR = namePR';
meanPR = round(log10(meanPR'),2);
medianPR = round(log10(medianPR'),2);
meanPR_outliersRmd = round(log10(meanPR_outliersRmd'),2);
medianPR_outliersRmd = round(log10(medianPR_outliersRmd'),2);
Prcnt2ES = round(Prcnt2ES');

ProcessRateAvg = table(namePR,meanPR,medianPR,meanPR_outliersRmd,medianPR_outliersRmd,Prcnt2ES);
save([cfg.folderHeader '/ClusterPDFProps/clstrProcessRatesAvg_' cfg.fileHeader '.mat'],'ProcessRateAvg');



hold on
plot(0:length(data)+1,ones(length(data)+2,1)*ES,'k-','DisplayName',...
    'Rate of Average Size Distribution','LineWidth',2);
plot(0:length(data)+1,ones(length(data)+2,1)*ESInd,'k--','DisplayName',...
    ' Average of Rates of Local Distributions','LineWidth',2);
lg.Location='southeast';
xticks('auto')
% xticklabels('auto')

% Add labels and title
% xlabel('Cluster mean diameter (\mum)','Interpreter','Latex')
% xlabel('$\overline{D} (\mu m)$','Interpreter','Latex')
ylabel({['Mass autoconv. rate (g cm^{-3}s^{-1})']})
title('', 'FontWeight', 'bold', 'FontSize', 14);

%    grid
set(gca,'YScale','log')

xticklabels = {'Uncls'};
for cnt5=1:cluster.nClusters
    xticklabels = [xticklabels; {['C' num2str(cnt5)]}];
end
xticklabels{end+1}='';
xticks('auto')
set(gca,'XTickLabel',xticklabels)
legend


pbaspect([2 1 1])
set(gca,'FontSize',15)
set(gca, 'LineWidth', 1.5)
% ylim([10e-18 10e-09])
% xlim([10 45])
% savefig([cfg.folderHeader '/ClusterPDFProps/clstrProcessRates_' cfg.fileHeader '.fig'])
close(f)
end


function customizeBoxplot(h,datavec)
%%% quantile calculation  
q = quantile(datavec,[0.05 0.25 0.75 0.95]);  
q05 = q(1);  
q25 = q(2);  
q75 = q(3);  
q95 = q(4);  


%%% modify the figure properties (set the YData property)  
%h(5,1) correspond the blue box  
%h(1,1) correspond the upper whisker  
%h(2,1) correspond the lower whisker  
% set(h(5,1), 'YData', [q25 q75 q75 q25 q25]);% blue box  
upWhisker = get(h(1,1), 'YData');  
set(h(1,1), 'YData', [upWhisker(1) q95])  

dwWhisker = get(h(2,1), 'YData');  
set(h(2,1), 'YData', [ q05 dwWhisker(2)]) 
% widthLine = get(h,'LineWidth');
% widthLine{2}=10;
% set(h,'LineWidth',widthLine)
end
