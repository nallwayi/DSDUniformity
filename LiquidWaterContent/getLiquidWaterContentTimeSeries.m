% -------------------------------------------------------------------------
% Function to get the number concentration time series 
% Concentration in #/m^3

function [holoTime,LWC] = getLiquidWaterContentTimeSeries(pStats)

holoTime = pStats.holoinfo(:,3);
holonum  = pStats.holoinfo(:,1);
holoVolume = pStats.volume * 1e-6; %m^3. 
LWC = nan(numel(holoTime),1); % #/m^3

 tic
 for cnt = 1: numel(holoTime)
     ind = pStats.metrics.holonum == holonum(cnt) & ...
         pStats.metrics.majsiz > 10e-6;
     prtcleDiamArray = pStats.metrics.majsiz(ind);
     prtcleDiamArray(prtcleDiamArray < 10e-6) = [];
     LWC(cnt) = getLiquidWaterContent(prtcleDiamArray,holoVolume);

end


toc
end
% -------------------------------------------------------------------------
