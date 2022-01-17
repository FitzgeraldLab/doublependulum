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
theta2_0  = 45. *pi/180; %[rad]
dtheta2_0 = 0.  *pi/180; %[rad/s]

z0 = [theta1_0; theta2_0; dtheta1_0; dtheta2_0];

%% Solve the system

sol = ode23t( @(t,z) eom(t,z,p), tspan, z0 );

theta1 = @(t) deval( sol, t, 1);
theta2 = @(t) deval( sol, t, 2);

%% visualize
fig = figure();
ax = axes("parent", fig);
fplot(ax, @(t) theta1(t)*180/pi, tspan, "DisplayName", "\theta_1")
hold(ax, "on")
fplot(ax, @(t) theta2(t)*180/pi, tspan, "DisplayName", "\theta_2")
xlabel(ax, "Time t [s]")
ylabel(ax, "Angular position [deg]")
legend(ax, "show")


