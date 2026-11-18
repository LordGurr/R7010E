% Functions used in Lab2_VM_Task_1234.slx

function theta = quaternionToYaw(x,y,z,w)

    theta = atan2(2*(w*z + x*y), ...
        1 - 2*(y*y + z*z));

end

function dir = Angle(desired_position,y,x)
    position = [x y];
    
    %x2=desired_position[1];
    %y2=desired_position[2];
    
    % Get direction towards goal
    desired_position = desired_position(1:2);
    direction =desired_position-position;
    dir = atan2(direction(2),direction(1));
end

function [throttle, theta_out, dir, error] = controller(desired_position,y,x,theta, slow_dist, prev_theta, dt)
    slow_speed=0.01;
    d_theta =-1;
    if (length(desired_position)>2)
        d_theta = desired_position(3);
        %desired_position = desired_position(1:2);
    end
    position = [x y];
    Kp = 0.1;
    Kd= 0.2;
    %x2=desired_position[1];
    %y2=desired_position[2];
    
    % Get direction towards goal
    direction =desired_position(1:2)-position;
    distance= norm(direction);
    dir = atan2(direction(2),direction(1));
    theta_diff = mod(theta-prev_theta + pi, 2*pi) - pi;
    if distance < slow_dist
        if (d_theta==-1)
            theta_out = 0;
            throttle = 0;
            error=0;
            return;
        end            
        % Final orientation error
        error = mod(d_theta - theta + pi, 2*pi) - pi;

        % Angular velocity
        theta_rate = theta_diff / dt;

        % Controller gains
        Kp_final = 0.8;
        Kd_final = 0.3;

        % PD controller
        theta_out = Kp_final*error - Kd_final*theta_rate;

        % Limit angular velocity
        max_angular = 0.3;
        theta_out = max(min(theta_out, max_angular), -max_angular);

        % Stopping condition
        if abs(error) < 0.03 && abs(theta_rate) < 0.04
            theta_out = 0;
            throttle = 0;
            return;
        end

        % Low forward velocity during final alignment
        throttle = slow_speed;

        return;
    end
    error = mod(dir-theta + pi, 2*pi) - pi;
    % Compare with current heading
    
    % Deciding direction to rotate
    theta_out=error*Kp- (theta_diff/(dt+1e-5))*Kd;
    theta_out=clip(theta_out,-0.5,0.5);
    %throttle = 0.5 * max(0, 1 - abs(error)/pi);
    if(abs(theta_out)>0.02)
        throttle = slow_speed;
    else
        throttle = 0.5;
    end
end

function throttle = Linear_Velocity(desired_position,y,x,Angular_Velocity, slow_dist)
    slow_speed=0.01;
    if(abs(Angular_Velocity)>0.02)
        throttle = slow_speed;
        return
    end
    position = [x y];
    
    %x2=desired_position[1];
    %y2=desired_position[2];
    
    % Get direction towards goal
    desired_position = desired_position(1:2);
    
    direction =desired_position-position;
    %dir = rad2deg(atan2(direction(2),direction(1)));
    distance= norm(direction);
    if (distance < slow_dist)
        throttle = slow_speed;
        return
    end
    throttle = min(distance, 0.5);
end

function [throttle, theta_out, dir, error] = controller(desired_position,y,x,theta, slow_dist, prev_theta, dt)
    slow_speed=0.01;
    d_theta = desired_position(3);
    desired_position = desired_position(1:2);
    position = [x y];
    Kp = 0.1;
    Kd= 0.2;
    %x2=desired_position[1];
    %y2=desired_position[2];
    
    % Get direction towards goal
    direction =desired_position-position;
    distance= norm(direction);
    dir = atan2(direction(2),direction(1));
    theta_diff = mod(theta-prev_theta + pi, 2*pi) - pi;
    if distance < slow_dist
    
        % Final orientation error
        error = mod(d_theta - theta + pi, 2*pi) - pi;
    
        % Angular velocity
        theta_rate = theta_diff / dt;
    
        % Controller gains
        Kp_final = 0.8;
        Kd_final = 0.3;
    
        % PD controller
        theta_out = Kp_final*error - Kd_final*theta_rate;
    
        % Limit angular velocity
        max_angular = 0.3;
        theta_out = max(min(theta_out, max_angular), -max_angular);
    
        % Stopping condition
        if abs(error) < 0.03 && abs(theta_rate) < 0.04
            theta_out = 0;
            throttle = 0;
            return;
        end
    
        % Low forward velocity during final alignment
        throttle = slow_speed;
    
        return;
    end
    error = mod(dir-theta + pi, 2*pi) - pi;
    % Compare with current heading
    
    % Deciding direction to rotate
    theta_out=error*Kp- (theta_diff/(dt+1e-5))*Kd;
    theta_out=clip(theta_out,-0.5,0.5);
    %throttle = 0.5 * max(0, 1 - abs(error)/pi);
    if(abs(theta_out)>0.02)
        throttle = slow_speed;
    else
        throttle = 0.5;
    end
end

function [index,desired_position] = Navigator(index, x,y,theta, pattern)
    square_motion = [0 10 0; 10 10 0; 10 0 0; 0 0 0];
    j_motion = [
    0 0 0;
    5.6533 0 0;
    5.6533 -8.1659 0;
    3.3501 -9.4221 0;
    0.8375 -9.2128 0;
    0 -7.3283 0
    ];
    % Store paths in a cell array
    patterns = {square_motion, j_motion};

    % Select current path
    current_pattern = patterns{pattern};

    % Get current waypoint
    desired_position = current_pattern(index,:);

    % Check distance to waypoint
    if norm(desired_position(1:2) - [x y]) < 0.12

        % Calculate angular error
        angle_error = mod(desired_position(3) - theta + pi, 2*pi) - pi;

        if abs(angle_error) < 0.4

            % Advance waypoint index and wrap around
            index = mod(index, size(current_pattern,1)) + 1;

            % Update desired waypoint
            desired_position = current_pattern(index,:);
        end
    end
end