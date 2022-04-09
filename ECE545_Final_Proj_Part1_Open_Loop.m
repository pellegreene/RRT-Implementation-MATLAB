t0 = .01; %seconds

%Open-Loop Section
for i = 1:5 %Five iterations
    %Create Robot
   robot_x = [0.1 0.2 0.5 0.3 0.9];
   robot_y = [0.1 0.6 0.23 0.75 0.4];
   robot_theta = [0 2.0 1.3 .89 .25];
   path_plot = [];
   
   %Create Goal
   goal_x = [0.3 0.2 0.74 0.82 0.5];
   goal_y = [0.45 0.1 0.21 0.7 1.0];
   goal_theta = [1.0 .02 0.15 0.89 1.7];
   
   adjust_angle1 = false;
   adjust_angle2 = false;
   adjust_x_position = true;
   adjust_y_position = false;
   
   current_x = robot_x(i);
   current_y = robot_y(i);
   current_theta = robot_theta(i);
   
   current_goal_x = goal_x(i);
   current_goal_y = goal_y(i);
   current_goal_theta = goal_theta(i);
   
   %Run Simulation
   for t = 1:1000 %Ten Seconds in milliseconds   
       time = t*t0;
       v_t = .1; %m/s
       w_t = .1*sin(.5*time); %rad/s
       
%        current_x = current_x + t0 * cos(current_theta) * v_t;
%        current_y = current_y + t0 * sin(current_theta) * v_t;
%        current_theta = current_theta + t0 * w_t;
%        
%        path_plot = [path_plot; current_x current_y current_theta];
       if adjust_x_position == true
           current_x = current_x + t0 * cos(current_theta)*v_t;
           if mod(time, 1) == 0
               adjust_angle1 = true;
               adjust_x_position = false;
               path_plot = [path_plot; current_x current_y current_theta];
               continue
           end
       end
       
       if adjust_angle1 == true
           current_theta =  current_theta + t0 * w_t;
           if mod(time, 1) == 0
               adjust_y_position = true;
               adjust_angle1 = false;
               path_plot = [path_plot; current_x current_y current_theta];
               continue
           end
       end
       
       if adjust_y_position == true
           current_y = current_y + t0 * sin(current_theta)*v_t;
           if mod(time, 1) == 0
               adjust_angle2 = true;
               adjust_y_position = false;
               path_plot = [path_plot; current_x current_y current_theta];
               continue
           end
       end
       
       if adjust_angle2 == true
           current_theta =  current_theta + t0 * w_t;
           if mod(time, 1) == 0
               adjust_x_position = true;
               adjust_angle2 = false;
               path_plot = [path_plot; current_x current_y current_theta];
               continue
           end
       end

       path_plot = [path_plot; current_x current_y current_theta];
       if current_x == current_goal_x && current_y == current_goal_y
           disp("Found goal")
           continue
       end
       
   end
   t = 1:1000;
   x_path = path_plot(:,1);
   y_path = path_plot(:,2);
   theta_path = path_plot(:,3);
   
   figure
   legend
   plot(t, x_path, t, y_path, "--", t, theta_path, ":");
   xlabel("Time")
   legend("X", "Y", "Theta");
end



% robot_x = robot_x + t0 * cos(robot_theta) * v_t;
%        robot_y = robot_y + t0 * sin(robot_theta) * v_t;
%        robot_theta = robot_theta + t0 * w_t;


