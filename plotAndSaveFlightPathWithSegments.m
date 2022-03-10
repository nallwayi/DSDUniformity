% Function to plot the flight path of different flight segments for a
% research flight 
% 2022 - 02 -28

function plotAndSaveFlightPathWithSegments(cldProps,Ltime,Utime)
global folderHeader fileHeader

lat = 38.77;
lon = 360-27.0995;

figname = [folderHeader(end-7:end) '_SegmentFlightPath'];
f = figure('units','normalized','outerposition',[0 0 1 1]);
gx = geoaxes('Basemap','satellite','ZoomLevel',8);
hold on
geoplot(lat,lon,'o','MarkerSize',8,'MarkerFaceColor','red',...
    'MarkerEdgeColor','Red')
hold on
geoplot(cldProps.HoloLatitude,360+cldProps.HoloLongitude,'c','LineWidth',2)


paths = nan(numel(Ltime),2);
for cnt  = 1:numel(Ltime)
    paths(cnt,1) = find(cldProps.holoTime >= Ltime(cnt), 1 );
    paths(cnt,2) =  find(cldProps.holoTime <= Utime(cnt), 1, 'last' );
    geoplot(cldProps.HoloLatitude(paths(cnt,1):paths(cnt,2)),...
        360+cldProps.HoloLongitude(paths(cnt,1):paths(cnt,2)),...
        'LineWidth',2)

end


savefig([folderHeader '/'  figname '.fig'])
close(f)
end