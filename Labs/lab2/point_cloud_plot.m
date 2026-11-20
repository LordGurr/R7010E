x = points.Data(:,1,1);
y = points.Data(:,2,1);
%plot(x,y,'o')



plot(ranges.Data(2,:))


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

%newPoints = scanToPointCloud(0,2*pi,0.12,3.5,ranges.Data(2));
%plot(new_points(:,1),new_points(:,2),'o')

%newPoints = scanToPointCloud(0, pi, 0.12, 3.5, ranges.Data(2,:));
%plot(newPoints.Location(:,1), newPoints.Location(:,2), 'o')
%for k= 1:100:size(points.Data,3)
    %new_points = point_cloud3(ranges.Data(k,:),0,pi*2);
    %new_points = point_cloud(ranges.Data(2,:));
    %axis equal
    %plot(new_points(:,1),new_points(:,2),'o')
    %plot(points.Data(:,1,k),points.Data(:,2,k),'o')

    %pause(0.02);
    %k
%end



total_points = reshape(permute(points.Data, [1, 3, 2]), [], size(points.Data, 2));
plot(total_points(:,1),total_points(:,2),'o')
