close all
clear all
clc
load('Points10.mat') %All
X=X/10;
Y=Y/10;
Z=Z/10;        
xyz=[X Y Z];
plot3(X,Y,Z);
grid on
box on
axis equal
hold on

hold on
% Spiral radius and vertical growth rate
height = 37;
r = linspace(4.5, 3, 500);
%r=4;
c = 0.1;

% Define parameter t for the spiral turns
length = height/(pi*c);
t = linspace(1, length*pi, 500);

% Parametric equations
x = r .* cos(t);
y = r .* sin(t);
z = c * t;



% Plot the 3D spiral
plot3(x, y, z, 'LineWidth', 2);
grid on;
axis equal;
hold off
