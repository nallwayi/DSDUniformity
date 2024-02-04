% Function to get a movie of the different pdfs of the HOLODEC data in a
% segment.
% 03.29.2022


% Inputs the prtcleDiam that contains all the doplet information from a
% segment

function hologramPDFMovie(prtcleDiam)


bins = (1:3:45)*1e-6;
figure
for cnt =1:size(prtcleDiam,2)
    pdArray = prtcleDiam(:,cnt);
    pdArray(isnan(pdArray)) = [];
    pdArray(pdArray<10e-6) = [];
    
    [p,x] = hist(pdArray,bins);
    plot(x,p/sum(p)); %PDF
%     hold on
    
    pause(0.01)
    set(gca, 'YScale', 'log')
    
end
end