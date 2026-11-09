clear all
close all
clc
%% set up the enviroment
lim = [-2.0, 2.0, -2.0, 2.0, -2.0, 2.0]; % to define the limit of x,y,z
mdl_puma560     % to load the puma560 robot
p560.plot(qz,'workspace',lim)   % to draw the robot

% to define and to plot a wall 
a = cos(deg2rad(10));  % the wall is defined as ax+by+cz+d = 0 
b = 0;
c = sin(deg2rad(10));
d = -cos(deg2rad(10));
wall = Wall(a,b,c,d,lim);  % to define the wall
wall.plotwall();           % to plot the wall
%% place your trajectory generation code here
% 1) An example trajectory can be loaded from the 'q.mat' file
letter_path_g = [
0 235 285;
0 230 270;
0 240 250;
0 260 235;
0 290 245;
0 295 265;
0 290 290;
0 265 290;
0 265 265;];
letter_path_g=[letter_path_g(:,1) -letter_path_g(:,3) -letter_path_g(:,2)];

letter_path_g = letter_path_g- letter_path_g(1,:);
scaler = 0.008;

letter_path_g= letter_path_g*scaler;
qdmax = [1 1 1];
q0 = [0 -1 0]*scaler;

% Sampling time
dt = 0.1;

% Acceleration time
tacc = 0.5;
% Generate trajectory
q = mstraj(letter_path_g, qdmax, [], q0, dt, tacc);

% Set depth correctly
k=-c/a;
length=size(q(:,1));
for i = 1:length(1)
    q(i,1) = q(i,3)*k;
end
traj=q;
%load q_inclined.mat
%traj=q;
%% send to robot
Tp =SE3(0.6, 0, 0) *   SE3(traj) * SE3.oa( [0 1 0], [1 0 0.1]);
q = p560.ikine6s(Tp);
plot_qtraj(q, wall, p560)