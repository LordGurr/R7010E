x = points.Data(:,1,1);
y = points.Data(:,2,1);
%plot(x,y,'o')



%plot(ranges.Data(2,:))

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

new_points = point_cloud2(ranges.Data(2,:));
plot(new_points(:,1),new_points(:,2),'o')