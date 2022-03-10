% -------------------------------------------------------------------------
% Function to get the number concentration of a hologram 
% It uses the array with details of all droplet sizes
function concL = getNumberConcentration(prtcleDiamArray,holoVolume)
holoVolume = holoVolume * 1e-6 ; % in m^3
concL = numel(prtcleDiamArray)/holoVolume; % #/L;
end
% -------------------------------------------------------------------------