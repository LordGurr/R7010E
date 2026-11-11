close all
clear all
clc
%% 

function path = generate_fountain_path()
    height = 16.5;
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
    path = [x' y' z'];
end

q = generate_fountain_path();



ptCloud = pcread('fountain.ply');
pcshow(ptCloud);
hold on

% Plot the 3D spiral
plot3(q(:,1), q(:,2), q(:,3))
grid on;
axis equal;
hold off

%% Testing

function tests = mavRequirementsTest
    tests = functiontests(localfunctions);
end

function testSafetyDistance(testCase, mavPositions)
    ptCloud = pcread('fountain.ply');          % or your own pointCloud
    %mavPositions = computeWaypoints(ptCloud);   % N x 3, YOUR code under test
    
    pts = double(ptCloud.Location);
    mavPositions = double(mavPositions);
    [~, d] = knnsearch(pts, mavPositions);      % nearest cloud point per waypoint
    
    safetyDist = 1.0;
    tol = 1e-6;
    verifyGreaterThanOrEqual(testCase, min(d), safetyDist - tol, ...
        sprintf('MAV came within %.3f m of the structure', min(d)));
end
%testCase = mavRequirementsTest();

%testSafetyDistance(testCase, q)
