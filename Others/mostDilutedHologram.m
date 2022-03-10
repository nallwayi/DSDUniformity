%--------------------------------------------------------------------------
%  Function to get the most diluted hologram

function [minLWCval,minLWCind] = mostDilutedHologram(prtcleDiam,rwCnt,cmCnt)

lwc = nan(cmCnt,1);
for cnt=1:cmCnt
    tmp = prtcleDiam(~isnan(prtcleDiam(:,cnt)),cnt);
    if length(tmp) >= sum(sum(~isnan(prtcleDiam)))/cmCnt/10 %rwCnt/10
        lwc(cnt) = 997e3*4/3*pi*sum(tmp.^3)/8*1e6; %LWC per hologram
    end
    
end

[minLWCval,minLWCind] = max(lwc);
% 
% figure('Name','LWC_Hologram');
% plot(lwc)
% title('LWC per hologram')
% xlabel('Hologram #')
% ylabel('LWC (1e-6 gms/Hologram)')
% plottools

 
 
end
%--------------------------------------------------------------------------
