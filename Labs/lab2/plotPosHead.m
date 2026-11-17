function plotPosHead(x_out, y_out, psi_out)
    % Extract data and time from Timeseries objects
    t = x_out.Time;
    x = x_out.Data;
    y = y_out.Data;
    psi = psi_out.Data; % Note: If heading is in degrees, use deg2rad(psi_out.Data)
    
    % Create a 1-second time grid from start to end of simulation
    t_1sec = (t(1) : 100 : t(end))';
    
    % Interpolate X, Y, and Heading at every 1-second mark
    x_arrow = interp1(t, x, t_1sec);
    y_arrow = interp1(t, y, t_1sec);
    psi_arrow = interp1(t, psi, t_1sec);
    
    % Calculate arrow vector components (u = dx, v = dy)
    u = cos(psi_arrow);
    v = sin(psi_arrow);
    
    % Plot the continuous trajectory
    figure;
    plot(x, y, 'b-', 'LineWidth', 1.5); 
    hold on;
    
    % Overlay red heading arrows every 1 second
    % The '0.5' at the end scales the arrow length; adjust as needed
    quiver(x_arrow, y_arrow, u, v, 0.5, 'r', 'LineWidth', 1.5, 'MaxHeadSize', 0.5);
    
    % Format the graph
    grid on;
    axis equal; % Keeps angles visually accurate
    ax = gca;
    %ax.DataAspectRatio = [1 1 1];
    ax.DataAspectRatioMode = 'manual';
    ax.PlotBoxAspectRatioMode = 'manual';
    xlabel('X Position');
    ylabel('Y Position');
    title('Trajectory with Heading Arrows (1s Intervals)');
    legend('Path', 'Heading');
    hold off;
end