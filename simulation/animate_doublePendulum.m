function [fig, ax] = animate_doublePendulum(sol, p, fps)

%% setup position functions
% always run from 0 to tf:
t0 = sol.x(1);
tf = sol.x(end);

th1 = @(t) deval(sol, t, 1);
th2 = @(t) deval(sol, t, 2);

x1 = @(t) +p.l_1*sin(th1(t));
y1 = @(t) -p.l_1*cos(th1(t));

xp = @(t) +p.l_p*sin(th1(t) + p.phi);
yp = @(t) -p.l_p*cos(th1(t) + p.phi);

x2 = @(t) xp(t) + p.l_2*sin(th2(t));
y2 = @(t) yp(t) - p.l_2*cos(th2(t));


%% setup the figure
fig = figure("Color", "w");
ax = axes("Parent", fig);
hold(ax,"on");
ax.DataAspectRatio = [1,1,1];
xlabel(ax, "x [m]");
ylabel(ax, "y [m]");

xlim(ax, [-1,1]*(p.l_p + p.l_2) );
ylim(ax, [-1,1]*(p.l_p + p.l_2) );

%% setup the animation objects

color_set = lines(7);

h_ground = line( ax, [-1,1]*0.3*p.l_1, [0, 0], "LineWidth", 3, "Color", "k");

h_p = line( ax, [0, xp(t0)], [0, yp(t0)], ...
    "LineWidth", 2, ...
    "Color", color_set(4,:),...
    "LineStyle", "-");

h_1 = line( ax, [0, x1(t0)], [0, y1(t0)], ...
    "LineWidth", 1.5, ...
    "Color", color_set(1,:),...
    "LineStyle", "--");

h_2 = line( ax, [xp(t0), x2(t0)], [yp(t0), x2(t0)], ...
    "LineWidth", 2, ...
    "Color", color_set(5,:),...
    "LineStyle", "-");

h_g1 = plot(ax, [x1(t0)], [y1(t0)], ...
    "LineStyle", "none", ...
    "Color", color_set(1,:), ...
    "Marker", "o",...
    "MarkerFaceColor", color_set(1,:),...
    "MarkerEdgeColor", color_set(1,:),...
    "MarkerSize", 12 );

h_g2 = plot(ax, [x2(t0)], [y2(t0)], ...
    "LineStyle", "none", ...
    "Color", color_set(5,:), ...
    "Marker", "o",...
    "MarkerFaceColor", color_set(5,:),...
    "MarkerEdgeColor", color_set(5,:),...
    "MarkerSize", 12 );

h_title = title(ax, "Time t = 0 [s]", ...
    "FontSize", 14);

% TODO: add trace of the COM locations as time increases

time = t0:1/fps:tf;
nframes = length(time);

%% setup output gif
% base the name on the current time, so they never overwrite each other:
outfilename = sprintf("animation.%s.gif", datestr(now, "yyyymmdd_HHMMSS"));

% TODO: finish the animation
% vw = VideoWriter(outfilename, 

%% loop over the frames

for i = 1:nframes
    
    t = time(i);
    
    h_1.XData = [0, x1(t)];
    h_1.YData = [0, y1(t)];
    
    h_g1.XData = x1(t);
    h_g1.YData = y1(t);
    
    h_p.XData = [0, xp(t)];
    h_p.YData = [0, yp(t)];
    
    h_2.XData = [xp(t), x2(t)];
    h_2.YData = [yp(t), y2(t)];
    
    h_g2.XData = x2(t);
    h_g2.YData = y2(t);
        
    h_title.String = sprintf( "Time t = %5.2f [s]", t);
    
    pause(0.1);
    
end


end