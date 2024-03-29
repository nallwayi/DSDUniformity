%% Functions for performing KS Test with monte carlo samples from global dist

%--------------------------------------------------------------------------
% Function to make (i) the main dist and (ii)the test sample based on the 
% length of the scale

function [passNs,passPrcnt,hEnsmblPass] = ensembleKSTestWithScale(prtcleDiam,scaleVal)

% Defining the number of ensembles of sample distributions needed for the 
% KS Test
ensmblNs = 1e4;

% Defining the cutoff value to determine if the result is KS Pass for the 
% comparisons from the sample ensembles
cutoffh   = 0.5;

prtcleDiam(prtcleDiam<10e-6) =nan;
numConc = nan(size(prtcleDiam,2),1);
for cnt=1:size(prtcleDiam,2)
    numConc(cnt) = sum(~isnan(prtcleDiam(:,cnt)));
end
trimPercent = 0.25;

% numConcS = sort(numConc(numConc~=0));
% trmdnumConc = (numConcS(round(trimPercent*numel(numConc)):...
%     round((1-trimPercent)*numel(numConc)) ));
Ncutoff = 0.7*mean(numConc);

mainDist = reshape(prtcleDiam,[],1); % Main Distribution
mainDist = mainDist(~isnan(mainDist));

% Removing all values below 10 microns
mainDist = mainDist(mainDist>10e-6);


% PrtcleDiam matrix based on scale
tmp  = reshape(prtcleDiam,[],size(prtcleDiam,2)/scaleVal); 


% KS Test stats
hEnsmbl = nan(size(tmp,2),1) ; % Ensemble KS result
pEnsmbl = nan(size(tmp,2),1); % Ensemble p value
ks2statEnsmbl = nan(size(tmp,2),1); % Ensemble KS stat
hAvg = nan(size(tmp,2),1); % average KS pass result

parfor cnt = 1:size(tmp,2)   
    testDist  = tmp(:,cnt);
    testDist  = testDist(~isnan(testDist));
    
    
% %     Performing the KS Test
%     [hEnsmbl(cnt),pEnsmbl(cnt),ks2statEnsmbl(cnt)]= ...
%     ensembleKSTest(testDist,mainDist,ensmblNs);
% 
%     if hEnsmbl(cnt) < cutoffh
%         hAvg(cnt) = 0;
%     else
%         hAvg(cnt) = 1;
%     end

%     Performing the KS Test
if numConc(cnt) > Ncutoff && numConc(cnt) >100
    hEnsmblPass(cnt)= ...
        ensembleKSTest(testDist,mainDist,ensmblNs);
else
    hEnsmblPass(cnt)= 0;
end

%     if hEnsmbl < cutoffh
%         hAvg(cnt) = 0;
%     else
%         hAvg(cnt) = 1;
%     end


end

% Calulating the number of KS Pass results and the pass percentage
passNs = sum(hEnsmblPass);
passPrcnt = passNs/(size(tmp,2)*ensmblNs);

end
% -------------------------------------------------------------------------