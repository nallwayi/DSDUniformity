% -------------------------------------------------------------------------
% Function to get and plot the autocorrealtion function for radius moments
function getAndPlotAutoCorrelationForRadiusMoments(prtcleDiam)

 R0 = nan(size(prtcleDiam,2),1);
 R1 = nan(size(prtcleDiam,2),1);
 R2 = nan(size(prtcleDiam,2),1);
 R3 = nan(size(prtcleDiam,2),1);
 
 

for cnt = 1: size(prtcleDiam,2)
    prtcleDiamArray = prtcleDiam(~isnan(prtcleDiam(:,cnt)),cnt);
    R0(cnt) = length(prtcleDiamArray);
    R1(cnt) = sum(prtcleDiamArray.^1) /1;
    R2(cnt) = sum(prtcleDiamArray.^2) /4;
    R3(cnt) = sum(prtcleDiamArray.^3) /8;
end

% %  Calculating the mean values
% tmp = reshape(prtcleDiam,[],1);
% tmp = tmp(~isnan(tmp));
% 
% R0Avg = length(tmp)/size(prtcleDiam,2);
% R1Avg = sum(tmp.^1)/size(prtcleDiam,2)/1;
% R2Avg = sum(tmp.^2)/size(prtcleDiam,2)/4;
% R3Avg = sum(tmp.^3)/size(prtcleDiam,2)/8;

% Removing the mean values
R0 = R0-mean(R0);
R1 = R1-mean(R1);
R2 = R2-mean(R2);
R3 = R3-mean(R3);


[autoCorrR0Norm,lagsR0] = xcorr(R0,'normalized');
[autoCorrR1Norm,lagsR1] = xcorr(R1,'normalized');
[autoCorrR2Norm,lagsR2] = xcorr(R2,'normalized');
[autoCorrR3Norm,lagsR3] = xcorr(R3,'normalized');




figure('Name','AutoCorr:R0');
% stem(lagsR0,autoCorrR0Norm)
plot(lagsR0,autoCorrR0Norm)
title('AutoCorrelation: R0')
xlabel('Lag')
ylabel('AutoCorrelation Normalized')
grid on
set(gca,'XTick',-550:50:550)

figure('Name','AutoCorr:R1');
% stem(lagsR1,autoCorrR1Norm)
plot(lagsR1,autoCorrR1Norm)
title('AutoCorrelation: R1')
xlabel('Lag')
ylabel('AutoCorrelation Normalized')
grid on
set(gca,'XTick',-500:50:500)

figure('Name','AutoCorr:R2');
% stem(lagsR2,autoCorrR2Norm)
plot(lagsR2,autoCorrR2Norm)
title('AutoCorrelation: R2')
xlabel('Lag')
ylabel('AutoCorrelation Normalized')
grid on
set(gca,'XTick',-500:50:500)

figure('Name','AutoCorr:R3');
% stem(lagsR3,autoCorrR3Norm)
plot(lagsR3,autoCorrR3Norm)
title('AutoCorrelation: R3')
xlabel('Lag')
ylabel('AutoCorrelation Normalized')
grid on
set(gca,'XTick',-500:50:500)


figure('Name','AutoCorr');
% stem(lagsR1,autoCorrR1Norm)
plot(lagsR0,autoCorrR0Norm)
hold on
plot(lagsR1,autoCorrR1Norm)
hold on
plot(lagsR2,autoCorrR2Norm)
hold on
plot(lagsR3,autoCorrR3Norm)
hold off
title('AutoCorrelation: R0,R1,R2,R3')
xlabel('Lag')
ylabel('AutoCorrelation Normalized')
legend('R0','R1','R2','R3')
grid on
set(gca,'XTick',-500:50:500)
end

