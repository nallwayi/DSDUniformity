% Function to calculate the drizzle amount from the combined 2DS-FCDP-HVPS
% dataset
% 2022.03.04
% Might have small issues with the regions with no data. Check again

function lwcDrizzle = getDrizzleFromCombinedData(combinedConc,cutoff)

ind1 = find(combinedConc.binEdge(:,1)>cutoff(1), 1 ); 
ind2 = find(combinedConc.binEdge(:,2)<cutoff(2), 1 , 'last');
temp = combinedConc.conc{:,ind1+2:ind2+2};
temp(temp<0) = 0;

concr3Drizzle = nan(size(combinedConc.conc,1),1);
for cnt = 1:size(combinedConc.conc,1)
%     for cnt2 = 1:numel(combinedConc.binWidth)-ind+1
%         if combinedConc.conc{cnt,cnt2+2} >=0
%             temp(cnt2) = combinedConc.conc{cnt,cnt2+2} .* ...
%                 combinedConc.binWidth(cnt2);
%         end
%     end
%     concDrizzle(cnt) = sum(temp);
%     concDrizzle(cnt) = sum(combinedConc.conc{cnt,ind+2:end} .* ...
%         combinedConc.binWidth(ind:end));


%   N(r)*r^3 [#/um/L * um*1e3]*[m^3] = [#/m^3 * m^3]
    concr3Drizzle(cnt) = sum(temp(cnt,1:end) .* ...
        combinedConc.binWidth(ind1:ind2)*1e3 .* ...
        ((combinedConc.binEdge(ind1:ind2,2)+...
        combinedConc.binEdge(ind1:ind2,2))*0.25*1e-6)'.^3);

end




% Calculate LWC
% set values
density = 997*1e3; %g/m^3
lwcDrizzle = density * 4/3 * pi * concr3Drizzle; %g/m^3

end