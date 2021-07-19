%% Particle sliding on the inside of an inverted cone
% Simulation and animation of a particle sliding with friction on the
% inside of an inverted cone.
%
%%

clear ; close all ; clc

%% Parameters

m = 1;          % Mass                      [kg]
c = 0.05;        % Drag coefficient          [-]
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
set(gcf,'Position',[50 50 1280 720]) % YouTube: 720p
% set(gcf,'Position',[50 50 854 480]) % YouTube: 480p
% set(gcf,'Position',[50 50 640 640]) % Instagram

% Create and open video writer object
v = VideoWriter('particle_cone.mp4','MPEG-4');
v.Quality = 100;
v.FrameRate = fR;
open(v);

% Generating frames
for i=1:length(tS)
    cla

    XYmin =-2;
    XYmax = 4;
    Zmin = -0.5;
    Zmax = 2.5;
    steptick = 1;
    
    hold on ; grid on ; axis equal   
    set(gca,'xlim',[XYmin XYmax],'ylim',[XYmin XYmax],'zlim',[Zmin Zmax],'CameraPosition',[-27.0446  -27.4492   14.0294])
    set(gca,'XTick',XYmin:steptick:XYmax,'YTick',XYmin:steptick:XYmax,'ZTick',Zmin:steptick:Zmax)
    set(gca,'XTickLabel',[],'YTickLabel',[],'ZTickLabel',[])

    R = r0;    % Radius
    H = r0;    % Height
    N = 50;     % Number of points
    [xCy, yCy, zCy] = cylinder([0 R], N);
    m = mesh(xCy, yCy, H*zCy);
    set(m,'edgealpha',0,'facecolor',[1 0 0],'facealpha',0.2)

    % Main particle
    plot3(x(1:i),y(1:i),z(1:i),'b')
    plot3(x(i),y(i),z(i),'ko','MarkerFaceColor','k','MarkerSize',5)
    
    gray_color = [150 150 150]/255;
    % Projections
    plot3(x(1:i),y(1:i),Zmin*ones(i,1),'g')
    plot3(x(i),y(i),Zmin,'o','Color',gray_color,'MarkerFaceColor',gray_color,'MarkerSize',5)
    
    plot3(XYmax*ones(i,1),y(1:i),z(1:i),'g')
    plot3(XYmax,y(i),r(i),'o','Color',gray_color,'MarkerFaceColor',gray_color,'MarkerSize',5)
    
    plot3(x(1:i),XYmax*ones(i,1),z(1:i),'g')
    plot3(x(i),XYmax,z(i),'o','Color',gray_color,'MarkerFaceColor',gray_color,'MarkerSize',5)

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
