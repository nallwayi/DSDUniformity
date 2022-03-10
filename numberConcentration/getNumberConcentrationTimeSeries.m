% -------------------------------------------------------------------------
% Function to get the number concentration time series 
% Concentration in #/m^3

function [holoTime,concL] = getNumberConcentrationTimeSeries(pStats)

holoTime = pStats.holoinfo(:,3);
holonum  = pStats.holoinfo(:,1);
holoVolume = pStats.volume; %cm^3. 
concL = nan(numel(holoTime),1); % #/cm^3

 tic
for cnt = 1: numel(holoTime)
    ind = pStats.metrics.holonum == holonum(cnt) & ...
        pStats.metrics.majsiz > 10e-6;
%         prtcleDiamArray = pStats.metrics.majsiz(ind);
    %     prtcleDiamArray(prtcleDiamArray < 10e-6) = [];
    %     concL(cnt) = getNumberConcentration(prtcleDiamArray,holoVolume);
    
    concL(cnt) = sum(ind)/holoVolume; % #/cm^3;

end

toc
end
% -------------------------------------------------------------------------
