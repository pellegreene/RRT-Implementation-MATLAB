clear all;
close all;

t0=0.01;

x_path = [];
y_path = [];
theta_path = [];

%Robot Properties
current_x = 0;
current_y = 0;
current_theta = 0;

%Goal Properties
desired_x = 0.5000;
desired_y = 0.5000;
desired_theta = 0.5230;% 30 Degrees in radians

%Set up proportional constants
k_rho = .99;
k_alpha = 1;
k_beta = -.1157;
for i = 1:108 %108 loops to convergence
    %Calculate deltas
    delta_y = (desired_y - current_y);
    delta_x = (desired_x - current_x);
    delta_theta = (desired_theta - current_theta);
    
    
    rho = sqrt((desired_y - current_y) + (desired_x - current_x));
    alpha = -current_theta + atan2(delta_y,delta_x);
    beta = -current_theta - alpha;

    %Update the matrix
    next_rho = -(k_rho) * rho*cos(alpha);
    next_alpha = -(sin(alpha)/rho - 1);
    next_beta = -(sin(alpha)/rho);

    %Set up motion variables
    v = k_rho * rho;
    w = k_alpha*alpha + k_beta*beta;
    
    if current_x ~= desired_x
        current_x = current_x + t0*cos(current_theta)*v;
    else
        current_x = desired_x;
    end
    
    if current_y~= desired_y
        current_y = current_x + t0*sin(current_theta)*v;
    else
        current_y = desired_y;
    end
    
    if current_theta ~= desired_theta
        current_theta = current_theta + t0*w;
    else
        current_theta = desired_theta;
    end
    
    rho = next_rho;
    alpha = next_alpha;
    beta = next_beta;
    
    x_path = [x_path current_x];
    y_path = [y_path current_y];
    theta_path = [theta_path current_theta];
end

subplot(1, 3, 1);
plot(0.1:.1:10.8, x_path);
title("X Values over Time");
xlabel("Time")
ylabel("Position")

subplot(1, 3, 2);
plot(0.1:.1:10.8, y_path);
title("Y Values over Time");
xlabel("Time")
ylabel("Position")

subplot(1, 3, 3);
plot(0.1:.1:10.8, theta_path);
title("Theta Values over Time");
xlabel("Time")
ylabel("Angle")

figure
plot(x_path, y_path)
title("X and Y Positions");
xlabel("X Position")
ylabel("Y Position")
