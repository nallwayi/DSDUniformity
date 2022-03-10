% -------------------------------------------------------------------------
% 07.26.2021
% Function to plot the average PDFs of KS pass and fail when compared to
% ensemble of the global distribution.
function getavgPDFCompWithGlobalEnsemble(prtcleDiam,hEnsmblPass,cutoff)
    KSPass     = find(hEnsmblPass(:,1) > cutoff);
    KSFail     = find(hEnsmblPass(:,1) < cutoff);
    hologroups(1:length(KSFail),1) = KSFail;
    hologroups(1:length(KSPass),2) = KSPass;
    hologroups(hologroups==0) =nan;
    leg= ["KSFail" ,"" ,"KSPass", ""];
    averagePDFWithHoloGroup(prtcleDiam,hologroups,leg)
end
% -------------------------------------------------------------------------