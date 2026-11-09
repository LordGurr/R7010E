clear all
clc
close all
addpath(genpath('./'));

points = [-5 2 0];
for i = 1:4
    offset =((i-1)*6);
    points = [points; -1+offset 2 4.5];
    points = [points; 2+offset 2 4.5];
    points = [points; 2+offset 2 1];
    points = [points; 5+offset 2 1];
end
points(end, :) = [22, 2, 0];
qdmax = [1 1 1];

% Sampling time
dt = 0.01;

% Acceleration time
tacc = 0.5;

% Generate trajectory
q = mstraj(points, qdmax, [], [], dt, tacc);

% Generate time vector
t = (0:size(q,1)-1)*dt;


% map1.txt and map2.txt are the complex enviroments
map = load_map('maps/map1.txt', 0.1, 2, 0.25);
plot_path(map);
hold on
plot3(q(:,1), q(:,2), q(:,3))
grid on
box on
hold off;

