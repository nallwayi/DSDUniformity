% Function to get the mean and standard deviation of the hologram PDF's as
% a time series
% May 5,2022


function[holoMean,holoStd,holodiam3] = getPDFpropertiesTimeSeries(pStats)


holoTime = pStats.holoinfo(:,3);
holonum  = pStats.holoinfo(:,1);
holoMean = nan(numel(holoTime),1); 
holoStd = nan(numel(holoTime),1); 
holodiam3 = nan(numel(holoTime),1);


for cnt = 1: numel(holoTime)
    ind = pStats.metrics.holonum == holonum(cnt) & ...
        pStats.metrics.majsiz > 10e-6;
        prtcleDiamArray = pStats.metrics.majsiz(ind);
        prtcleDiamArray(prtcleDiamArray < 10e-6) = [];
        holoMean(cnt) = mean(prtcleDiamArray);
        holoStd(cnt) = std(prtcleDiamArray);
        holodiam3(cnt) = mean(prtcleDiamArray.^3);
    
end
end