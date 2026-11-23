filename = 'uneven_wall_follow.gif';
save_gif=true;
for T= 1:10:length(theta.Time)
    t = theta.Time(T);

    k = find(points.Time==t);
    plot(points.Data(:,1,k),points.Data(:,2,k),'o')
    hold on
    %plotPosHead(x,y,theta)
    plot(x.Data, y.Data, 'b-', 'LineWidth', 1.5); 
    hold on
    %k = find(theta.Time==t)
    psi_arrow = theta.Data(T);
    u = cos(psi_arrow);
    v = sin(psi_arrow);
    x_arrow = x.Data(T);
    y_arrow = y.Data(T);

    quiver(x_arrow, y_arrow, u, v, 0.5, 'r', 'LineWidth', 1.5, 'MaxHeadSize', 0.5);
    hold on
    a = line.Data(1,:,T);
    b = line.Data(2,:,T);
    c = line.Data(3,:,T);

    x_line = linspace(x_arrow-5, x_arrow+5, 100);
    y_line = -(a * x_line + c) / b;

    plot(x_line, y_line, 'LineWidth', 2)
    axis equal
    xlim([x_arrow-10 x_arrow+10])
    %ylim([-10 -6])
    hold off
    %pause(0.01);

    % Capture current figure
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind, cm] = rgb2ind(im, 256);
    if(save_gif)
        % Write to GIF
        if T == 1
            imwrite(imind, cm, filename, 'gif', ...
                'LoopCount', inf, 'DelayTime', 0.01);
        else
            imwrite(imind, cm, filename, 'gif', ...
                'WriteMode', 'append', 'DelayTime', 0.01);
        end
    end
end




%total_points = reshape(permute(points.Data, [1, 3, 2]), [], size(points.Data, 2));
%plot(total_points(:,1),total_points(:,2),'o')
