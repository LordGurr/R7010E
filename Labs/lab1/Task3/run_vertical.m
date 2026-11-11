clear all
close all
clc
%% set up the enviroment
lim = [-2.0, 2.0, -2.0, 2.0, -2.0, 2.0]; % to define the limit of x,y,z
mdl_puma560     % to load the puma560 robot
p560.plot(qz,'workspace',lim)   % to draw the robot

% to define and to plot a wall 
a = 1;  % the wall is defined as ax+by+cz+d = 0 
b = 0;
c = 0;
d = -1;
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
scaler = 0.004;

letter_path_g= letter_path_g*scaler;

letter_path_j = [
0 118 238;
0 145 238;
0 145 277;
0 134 283;
0 122 282;
0 118 273;];

scaler = 0.006;

letter_path_j=[letter_path_j(:,1) -letter_path_j(:,2) -letter_path_j(:,3)];
letter_path_j = letter_path_j- letter_path_j(1,:);

letter_path_j= letter_path_j*scaler;
letter_path_g = letter_path_g + [0 -0.215 0];
letter_path_j = letter_path_j + [0 0.235 0];

qdmax = [1 1 1];
%q0 = [0 -1 0]*scaler;

% Sampling time
dt = 0.1;

% Acceleration time
tacc = 0.5;

% Generate trajectory

q_j = mstraj(letter_path_j, qdmax, [], [], dt, tacc);
qdmax = [0.05 0.05 0.05];

q_g = mstraj(letter_path_g, qdmax, [], tail(q_j,1), dt, tacc);

% Generate time vector
%t = (0:size(q,1)-1)*dt;
%plot_points(x,y,z)
%plot3(q(:,1), q(:,2), q(:,3))
%hold off;
%load q_vertical.mat

traj=[q_j; q_g];

%% send to robot
Tp =SE3(0.6, 0, 0) *   SE3(traj) * SE3.oa( [0 1 0], [1 0 0.1]);
q = p560.ikine6s(Tp);
plot_qtraj(q, wall, p560)