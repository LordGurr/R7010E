close all
clear all
clc
%%
height = 16.5;
ptCloud = pcread('fountain.ply');
pcshow(ptCloud);
hold on
% Spiral radius and vertical growth rate
r = 5;
c = 0.1;

% Define parameter t for the spiral turns
length = height/(pi*c);
start= pi*5;
t = linspace(start, length*pi, 500);

% Parametric equations
x = r * cos(t);
y = r * sin(t);
z = c * t;

% Plot the 3D spiral
plot3(x, y, z, 'LineWidth', 2);
grid on;
axis equal;
hold off
