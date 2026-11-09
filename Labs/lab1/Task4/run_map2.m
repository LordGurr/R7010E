clear all
clc
close all
addpath(genpath('./'));

points = [
5 1 0;
5 1 2;
5 14 4;
5 17 4;
5 20 2;];
qdmax = [1 1 1];

% Sampling time
dt = 0.01;

% Acceleration time
tacc = 0.5;

% Generate trajectory
q = mstraj(points, qdmax, [], [], dt, tacc);

% map1.txt and map2.txt are the complex enviroments
map = load_map('maps/map2.txt', 0.1, 2, 0.25);
plot_path(map);
hold on
plot3(q(:,1), q(:,2), q(:,3))
grid on
box on
hold off;

