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

function line = PointsToLine(P)
    % Remove rows containing NaN or Inf
    P = P(all(isfinite(P),2),:);
    
    % 1. Calculate centroid
    C = mean(P,1);
    
    % 2. PCA
    [coeff,~,~] = pca(P);
    
    % Direction vector of fitted line
    v = coeff(:,1);
    
    % 3. Normal vector to the line
    n = [-v(2); v(1)];
    
    % 4. Calculate a, b, c
    a = n(1);
    b = n(2);
    c = -n' * C';
    
    % Normalize coefficients (optional)
    s = sqrt(a^2 + b^2);
    a = a/s;
    b = b/s;
    c = c/s;
    line = [a b c];
end

function glob_points = LocToGlob(dT, dyaw, yaw, position, vel, points)
    % yaw          : heading at START of scan [rad]
    % dyaw         : yaw rate [rad/s] (assumed constant over the scan)
    % position     : [x y] at START of scan
    % vel          : [vx vy] global velocity [m/s] (use [0 0] to ignore)
    % points       : N x 2 local lidar points, ordered by measurement time
    % T            : scan period [s]
    
    N = size(points,1);
    t = linspace(0, dT, N)';                 % time of each point [s]
    
    theta = yaw(1) + dyaw(1) * t;           % heading per point
    c = cos(theta);  s = sin(theta);
    
    p = points;
    
    gx = c .* p(:,1) - s .* p(:,2);
    gy = s .* p(:,1) + c .* p(:,2);
    
    pos_i = position(:)' + t * vel(:)';     % position per point (N x 2)
    
    glob_points = [gx gy] + pos_i;
end



function globalPoints = localToGlobalPointCloud(angleMin, rangeMin, rangeMax, ranges, position, quat)
robotX = position(1);
robotY = position(2);
quatX = quat(1);
quatY = quat(2);
quatZ = quat(3);
quatW = quat(4);

angleIncrement = (1/360)*2*pi;

% 1. Convert ranges to local LiDAR frame
ranges = double(ranges(:));
numPoints = length(ranges);
angles = double(angleMin) + (0:numPoints-1)' * double(angleIncrement);

validIdx = isfinite(ranges) & (ranges >= double(rangeMin)) & (ranges <= double(rangeMax));

% 2. Shift from LiDAR frame (base_scan) to robot center (base_footprint)
% TurtleBot3 Burger LiDAR is mounted 3.2 cm behind the center of rotation
burgerLidarOffsetX = -0.032; 

robotFrameX = nan(numPoints, 1);
robotFrameY = nan(numPoints, 1);
robotFrameX(validIdx) = (ranges(validIdx) .* cos(angles(validIdx))) + burgerLidarOffsetX;
robotFrameY(validIdx) = ranges(validIdx) .* sin(angles(validIdx));

% 3. Extract Yaw (theta) from the /odom quaternion
w = double(quatW); x = double(quatX); y = double(quatY); z = double(quatZ);
yaw = atan2(2 * (w * z + x * y), 1 - 2 * (y^2 + z^2));

% 4. Rotate and translate into the global (/odom) frame
globalPoints = nan(numPoints, 2);
cosTheta = cos(yaw);
sinTheta = sin(yaw);

globalPoints(validIdx, 1) = double(robotX) + (robotFrameX(validIdx) * cosTheta - robotFrameY(validIdx) * sinTheta);
globalPoints(validIdx, 2) = double(robotY) + (robotFrameX(validIdx) * sinTheta + robotFrameY(validIdx) * cosTheta);
end

function [line, cornerType, angleErr] = PointsToLine(P, offset, side)
% P      : Nx2 points (x forward, y left, robot at origin)
% offset : desired wall distance [m]
% side   : -1 = wall on the right, +1 = wall on the left
% line   : [a b c]; after offset, line(3) = distance error
% cornerType: 0 = wall following, 1 = inner corner (wall ahead),
%             2 = outer corner (arc towards wall), 3 = no data
% angleErr  : heading of the chosen line relative to the robot x axis [rad]

    % ---- tunables ----
    gapTol    = 0.30;   % m, jump between consecutive points that breaks a segment
    splitTol  = 0.03;   % m, max deviation from a straight segment
    minPts    = 8;      % min points per segment
    frontDist = 0.80;   % m, front wall closer than this = inner corner
    MAXSEG    = 12;     % max segments considered

    line = [0 0 0];
    cornerType = 3;
    angleErr = 0;
    if ~isfinite(offset), offset = 0.5; end
    if ~isfinite(side) || side == 0, side = -1; end

    % 1. Use only x,y; clean and order by bearing
    if size(P,2) > 2
        P = P(:,1:2);
    end
    P = P(all(isfinite(P),2),:);
    N = size(P,1);
    if N < minPts
        [line, cornerType, angleErr] = holdLast(line, cornerType, angleErr, true);
        return;
    end
    [~,idx] = sort(atan2(P(:,2),P(:,1)));
    P = P(idx,:);

    % 2. Initial ranges, split at gaps (explicit stack, no recursion)
    stack = zeros(2*MAXSEG,2);
    sp = 0;
    startIdx = 1;
    for i = 1:N-1
        dgap = sqrt((P(i+1,1)-P(i,1))^2 + (P(i+1,2)-P(i,2))^2);
        r = sqrt(P(i,1)^2 + P(i,2)^2);
        if dgap > gapTol + 0.15*r
            if sp < 2*MAXSEG
                sp = sp + 1;
                stack(sp,:) = [startIdx i];
            end
            startIdx = i+1;
        end
    end
    if sp < 2*MAXSEG
        sp = sp + 1;
        stack(sp,:) = [startIdx N];
    end

    % 3. Split ranges until each is straight; accepted ones are stored in segs
    segs = zeros(MAXSEG,2);
    ns = 0;
    while sp > 0
        r1 = stack(sp,1);
        r2 = stack(sp,2);
        sp = sp - 1;
        if (r2 - r1 + 1) < minPts
            continue;
        end
        dx = P(r2,1) - P(r1,1);
        dy = P(r2,2) - P(r1,2);
        len = sqrt(dx^2 + dy^2);
        if len < 1e-9
            continue;
        end
        % perpendicular deviation of each point from the chord
        maxDev = 0;
        maxI = r1;
        for i = r1:r2
            dev = abs(-dy*(P(i,1)-P(r1,1)) + dx*(P(i,2)-P(r1,2))) / len;
            if dev > maxDev
                maxDev = dev;
                maxI = i;
            end
        end
        canSplit = maxDev > splitTol && maxI > r1+2 && maxI < r2-2 ...
                   && sp <= 2*MAXSEG-2;
        if canSplit
            sp = sp + 1; stack(sp,:) = [r1 maxI];
            sp = sp + 1; stack(sp,:) = [maxI r2];
        elseif ns < MAXSEG
            ns = ns + 1;
            segs(ns,:) = [r1 r2];
        end
    end

    % 4. Fit each segment and track best front / best side candidate
    haveFront = false; frontLine = [0 0 0]; frontAng = 0; frontD = inf;
    haveSide  = false; sideLine  = [0 0 0]; sideAng  = 0; sideD  = inf;

    for k = 1:ns
        Pk = P(segs(k,1):segs(k,2),:);
        [ln, ctr, ang] = fitLine(Pk);
        d = ln(3);
        if abs(ln(1)) > 0.7
            % normal points mostly forward -> wall ahead
            if ctr(1) > 0 && d < frontDist && d < frontD
                haveFront = true; frontLine = ln; frontAng = ang; frontD = d;
            end
        else
            if sign(ctr(2)) == side && d < sideD
                haveSide = true; sideLine = ln; sideAng = ang; sideD = d;
            end
        end
    end

    % 5. Choose what to follow
    if haveFront
        cornerType = 1;
        line = frontLine;
        angleErr = frontAng;
    elseif haveSide
        cornerType = 0;
        line = sideLine;
        angleErr = sideAng;
    else
        cornerType = 2;      % outer corner / wall ended
        return;
    end

    line(3) = line(3) - offset;

    ok = all(isfinite(line)) && isfinite(angleErr);
    [line, cornerType, angleErr] = holdLast(line, cornerType, angleErr, ~ok);
end

function [line, cornerType, angleErr] = holdLast(line, cornerType, angleErr, bad)
    persistent lastLine lastAng
    if isempty(lastLine)
        lastLine = [0 0 0];
        lastAng  = 0;
    end
    if bad
        line = lastLine;
        angleErr = lastAng;
        cornerType = 3;
    else
        lastLine = line;
        lastAng  = angleErr;
end
end

function [line, C, ang] = fitLine(P)
% Total-least-squares line fit, closed form (no eig, codegen friendly)
    C = mean(P,1);
    X = P(:,1) - C(1);
    Y = P(:,2) - C(2);
    sxx = sum(X.*X);
    syy = sum(Y.*Y);
    sxy = sum(X.*Y);
    ang = 0.5*atan2(2*sxy, sxx - syy);      % direction angle in (-pi/2, pi/2]
    n = [-sin(ang) cos(ang)];               % unit normal
    c = -(n(1)*C(1) + n(2)*C(2));
    if c < 0
        n = -n;
        c = -c;
    end
    line = [n(1) n(2) c];
end