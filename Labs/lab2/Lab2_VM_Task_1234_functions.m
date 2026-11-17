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

function theta_out = angular_velocity(desired_position,y,x,theta, slow_dist)
    d_theta = desired_position(3);
    desired_position = desired_position(1:2);
    position = [x y];
    Kp = 0.07;
    
    %x2=desired_position[1];
    %y2=desired_position[2];
    
    % Get direction towards goal
    direction =desired_position-position;
    distance= norm(direction);
    if (distance < slow_dist)
        error = mod(d_theta-theta + pi, 2*pi) - pi;
        theta_out=error*Kp;
        return;
    end
    dir = atan2(direction(2),direction(1));
    error = mod(dir-theta + pi, 2*pi) - pi;
    % Compare with current heading
    if(abs(error)<0.1)
        theta_out=0;
        return;
    end
    % Deciding direction to rotate
    theta_out=error*Kp;
    %theta_out=clip(theta_out,-0.2,0.2);
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
