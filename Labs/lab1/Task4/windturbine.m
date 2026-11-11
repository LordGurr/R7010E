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

function path = rotate_path(theta, path)
    Ry = [ cosd(theta), 0,  sind(theta);
        0,           1,  0;
        -sind(theta), 0,  cosd(theta)];
    path = path * Ry';
end

r = linspace(3, 3, 500);

path = generate_helix_path(37, r, 0.1);
path2 = generate_helix_path(25, r, 0.1);
path2 = rotate_path(120, path2) +[3 -5 38];
path3 = generate_helix_path(25, r, 0.1);
path3 = rotate_path(-120, path3) +[-3 -5 38];
path4 = generate_helix_path(25, r, 0.1);
path4 = path4 +[0 -5 44];


path = [path; path2; path3; path4];

% Plot the 3D spiral
plot3(path(:,1), path(:,2), path(:,3), 'LineWidth', 2);
grid on;
axis equal;
hold off
