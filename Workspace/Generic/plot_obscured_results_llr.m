RadarName = 'staddon_detection';
RadarCoords.lat = 50.346069;
RadarCoords.lon = -4.113670;

RadarCoords_lat = 50.339026;
RadarCoords_lon = -4.126307;

% Load dataset
load(strcat(RadarName,'.mat'));
% load('jpda_llr_detection.mat');

% lon_lim = [-4.2637   -4.1024];
% lat_lim = [50.2699   50.3853];

lon_lim_obs = [-4.16737200000000,-4.14897200000000];
lat_lim_obs = [50.3537860000000,50.3617750000000];
% radar_meas_convert;


% Map plot
figure('units','normalized','outerposition',[0 0 .5 0.8])
ax(1) = gca;
plot_google_map('Axis',ax(1),'APIKey','AIzaSyBXKujdtXRZiqya1soVS9pxBzYR4g7aGvM','Resize',3,'Scale',2,'MapType','satellite');
axis(ax(1),[lon_lim(1) lon_lim(2) lat_lim(1) lat_lim(2)])
plots = [];
hold on;

N = size(MeasurementScans,2); % Simulation length

Tracks = [TrackList, DeletedTracks];
t = [368, 912, 640, 673, 146, 594, 342, 182, 912, 505, 672, 195, 594, 342, ...
    798, 267, 54, 794, 826, 125, 767, 524, 63, 200, 754, 244, 74, 777, 969, ...
    77, 51, 74, 828, 307, 861, 97, 807, 931, 665, 404, 177, 938, 225, 392, ...
    985, 585, 608, 319, 641, 915, 661, 538, 517, 586, 27, 164];

%% PLot detections
for k=2:N
    
    MeasurementList = MeasurementScans(k);
    if(MeasurementList.NumMeasurements>0)
        % Convert measurements to LLA and plot them
    %     [lat,lon,~] = ned2geodetic(MeasurementList.Vectors(2,:),...
    %                                MeasurementList.Vectors(1,:),...
    %                                0,...
    %                                RadarCoords.lat,...
    %                                RadarCoords.lon,...
    %                                0,...
    %                                referenceEllipsoid('wgs84'));
        latlon = [MeasurementList.Metadata.LatLon];
        lat = latlon(1,:);
        lon = latlon(2,:);
        plots(end+1) = plot(ax(1), lon,lat,'y.','MarkerSize', 4);
    end
end

%% Plot all existing tracks

for j=1:numel(Tracks)
    track = Tracks{j};
%     if find(t==track.Tag.ID,1)
%         continue
%     end
    % Convert track trajectory to LLA and plot it
    means = [track.Trajectory.Mean];
    [lat,lon,~] = ned2geodetic(means(3,:),...
                               means(1,:),...
                               0,...
                               RadarCoords.lat,...
                               RadarCoords.lon,...
                               0,...
                               referenceEllipsoid('wgs84'));
    traj_length = size(lon,2);

    plots(end+1) = plot(ax(1), lon(:,1),lat(:,1),'go','MarkerSize',15,'LineWidth',2);
%     if(track.Tag.ID == 9576) %(track.Tag.ID == 2026)
% %         plots(end+1) = plot(ax(1), lon, lat,'-.b','LineWidth',2);
%         jump_track = track;
%     else
%     plots(end+1) = plot(ax(1), lon, lat,'-.w','LineWidth',2); 
    if (track.Tag.ID == 9049)
        plots(end+1) = plot(ax(1), lon, lat,'-','LineWidth',4,'Color', [0.0265, 0.6137, 0.8135]);
        plots(end+1) = plot(ax(1), lon, lat,'-.w','LineWidth',1);
    else
        plots(end+1) = plot(ax(1), lon, lat,'-.w','LineWidth',2);
    end
%     end
%     text(ax(1), lon(:,1), lat(:,1), num2str(track.Tag.ID),'FontSize',18,'Color','g')
    plots(end+1) = plot(ax(1), lon(:,end),lat(:,end),'rx','MarkerSize',15,'LineWidth',2);

    % Convert track velocity to LLA and plot it
%     [lat_vel,lon_vel,~] = ned2geodetic(track.State.Mean(4,end),...
%                                        track.State.Mean(2,end),...
%                                        0,...
%                                        lat(:,end),...
%                                        lon(:,end),...
%                                        0,...
%                                        referenceEllipsoid('wgs84'));
%     lat_vel = lat_vel-lat(:,end);
%     lon_vel = lon_vel-lon(:,end);
%     plots(end+1) = quiver(ax(1), lon(:,end),lat(:,end),20*lon_vel,20*lat_vel,'r','LineWidth',1.5);
%     if ShowTrackInfo
%     end
    
end

%% Plot jump track
% Convert track trajectory to LLA and plot it
% means = [jump_track.Trajectory.Mean];
% [lat,lon,~] = ned2geodetic(means(3,:),...
%                            means(1,:),...
%                            0,...
%                            RadarCoords.lat,...
%                            RadarCoords.lon,...
%                            0,...
%                            referenceEllipsoid('wgs84'));
% traj_length = size(lon,2);
% 
% plots(end+1) = plot(ax(1), lon(:,1),lat(:,1),'go','MarkerSize',15,'LineWidth',3);
% plots(end+1) = plot(ax(1), lon, lat,'-b','LineWidth',2);
% 
% %     text(ax(1), lon(:,end), lat(:,end), num2str(track.Tag.ID),'FontSize',18,'Color','g')
% plots(end+1) = plot(ax(1), lon(:,end),lat(:,end),'rx','MarkerSize',15,'LineWidth',2);

%% Plot region of low PD
x = [-3422.85261310741,-3191.58441229017,-2993.55608122595,-3228.08558459284, -3422.85261310741];
y = [1.472966334316646e+03,1.123217741935625e+03,1.243952901078573e+03,1.579667558371468e+03, 1.472966334316646e+03];
[y,x,~] = ned2geodetic(y,...
                       x,...
                       0,...
                       RadarCoords.lat,...
                       RadarCoords.lon,...
                       0,...
                       referenceEllipsoid('wgs84'));
plots(end+1) = plot(ax(1), x, y, 'm-', 'LineWidth', 2);

%% Plot region of high clutter
x = [-469.710602736631,-2572.92295458513,-2516.31234127506,-1320.74163107899,-835.307363807233, -469.710602736631];
y = [-4915.41679013513,-4065.50122858976,-2858.60918927224,-1380.19032924249,-1261.08679763585, -4915.41679013513];
%         x = [-2858.62556879160,-2856.97056906902,-108.925126527319,-108.988225201227,-2858.62556879160];
%         y = [-4044.74840882411,-974.655039469575,-975.424226884065,-4045.51804181679,-4044.74840882411];
[y,x,~] = ned2geodetic(y,...
                       x,...
                       0,...
                       RadarCoords.lat,...
                       RadarCoords.lon,...
                       0,...
                       referenceEllipsoid('wgs84'));
plots(end+1) = plot(ax(1), x, y, 'r-', 'LineWidth', 2);

plot(ax(1), RadarCoords_lon,RadarCoords_lat,...
                               '-s','MarkerSize',10,...
                               'MarkerEdgeColor','red',...
                               'MarkerFaceColor',[1 .6 .6]);
                           
%% Draw fragmented tracks
% pos = [-4.165160054276827,50.355602071110530,8.806962025316167e-04,3.984217051424821e-04]; 
% rectangle(ax(1), 'Position', pos, 'LineWidth', 2, 'EdgeColor', 'c');
% pos = [-4.167026289696956,50.356097278434504,5.284177215187924e-04,4.297286215901863e-04]; 
% rectangle(ax(1), 'Position', pos, 'LineWidth', 2, 'EdgeColor', 'c');
% pos = [-4.166649142857144,50.355538217013894,9.387755102041595e-04,4.993124999970178e-04]; 
% rectangle(ax(1), 'Position', pos, 'LineWidth', 2, 'EdgeColor', 'c');
% pos = [-4.166029551020409,50.356218308274430,0.001464489795919,4.668618949992265e-04]; 
% rectangle(ax(1), 'Position', pos, 'LineWidth', 2, 'EdgeColor', 'c');
% pos = [-4.162312000000000,50.356469695448660,0.001577142857142,5.027743484617986e-04]; 
% rectangle(ax(1), 'Position', pos, 'LineWidth', 2, 'EdgeColor', 'c');

% pos = [-4.165015673469388,50.354255094151870,8.636734693876491e-04,6.105117088495149e-04]; 
% rectangle(ax(1), 'Position', pos, 'LineWidth', 2, 'EdgeColor', 'c');
% pos = [-4.163964244897960,50.357211886153530,9.199999999998099e-04,3.830661702579619e-04]; 
% rectangle(ax(1), 'Position', pos, 'LineWidth', 2, 'EdgeColor', 'c');
% pos = [-4.166124656203267,50.355788121845360,0.002969808091306,4.199620620113365e-04]; 
% rectangle(ax(1), 'Position', pos, 'LineWidth', 2, 'EdgeColor', 'c');




%% Legend
h1 = plot(NaN, NaN, 'o','MarkerSize', 5, 'MarkerFaceColor', 'y', 'MarkerEdgeColor','k');
h2 = plot(NaN, NaN, 's','MarkerSize',10,...
                               'MarkerEdgeColor','red',...
                               'MarkerFaceColor',[1 .6 .6]);
h3 = plot(NaN, NaN, 'm-', 'LineWidth', 2);
h4 = plot(NaN, NaN, 'r-', 'LineWidth', 2);
h5 = plot(NaN, NaN, 'go','MarkerSize',15,'LineWidth',2);
h6 = plot(NaN, NaN, 'rx','MarkerSize',15,'LineWidth',2);
h7 = plot(NaN, NaN, 'cs','MarkerSize',15,'LineWidth',2);
h8 = plot(NaN, NaN, 'b-','MarkerSize',15,'LineWidth',3);
h9 = plot(NaN, NaN, '-', 'LineWidth',2, 'Color', [0.0265, 0.6137, 0.8135]);
legend([h1, h3, h5, h6, h9], 'Detections', 'Obscured Region', 'Track Birth', 'Track Death', 'Delayed Initiation', 'Location','southeast');
% legend([h1, h2, h3, h4], 'Detections', 'Radar Position', 'Obscured Region', 'High-clutter region');
% legend([h1, h3, h5, h6, h7, h8], 'Detections', 'Obscured Region', 'Track Birth', 'Track Death', 'Fragmentation Examples', 'Jump-track','Location','southeast');
% legend([h1, h2, h3, h4], 'Detections', 'Radar Position', 'Obscured Region', 'High-clutter region');
% xlabel('Longitude');
% ylabel('Latitude');
set(ax(1),'YTickLabel',[]);
set(ax(1),'XTickLabel',[]);
