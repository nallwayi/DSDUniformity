%% Functions for performing single KS Test for binned PDF data
% -------------------------------------------------------------------------
% Function to do the KS test and get the KSMatrix bin data
% This function is written specifically to deal with binned discrete PDF data
% June 25,2023

function KSMatrix = KSMatrixSingleTestLES(alphaVal,prtcleDiam)

len = size(prtcleDiam,2);
KSMatrix = NaN(size(prtcleDiam,2));
for cnt = 1:len
    dist = prtcleDiam{1,cnt};
    mult1 = prtcleDiam{2,cnt};
    for cnt2 = 1:len
        
        testDist = prtcleDiam{1,cnt2};
        mult2 = prtcleDiam{2,cnt2};
        if ~isempty(dist) && ~isempty(testDist) && ...
                sum(mult1)>10 && sum(mult2)>10
            ksresult = kstest2LESbin(dist,testDist,mult1,mult2,'alpha',alphaVal);
            KSMatrix(cnt,cnt2) = ksresult;
%             [H, pValue, KSstatistic] = kstest2LESbin(dist,testDist,mult1,mult2,'alpha',alphaVal);
%             KSMatrix(cnt,cnt2) = 1-pValue;
        end
        
    end
end

% Removing all nan value holograms
KSMatrix(isnan(KSMatrix))=1.2;

end






% -------------------------------------------------------------------------
