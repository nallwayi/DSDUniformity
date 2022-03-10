function [x,y]=histgen(y,counts)
% figure(1)
% h = histogram(y,90);
[y,edges] = histcounts(y,counts,'Normalization','pdf');
% plot it
x = 0.5*(edges(1:end-1)+edges(2:end));
% binCenters = h.BinEdges + (h.BinWidth/2);
% plot(binCenters(1:end-1), p)
% plot(x, y)
% hold on

end