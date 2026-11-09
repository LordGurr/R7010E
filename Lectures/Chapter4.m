%% Chapter 4

format compact
close all
clear
clc
%%% 4.1.1 Car-like mobile robots

sl_lanechange
% we can't push the simulate button on the Simulink model from this script so we simulate it
out = sim('sl_lanechange')  
%%
out
t = out.get('t'); q = out.get('y');

figure
mplot(t, q(:,2:4))
%% %%%
clf
plot(q(:,1), q(:,2))
grid on

%% %%%4.1.1.1 Moving to a point


bdclose('all');

sl_drivepoint

xg = [5 5];

x0 = [4 5 pi/2];

r = sim('sl_drivepoint');
grid on
hold on
%% %%
q = r.find('y');
hold on
plot(q(:,1), q(:,2));
grid on
%% %%% 4.1.1.2 Following a line
bdclose('all');

sl_driveline

L = [1 -2 4];

x0 = [8 5 pi/2];

r = sim('sl_driveline');

hold on
x = 0:0.01:10;
% refline([1/2 2])
grid on 
box on
hold on
y = (-L(1)*x - L(3))/L(2);
plot(x,y)
hold on
plot(r.y(:,1),r.y(:,2))
%% %% 4.1.1.3 Following a trajectory
bdclose('all');

sl_pursuit

r = sim('sl_pursuit')


%% %%%4.1.1.4  Moving to a pose
bdclose('all');

sl_drivepose

xg = [5 5 pi/2];

x0 = [9 5 0];

r = sim('sl_drivepose');
grid on


%% %%
q = r.find('y');
clf
plot(q(:,1), q(:,2));
%% %%%



%% %%

%% %%%



%% %%