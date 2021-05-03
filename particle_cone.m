%% Particle sliding on the inside of an inverted cone
% Simulation and animation of a particle sliding with friction on the
% inside of an inverted cone.
%
%%

clear ; close all ; clc

%% Parameters

m = 1;          % Mass                      [kg]
c = 0.1;        % Drag coefficient          [-]
g = 9.81;       % Gravity                   [m/s2]

parameters = [m c g];

%% Initial conditions

r0   = 2;       % Initial radial position   [m]
th0  = 0;       % Initial orientatio/n      [rad]
dr0  = 0;       % Initial radial speed      [m/s]
dth0 = 0.8;     % Initial angular speed     [rad/s]

z0 = [r0 th0 dr0 dth0];

%% Simulation

tf  = 30;                       % Final time                [s]
fR  = 30;                       % Frame rate                [fps]
tS   = linspace(0,tf,tf*fR);    % Time                      [s]

% Integration
[tout,xout] = ode45(@(t,z) particle(t,z,parameters),tS,z0);

% Retrieving states
r   = xout(:,1);
th  = xout(:,2);

% Coordinates
z = r;              % r=z. Cone angle = 45 deg.
x = r.*cos(th);
y = r.*sin(th);

%% Animation

L = 2.1;            % Distance form center

figure
hold on ; grid on ; axis equal   
set(gca,'xlim',[-L L],'ylim',[-L L],'zlim',[0 L],'CameraPosition',[-21.6164 -19.9472 12.3236])

% Create and open video writer object
v = VideoWriter('particle_cone.avi');
v.Quality = 100;
open(v);

% Generating frames
for i=1:length(tS)
    cla

    R = r0;    % Radius
    H = r0;    % Height
    N = 50;     % Number of points
    [xCy, yCy, zCy] = cylinder([0 R], N);
    m = mesh(xCy, yCy, H*zCy);
    set(m,'edgealpha',0,'facecolor',[1 0 0],'facealpha',0.5)

    % Main particle
    plot3(x(1:i),y(1:i),z(1:i),'b')
    plot3(x(i),y(i),z(i),'r*')
    % Projections
    plot3(x(1:i),y(1:i),zeros(i,1),'g')
    plot3(x(i),y(i),0,'r*')
    plot3(ones(i,1)*L,y(1:i),z(1:i),'g')
    plot3(L,y(i),r(i),'r*')
    plot3(x(1:i),ones(i,1)*L,z(1:i),'g')
    plot3(x(i),L,z(i),'r*')

    frame = getframe(gcf);
    writeVideo(v,frame);
end

close(v);

%% Auxiliary function

function dz = particle(~,z,dados)

    % Parametes
    m       = dados(1);
    c       = dados(2);
    g       = dados(3);

    % States
    r       = z(1);
%     th      = z(2);
    dr      = z(3);
    dth     = z(4);

    % State Equations
    dz(1,1) = dr;
    dz(2,1) = dth;
    dz(3,1) = (-m*g + m*r*dth^2 - 2*c*dr)/(2*m);
    dz(4,1) = (-2*m*dr*dth - c*r*dth)/(m*r);
   
end
