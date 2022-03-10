%% Function to get the PD time series for all time segments
% Modified on Sept 17, 2021
function [holotime,prtcleDiam] = getPDMatrix(pStats,ltime,utime)

%--------------------------------------------------------------------------
% Getting the PD time series with all diameter info

ind     = pStats.holoinfo(:,4)>= ltime & pStats.holoinfo(:,4) <=utime;
holonum = pStats.holoinfo(ind,1);
holotime= pStats.holoinfo(ind,3);

rwCnt = sum(pStats.metrics.holonum == mode(pStats.metrics.holonum));
cmCnt = length(holonum);

prtcleDiam = nan(rwCnt,cmCnt);

for cnt = 1:length(holonum)    
    ind = pStats.metrics.holonum == holonum(cnt);
    prtcleDiam(1:sum(ind),cnt) = pStats.metrics.majsiz(ind);
end
end
% -------------------------------------------------------------------------
