% Function to calculate the drizzle amount from the holodec
% dataset
% July 21, 2022

function [holoTime,holoDrizzle] = getDrizzleFromHolodec(pStats,cutoff)

holoTime = pStats.holoinfo(:,3);
holonum  = pStats.holoinfo(:,1);
holoVolume = pStats.volume * 1e-6; %m^3. 
holoDrizzle = nan(numel(holoTime),1); % #/m^3

 tic
 for cnt = 1: numel(holoTime)
     ind = pStats.metrics.holonum == holonum(cnt) & ...
         pStats.metrics.majsiz > cutoff(1)*1e-6 & ...
         pStats.metrics.majsiz < cutoff(2)*1e-6;
     prtcleDiamArray = pStats.metrics.majsiz(ind);
     prtcleDiamArray(prtcleDiamArray < 10e-6) = [];
     holoDrizzle(cnt) = getLiquidWaterContent(prtcleDiamArray,holoVolume);

end
end