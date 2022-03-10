%--------------------------------------------------------------------------
% Function to get an small median hologram and then calculate its lwc
function [minMdnval,minMdnind] = getSmallMedianDist(prtcleDiam,holotime,rwCnt,cmCnt)

lwc = nan(cmCnt,1);
for cnt=1:cmCnt
    diamMedn(cnt) = median(prtcleDiam(~isnan(prtcleDiam(:,cnt)),cnt));
    tmp = prtcleDiam(~isnan(prtcleDiam(:,cnt)),cnt);
    lwc(cnt) = 997e3*4/3*pi*sum(tmp.^3)/8*1e6; %LWC per hologram
    if length(tmp) >= rwCnt/30
    end

    
end

[minMdnval,minMdnind] = min(diamMedn);
length(prtcleDiam(:,minMdnind))

figure('Name','LWC_Hologram');
plot(holotime,diamMedn*1e6)
title('Median TS')
xlabel('Hologram #')
ylabel('Median diameter(\mum)')


yyaxis right
plot(holotime,lwc)
ylabel('LWC (1e-6 gms/Hologram)')
plottools
end
%--------------------------------------------------------------------------
