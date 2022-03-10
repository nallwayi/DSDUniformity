% -------------------------------------------------------------------------
% 07.26.2021
%  Function to get the average PDF of a band of holograms
%  The function returns the PDF plots of the different bands 
function averagePDFWithHoloBands(prtcleDiam,bands)
    
    
    for cnt = 1:length(bands)-1
        binCntr =[];
        dNdX= [];
        for cnt2 = 1:size(bands(cnt)+1:bands(cnt+1),2)
            [binCntr(cnt2,:),dNdX(cnt2,:)] = ...
            getPDFDistribution(prtcleDiam(:,bands(cnt)+cnt2),'log');           
        end
        
        mnbinCntr(cnt,:) = nanmean(binCntr);
        mndNdX(cnt,:)  = nanmean(dNdX); 
        stddNdX(cnt,:) = nanstd(dNdX);
    end
    
    
% Making legends

for cnt=1:2:2*(length(bands)-1)
    leg(cnt) =convertCharsToStrings...
        ([num2str(bands(ceil(cnt/2))+1) '-' num2str(bands(ceil(cnt/2)+1)) ]);  
end


% Plotting the average PDFs with standard deviation for different bands
    figure('Name','averagePDFWithHoloBands');
    for cnt =1:length(bands)-1

        P = plot(mnbinCntr(cnt,:), mndNdX(cnt,:),'LineWidth', 1);
        hold on
        mnbinCntr2 = [mnbinCntr(cnt,:), fliplr(mnbinCntr(cnt,:))];
        patch = fill(mnbinCntr2, [mndNdX(cnt,:)+stddNdX(cnt,:),...
            fliplr(mndNdX(cnt,:)-stddNdX(cnt,:))],get(P,'color'));
        set(patch, 'edgecolor', 'none');
        set(patch, 'FaceAlpha', 0.5);
        hold on;
        
        
        
    end
    title('Average PDF With Holo Bands')
    xlabel('Diameter (\mum)')
    ylabel('PDF')
%     legend('0 150','','151-200','','201-400','','401-512','')
      legend([leg ''])



end
% -------------------------------------------------------------------------