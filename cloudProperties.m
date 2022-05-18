% 2022.02.14
function cldProps = cloudProperties(pStats,iwg,combinedConc)

    holoSecond = pStats.holoinfo(:,4);
    holoTime   = pStats.holoinfo(:,3);
    
    GPSAltitude = iwg.GPS_MSL_Alt;
    latitude   = iwg.Lat;
    longitude   = iwg.Lon; 
    Vert_Wind_Spd  = iwg.Vert_Wind_Spd;
    
    MetSecond = datetime2sod(iwg.Date_Time);
    GPSAltitude(MetSecond < holoSecond(1) & MetSecond > holoSecond(end))=[];
    MetSecond(MetSecond < holoSecond(1) & MetSecond > holoSecond(end))=[];

    

    [~,concL] = getNumberConcentrationTimeSeries(pStats);
    [holoTime,LWC] = getLiquidWaterContentTimeSeries(pStats);
    [holoMean,holoStd] = getPDFpropertiesTimeSeries(pStats);
    
    for cnt = 1:size(combinedConc.conc,1)
        combinedSecond(cnt) = datetime2sod(combinedConc.conc.UTC(cnt));
    end
    cutoff = [40 10e3];
    lwcDrizzle = getDrizzleFromCombinedData(combinedConc,cutoff);
    drizzleLWC = nan(size(holoTime));
    
    for cnt = 1:numel(combinedSecond)
        drizzleLWC(combinedSecond(cnt) == holoSecond) = ...
            lwcDrizzle(combinedSecond == combinedSecond(cnt));
    end
    
    GPSHoloAltitude = nan(size(holoTime));
    HoloLatitude = nan(size(holoTime));
    HoloLongitude = nan(size(holoTime));
    velocity_w = nan(size(holoTime));

    
    for cnt = 1:numel(MetSecond)
        GPSHoloAltitude(MetSecond(cnt) == holoSecond) = ...
            GPSAltitude(MetSecond == MetSecond(cnt));
        HoloLatitude(MetSecond(cnt) == holoSecond) = ...
            latitude(MetSecond == MetSecond(cnt));
        HoloLongitude(MetSecond(cnt) == holoSecond) = ...
            longitude(MetSecond == MetSecond(cnt));
        velocity_w(MetSecond(cnt) == holoSecond) = ...
            Vert_Wind_Spd(MetSecond == MetSecond(cnt));
        
    end
    
%     fnames = ["holoTime"; "HoloLatitude";"HoloLongitude";...
%         "GPSHoloAltitude" ; "concL"; "LWC";"velocity_w"];
%     
%     Vals  = [holoTime'; HoloLatitude'; HoloLongitude' ; GPSHoloAltitude'; ...
%          concL'; LWC' ; velocity_w'];
%     
%     cldProps.fnames = fnames;
%     cldProps.Vals   = Vals;
    
%     holoTime = holoTime';
%     HoloLatitude = HoloLatitude';
%     HoloLongitude = HoloLongitude';
%     GPSHoloAltitude = GPSHoloAltitude';
%     concL = concL';
%     LWC = LWC';
%     velocity_w = velocity_w' ;
    velocity_w(velocity_w<-9990) = nan;
    cldProps = table(holoTime,HoloLatitude,HoloLongitude,GPSHoloAltitude, ...
         concL, LWC , velocity_w,drizzleLWC,holoMean,holoStd );
    
end