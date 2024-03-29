% Main: plot single solution

clear all
close all
clc

%% build parameters

% these are selected to be in SI units (kg, m, s) but as long as the set is
% consistent it will work fine.
p.g    = 9.81; %[m/s^2]
p.m_1  = 1.0;  %[kg]
p.l_1  = 0.5;  %[m]
p.I_G1 = 1/12*p.m_1*p.l_1^2; %[kg m^2]
p.m_2  = 1.0;  %[kg]
p.l_2  = 0.5;  %[m]
p.I_G2 = 1/12*p.m_2*p.l_2^2; %[kg m^2]
p.l_p  = 2*p.l_1; %[m]
p.phi  = 0*pi/180;%[rad]

tspan = [0, 10]; %[s]

%% initial conditions
theta1_0  = 45. *pi/180; %[rad]
dtheta1_0 = 0.  *pi/180; %[rad/s]
theta2_0  = 180.*pi/180; %[rad]
dtheta2_0 = 0.  *pi/180; %[rad/s]

z0 = [theta1_0; theta2_0; dtheta1_0; dtheta2_0];

%% List of solvers
ode_list = { @ode45, @ode23, @ode113, @ode78, @ode89, ...
    @ode23s, @ode23t, @ode23tb};

num_solvers = length(ode_list);
data = {};

%% Solve the system

for i = 1:num_solvers
    ode = ode_list{i};
    sol = ode( @(t,z) eom(t,z,p), tspan, z0 );

    data{i} = sol;
    theta1{i} = @(t) deval( sol, t, 1);
    theta2{i} = @(t) deval( sol, t, 2);

end


%% visualize
% fig = figure();
% ax1 = subplot(3,1,1:2, "parent", fig);
% fplot(ax1, @(t) theta1(t)*180/pi, tspan, "DisplayName", "\theta_1")
% hold(ax1, "on")
% fplot(ax1, @(t) theta2(t)*180/pi, tspan, "DisplayName", "\theta_2")
% xlabel(ax1, "Time t [s]")
% ylabel(ax1, "Angular position [deg]")
% legend(ax1, "show")
% 
% ax2 = subplot(3,1,3, "parent", fig);
% fplot(ax2, @(t) energy(t, sol, p), tspan);
% xlabel(ax2, "Time t [s]")
% ylabel(ax2, "Energy T+V [J]");

%% Animation

% animate_doublePendulum(data{i}, p, 30);
animate_multiple_doublePendulum(data, p, 30);
