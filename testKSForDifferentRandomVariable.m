
function testKSForDifferentRandomVariable(type)

if ~exist('type','var')
    type = 'skellam';
end
    
tic
trialNo = 1e2;
range = 100:50:5000;
range = [10 50 1e2 5e2 1e3 5e3 1e4 5e4 1e5 5e5 1e6];
for cnt = 1:numel(range)
    
    H=[];
    for cnt2 = 1:trialNo
        
        if strcmp(type,'skellam')
            lambda1 = 1e3;
            lambda2 = 1e3;           
            RV1 = generateSkellamRV(lambda1,range(cnt));
            RV2 = generateSkellamRV(lambda2,range(cnt));
        elseif strcmp(type,'binomial')
            trials1 = 1e3;
            trials2 = 1e4;
            success1 = 0.1;
            success2 = 0.1;
            
            RV1 = generateBinomialRV(trials1,success1,range(cnt));
            RV2 = generateBinomialRV(round(trials2/10),success2,range(cnt));
        end
        
        [H(cnt2), pValue(cnt2), KSstatistic(cnt2)] = kstest2(RV1, RV2);
        
    end
    h(cnt) = mean(H);
    pmean(cnt) = mean(pValue);
    KSstatmean(cnt) = mean(KSstatistic);
    x(cnt) = range(cnt);
    % [y1,x1] = ecdf(RV1);
    % [y2,x2] = ecdf(RV2);
    % figure; plot(x1,y1,x2,y2)
end
toc
figure
yyaxis left
plot(x,h,'LineStyle','-','Color',[0.8500 0.3250 0.0980],...
    'Marker','.','MarkerSize',20);
yyaxis right
plot(x,pmean,':b',...
    'Marker','.','MarkerSize',20);
hold on
plot(x,KSstatmean,'--b',...
    'Marker','.','MarkerSize',20);
hold off
set(gca,'xscale','log')

title([num2str(trialNo) ' trials - ' type])
xlabel('Sample size')
ylabel('Avg pvalue and KS Stat')
yyaxis left
ylabel('Avg h value')
end

function RV = generateSkellamRV(lambda,sampleSize)

Na= poissrnd(lambda,sampleSize,1);
Nb = poissrnd(lambda,sampleSize,1);

RV = (Na-Nb)/sqrt(2*lambda);

end

function RV = generateBinomialRV(trials,success,sampleSize)

RV = binornd(trials,success,sampleSize,1);

end