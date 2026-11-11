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

function path = generate_helix_path(height, r, c)
    % Define parameter t for the spiral turns
    length = height/(pi*c);
    t = linspace(1, length*pi, 500);
    
    % Parametric equations
    x = r .* cos(t);
    y = r .* sin(t);
    z = c * t;
    path = [x' y' z'];
end

height = 37;
r = linspace(4.5, 3, 500);

path = generate_helix_path(37, r, 0.1);




% Plot the 3D spiral
plot3(path(:,1), path(:,2), path(:,3), 'LineWidth', 2);
grid on;
axis equal;
hold off
