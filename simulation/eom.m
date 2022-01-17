function dz = eom(t,z,p)

% z = [theta1, theta2, theta1dot, theta2dot]

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

% Mass matrix: M*xdd + h = 0
M = [I_G1 + l_1.^2.*m_1 + l_p.^2.*m_2, l_2.*l_p.*m_2.*cos(phi + z1 - z2); 
    l_2.*l_p.*m_2.*cos(phi + z1 - z2) I_G2 + l_2.^2.*m_2];

% remaining terms from the eom
h = [g.*l_1.*m_1.*sin(z1) + g.*l_p.*m_2.*sin(phi + z1) + l_2.*l_p.*m_2.*z4.^2.*sin(phi + z1 - z2); 
    l_2.*m_2.*(g.*sin(z2) - l_p.*z3.^2.*sin(phi + z1 - z2))];

dz = [z3;
    z4;
    -M\h];
