% -------------------------------------------------------------------------
% 07.26.2021
%  Function to get the average PDF of a group of holograms
%  The function returns the PDF plots of the different hologram groups
%  hologroup is n x m matrix
function averagePDFWithHoloGroup(prtcleDiam,hologroups,leg)
    
    
    for cnt = 1:size(hologroups,2)
        binCntr =[];
        dNdX= [];
        tmp = hologroups(:,cnt);
        tmp = tmp(~isnan(tmp));
        for cnt2 = 1:length(tmp)
            [binCntr(cnt2,:),dNdX(cnt2,:)] = ...
            getPDFDistribution(prtcleDiam(:,tmp(cnt2)),'log');           
        end
        
        mnbinCntr(cnt,:) = nanmean(binCntr);
        mndNdX(cnt,:)  = nanmean(dNdX); 
        stddNdX(cnt,:) = nanstd(dNdX);
    end
    
    

% Plotting the average PDFs with standard deviation for different bands
    figure('Name','averagePDFWithHoloGroups');
    for cnt =1:size(hologroups,2)

        P = plot(mnbinCntr(cnt,:), mndNdX(cnt,:),'LineWidth', 1);
        hold on
        mnbinCntr2 = [mnbinCntr(cnt,:), fliplr(mnbinCntr(cnt,:))];
        patch = fill(mnbinCntr2, [mndNdX(cnt,:)+stddNdX(cnt,:),...
            fliplr(mndNdX(cnt,:)-stddNdX(cnt,:))],get(P,'color'));
        set(patch, 'edgecolor', 'none');
        set(patch, 'FaceAlpha', 0.5);
        hold on;
        
        
        
    end
    title('Average PDF With Holo Groups')
    xlabel('Diameter (\mum)')
    ylabel('PDF')
    legend(leg)

end
% -------------------------------------------------------------------------