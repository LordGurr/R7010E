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

function path = blend_points(a,b)
    qdmax = [1 1 1];
    %q0 = [0 -1 0]*scaler;
    
    % Sampling time
    dt = 0.1;
    
    % Acceleration time
    tacc = 50;
    path = mstraj(b, qdmax, [],a, dt, tacc);
end
qdmax = [1 1 1];
%q0 = [0 -1 0]*scaler;

% Sampling time
dt = 0.1;

% Acceleration time
tacc = 50;

% Create segments
r = linspace(4, 2.5, 500);
path = generate_helix_path(37, r, 0.1);
r = linspace(3.5, 2.5, 500);
path2 = generate_helix_path(25, r, 0.1);
path2 = rotate_path(120, path2) +[3 -5 39];
path3 = generate_helix_path(25, r, 0.1);
path3 = rotate_path(-120, path3) +[-3 -5 39];
path4 = [
0 -10 41;
3 -5 41;
3 6 41;
0 6 41;
-3 6 41;
-3 -5 41;
0 -5 45;
0 6 45;
0 6 37;
0 2 37;
5 2 39;
5 2 43];
path4 = mstraj(path4, qdmax, [], tail(path3,1), dt, tacc);
path5 = generate_helix_path(25, r, 0.1);
path5 = path5 +[0 -5 44];
% Connect path segments
path = [path; blend_points(tail(path,1), head(path2))];
path2 = [path2; blend_points(tail(path2,1), head(path3))];
path3 = [path3; blend_points(tail(path3,1), head(path4))];
path4 = [path4; blend_points(tail(path4,1), head(path5))];
% Combine
path = [path; path2; path3; path4; path5];

% Plot the 3D spiral
plot3(path(:,1), path(:,2), path(:,3), 'LineWidth', 2);
grid on;
axis equal;
hold off
