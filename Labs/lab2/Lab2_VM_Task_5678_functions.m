function glob_points = fcn(yaw,position,points)
    x_rot = position(1) + (points(1,:)-position(1))*cos(yaw) -(points(2,:)-position(2))*sin(yaw);
    y_rot = position(2) + (points(1,:)-position(1))*sin(yaw) -(points(2,:)-position(2))*cos(yaw);
    rot_points = [x_rot; y_rot];
    glob_points = rot_points+position';
end
function glob_points = fcn(dyaw, yaw, position, points)
    theta = yaw(1);
    dtheta = dyaw(1);
    theta = theta+dtheta;
    R = [cos(theta), -sin(theta);
        sin(theta),  cos(theta)];

    glob_points = points * R' + position(:)';
end

function points = point_cloud(ranges)
l=length(ranges);
points = zeros(l, 2);
for i = 1:l
    if ~isinf(ranges(i))
        angle = (i/l) * 2*pi;
        points(i,:) = [ranges(i)*cos(angle), ...
            ranges(i)*sin(angle)];
    end
end
end


function points = point_cloud2(ranges)
l = length(ranges);
points = zeros(l, 2);

for i = 1:l
    if isfinite(ranges(i)) && ranges(i) > 0
        angle = (i-1) * (2*pi/l);

        points(i,:) = [
            ranges(i)*cos(angle), ...
            ranges(i)*sin(angle)
            ];
    end
end
end

function points = point_cloud3(ranges,angle_min,angle_max)
ranges = ranges(:);
l = length(ranges);
angles = linspace(angle_min, angle_max, l)';
valid = isfinite(ranges) & ranges >= 0.12 & ranges <= 3.5;
points = [ranges.*cos(angles), ranges.*sin(angles)];
points(~valid,:) = NaN;   % NaN so they don't plot at the origin
end

function ptCloud = scanToPointCloud(AngleMin, AngleMax, RangeMin, RangeMax, Ranges)
r = double(Ranges(:));
n = numel(r);

if n > 1
    inc = (AngleMax - AngleMin) / (n - 1);
else
    inc = 0;
end
angles = AngleMin + (0:n-1)' * inc;

% Drop inf, NaN, and out-of-range readings
valid = isfinite(r) & r >= RangeMin & r <= RangeMax;
r = r(valid);
a = angles(valid);

xyz = [r.*cos(a), r.*sin(a), zeros(size(r))];
ptCloud = pointCloud(xyz);   % Computer Vision Toolbox
end