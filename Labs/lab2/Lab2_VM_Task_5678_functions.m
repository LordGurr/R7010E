function glob_points = fcn(yaw,position,points)
x_rot = position(1) + (points(1,:)-position(1))*cos(yaw) -(points(2,:)-position(2))*sin(yaw);
y_rot = position(2) + (points(1,:)-position(1))*sin(yaw) -(points(2,:)-position(2))*cos(yaw);
rot_points = [x_rot; y_rot];
glob_points = rot_points+position';