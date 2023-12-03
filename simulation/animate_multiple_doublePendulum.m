function [fig, ax] = animate_multiple_doublePendulum(sol_list, p, fps)

%% setup the figure
fig = figure("Color", "w");
ax = axes("Parent", fig);
hold(ax,"on");
ax.DataAspectRatio = [1,1,1];
xlabel(ax, "x [m]");
ylabel(ax, "y [m]");

xlim(ax, [-1,1]*(p.l_p + p.l_2) );
ylim(ax, [-1,1]*(p.l_p + p.l_2) );


h_ground = line( ax, [-1,1]*0.3*p.l_1, [0, 0], ...
    "LineWidth", 3, "Color", "k");
h_title = title(ax, "Time t = 0 [s]", ...
    "FontSize", 14);

%% make some colors
%color_set = lines(7);
color_set = [...
    104,175,252; ...
    93,193,30; ...
    227,19,238; ...
    56,120,54; ...
    155,76,157; ...
    174,210,132; ...
    126,68,234; ...
    226,217,35;...
    ]/255;
ncolors = size(color_set,1);
wrapColorIdx = @(i) mod( i-1, ncolors ) + 1;
get_color = @(i) color_set( wrapColorIdx(i), :);

%% Time interval
% assume they are all in the same interval
sol = sol_list{1};
t0 = sol.x(1);
tf = sol.x(end);

%% setup position functions
% always run from 0 to tf:

for i = 1:length(sol_list)
    sol = sol_list{i};
    th1{i} = @(t) deval(sol, t, 1);
    th2{i} = @(t) deval(sol, t, 2);

    x1{i} = @(t) +p.l_1*sin(th1{i}(t));
    y1{i} = @(t) -p.l_1*cos(th1{i}(t));

    xp{i} = @(t) +p.l_p*sin(th1{i}(t) + p.phi);
    yp{i} = @(t) -p.l_p*cos(th1{i}(t) + p.phi);

    x2{i} = @(t) xp{i}(t) + p.l_2*sin(th2{i}(t));
    y2{i} = @(t) yp{i}(t) - p.l_2*cos(th2{i}(t));

    %% setup the animation objects

    h_p{i} = line( ax, [0, xp{i}(t0)], [0, yp{i}(t0)], ...
        "LineWidth", 3, ...
        "Color", get_color(i),...
        "LineStyle", "-");

    h_1{i} = line( ax, [0, x1{i}(t0)], [0, y1{i}(t0)], ...
        "LineWidth", 2, ...
        "Color", get_color(i),...
        "LineStyle", "--");

    h_2{i} = line( ax, [xp{i}(t0), x2{i}(t0)], [yp{i}(t0), x2{i}(t0)], ...
        "LineWidth", 3, ...
        "Color", get_color(i),...
        "LineStyle", "-");

    h_g1{i} = plot(ax, [x1{i}(t0)], [y1{i}(t0)], ...
        "LineStyle", "none", ...
        "Color", get_color(i), ...
        "Marker", "o",...
        "MarkerFaceColor", get_color(i),...
        "MarkerEdgeColor", get_color(i),...
        "MarkerSize", 14 );

    h_g2{i} = plot(ax, [x2{i}(t0)], [y2{i}(t0)], ...
        "LineStyle", "none", ...
        "Color", get_color(i), ...
        "Marker", "o",...
        "MarkerFaceColor", get_color(i),...
        "MarkerEdgeColor", get_color(i),...
        "MarkerSize", 14 );


    % TODO: add trace of the COM locations as time increases

end

time = t0:1/fps:tf;
nframes = length(time);

%% setup output gif
% base the name on the current time, so they never overwrite each other:
outfilename = sprintf("animation.%s.gif", datestr(now, "yyyymmdd_HHMMSS"));

% TODO: finish the animation
% vw = VideoWriter(outfilename,

%% loop over the frames

for j = 1:nframes

    t = time(j);

    for i = 1:length(sol_list)

        h_1{i}.XData = [0, x1{i}(t)];
        h_1{i}.YData = [0, y1{i}(t)];

        h_g1{i}.XData = x1{i}(t);
        h_g1{i}.YData = y1{i}(t);

        h_p{i}.XData = [0, xp{i}(t)];
        h_p{i}.YData = [0, yp{i}(t)];

        h_2{i}.XData = [xp{i}(t), x2{i}(t)];
        h_2{i}.YData = [yp{i}(t), y2{i}(t)];

        h_g2{i}.XData = x2{i}(t);
        h_g2{i}.YData = y2{i}(t);

    end

    h_title.String = sprintf( "Time t = %5.2f [s]", t);

    pause(0.1);

end


end