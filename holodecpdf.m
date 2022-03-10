function [avgrad,pdf,concL] = holodecpdf(particledata,time,type,volume,pStats)

if strcmp(type,'holo')
    ind = particledata.holotimes==time;
    noholo = 1;
else
    ind = particledata.holosecond==time;
    noholo = pStats.noholograms(find(pStats.noholograms(:,1)==time),2);
end

fname = fieldnames(particledata);
for j=1:length(fname)
    data.(fname{j}) = particledata.(fname{j})(ind);
end

diam = [0 1.5 3 4.5 6 8 10 12 14 16 18 21 24 27 30 33 36 39 42 46 50 150]*1e-6;
volume  = volume*1e-3;% Conversion of cm^3 to litres

for j = 1:length(diam)-1
    dd(j)     = diam(j+1)-diam(j);
    avgrad(j) = (diam(j+1)+diam(j))*1e6/4;
    count = sum(data.majsiz > diam(j) & data.majsiz < diam(j+1));
    concL(j)  = count/volume/noholo;
    Prob(j) = count;
    
    pdf(j)    = Prob(j)/dd(j)*1e-6;
    
end
pdf = pdf/sum(Prob);
end

