% -------------------------------------------------------------------------
% Function to get the liquid water content time series 
function lwcWtTime = getLiquidWaterContentWtHoloTime(prtcleDiam,holoVolume)

 holoVolume = holoVolume *1e-6; % Conversion of cm^3 to m^3
 lwcWtTime = nan(size(prtcleDiam,2),1);
for cnt = 1: size(prtcleDiam,2)
    prtcleDiamArray = prtcleDiam(~isnan(prtcleDiam(:,cnt)),cnt);
    lwcWtTime(cnt) = getLiquidWaterContent(prtcleDiamArray,holoVolume);
end
end
% -------------------------------------------------------------------------
