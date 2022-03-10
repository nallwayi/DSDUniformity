%% Conditional Sampling Functions -- Part2 

% -------------------------------------------------------------------------
% Function to plot the KS test results of conditional number concentration
% sampling
function plotKSMatrixWithConditionalSamplingNumConc(KSMatrixCondConc)
figure('Name','KS Matrix');
image(KSMatrixCondConc,'CDataMapping','scaled')

% colors = [0 0 1;... % blue
%           1 1 1;... % black
%           1 1 0];... % yellow
colors = hot;
colormap(colors)
axis square
% plottools
end
% -------------------------------------------------------------------------