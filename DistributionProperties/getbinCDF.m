% -------------------------------------------------------------------------
% Sept 20, 2021
%  Function to get the empirical binned CDF of a dist. An upper cutoff is
%  defined

function [bincntr,Fdist] = getbinCDF(prtcleDiamArry)
    
    cutoff = 60e-6; 
    prtcleDiamArry = prtcleDiamArry(~isnan(prtcleDiamArry));
    prtcleDiamArry(prtcleDiamArry>cutoff)=[];
	llim = 0;
	ulim = cutoff;
	binwdth = 0.5e-6;

	bin = llim:binwdth:ulim;
	bincntr = (bin(1:end-1)+bin(2:end))*0.5;
	n   = length(prtcleDiamArry);
	for cnt=1:length(bin)-1
        Fdist(cnt) = 1/n * sum(prtcleDiamArry<=bin(cnt+1));
	end
    bincntr = bincntr *1e6;
end

% -------------------------------------------------------------------------