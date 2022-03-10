% -------------------------------------------------------------------------
% Function to plot the liquid water content 
function plotLiquidWaterContentWtHoloTime(lwcWtTime,holotime)

figure('Name','LWC');
plot(holotime,lwcWtTime,'b')
title('LWC content with holotime')
xlabel('holotime UTC(s)')
ylabel('Liquid Water Content (g/m^3)')
end
% -------------------------------------------------------------------------
