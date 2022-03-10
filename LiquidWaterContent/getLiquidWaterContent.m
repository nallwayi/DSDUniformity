% -------------------------------------------------------------------------
% Function to get the liquid water content of a hologram 
% It uses the array with details of all droplet sizes
function lwc = getLiquidWaterContent(prtcleDiamArray,holoVolume)

% set values
density = 997*1e3; %g/m^3
dropVolume  = 4/3 * pi * sum(prtcleDiamArray.^3) /8; % m^3
lwc = density * dropVolume /holoVolume; %g/m^3
end
% -------------------------------------------------------------------------