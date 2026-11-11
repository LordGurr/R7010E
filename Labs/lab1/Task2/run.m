%% clear the workspace variables and close all figures
clear all
clc
close all
%% Load the map
load map1
about map
%% plot the map
plot(Bug2(map))
hold on
%% Initial position and heading of the robot
p_init=[50 30]; % [x,y]
%% Goal location of the robot 
p_goal=[20 5]; % [x,y]

%% Define the desired path 

%x=[15 15 50 50 90];
%y=[35 65 65 100 5];


path=[ p_init;...
       15 35 ;...
       15 65 ;...
       50 65 ;...
       50 100 ;...
       90 100 ;...
       90 0 ;...
       p_goal
    ];
%% Generate trajectory
QDMAX=[7,7]; %axis speed limits
Q0= path(1,:); %initial axis coordinates
DT=0.1;
traj = mstraj(path, QDMAX, [], Q0, DT, 0.3);
%% Plot the path
obstacle=1; %0 when there is no door to block the way, 1 the door will be on
plot(traj(:,1),traj(:,2))
animatepath(traj,DT,obstacle)
hold off