function [E, L, T, V] = energy(t, sol, p)

z = deval(sol, t);

% unpack the parameters:
g   = p.g;
m_1 = p.m_1;
l_1 = p.l_1;
I_G1= p.I_G1;
m_2 = p.m_2;
l_2 = p.l_2;
I_G2= p.I_G2;
l_p = p.l_p;
phi = p.phi;

z1 = z(1);
z2 = z(2);
z3 = z(3);
z4 = z(4);

%% Kinetic
T = I_G2.*z4.^2/2 + m_2.*(l_2.^2.*z4.^2 + 2*l_2.*l_p.*z3.*z4.*cos(phi + z1 - z2) + l_p.^2.*z3.^2)/2 + z3.^2.*(I_G1 + l_1.^2.*m_1)/2;

%% Potenial
V = -g.*l_1.*m_1.*cos(z1) + g.*m_2.*(-l_2.*cos(z2) - l_p.*cos(phi + z1));

%%
E = T+V;
L = T-V;