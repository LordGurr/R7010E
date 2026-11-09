% Define parameter t for the spiral turns
t = linspace(0, 10*pi, 500);

% Spiral radius and vertical growth rate
r = 3;
c = 0.1;

% Parametric equations
x = r * cos(t);
y = r * sin(t);
z = c * t;

% Plot the 3D spiral
plot3(x, y, z, 'LineWidth', 2);
grid on;
axis equal;

title('3D Spiral Plot');
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');