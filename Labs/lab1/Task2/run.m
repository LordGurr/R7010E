%% clear the workspace variables and close all figures
clear all
clc
close all
%% Load the map
load map1
about map
%% plot the map
plot(Bug2(map))
%% Initial position and heading of the robot
p_init=[50 30]; % [x,y]
%% Goal location of the robot 
p_goal=[20 5]; % [x,y]

%% Define the desired path 
path=[ p_init;...
       20 30 ;...
       20 60 ;...
       50 60 ;...
       50 90 ;...
       90 90 ;...
       90 10 ;...
       20 10 ;...
       p_goal
    ];
%% Genrate trajectory
QDMAX=[1,1]; %axis speed limits
Q0= path(1,:); %initial axis coordinates
DT=0.2;
traj = mstraj(path, QDMAX, [], Q0, DT, 0);
%% Plot the path
obstacle=1; %0 when there is no door to block the way, 1 the door will be on
animatepath(traj,DT,obstacle)