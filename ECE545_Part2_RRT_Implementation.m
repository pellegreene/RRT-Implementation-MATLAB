clear all;
close all;
%Rapidly Exploring Random Trees
%Record Planned paths at 40, 100, and 1000 epochs

C = [ 1:4:0.1 1:2:0.1 ];%Configuration Space
O.coordinates =[2.75 .5]; %Obstacle
%G.init(q0)
q0.coordinates = [ 0 0]; %Start point
edges = [];
G = [4 1];%End point
obstacle_dist = sqrt(.25*.25 + .25*.25);
%Going to use the above dist to determine when the
%planner is going to be within the cirle, then not allowing it

node_path = [ q0 ];
found_path = false;
i = 0;
%repeat
while found_path == false
    q_rand = randomConfig();
    q_near = nearest(q_rand, node_path);
    edges = add_edge(q_near, q_rand, edges);
    disp("")
    disp("")
    node_path = [node_path q_rand];
    %If we found the goal
    found_path = check_goal_state(G, node_path);
    i = i+1;
    plot_path(i, edges);
end

function dist = get_dist(point_A, point_B)
    x1 = point_A.coordinates(1);
    x2 = point_B.coordinates(1);
    y1 = point_A.coordinates(2);
    y2 = point_B.coordinates(2);
    x_delta = (x2-x1) * (x2-x1);
    y_delta = (y2-y1) * (y2 - y1);
    dist = sqrt(x_delta + y_delta);
end

%q_rand -> random_config(C)
function q_rand = randomConfig()
    O.coordinates = [2.75 .5]; %Obstacle
    obstacle_dist = sqrt(.25*.25 + .25*.25);
    while 1
        q_rand.coordinates = [ round(rand(1)*4, 1) round(rand(1)*1, 1) ];
        dist = get_dist(q_rand, O);
        if dist > obstacle_dist %Handle obstacle
            break
        end
    end
end

%q_near<- nearest(G, q_rand)
function q_near = nearest(q_rand, node_path)
    nearest_node.coordinates = [4 1]; %Set it to the goal coordinates, because it's the furthest
    starting_node.coordinates = [0 0];
    closest_dist = get_dist(nearest_node, starting_node);
    for i = 1:1:length(node_path)
        dist = get_dist(node_path(i), q_rand);
        if closest_dist > dist %If there's a closer node, capture it
            nearest_node = node_path(i);
            closest_dist = dist;
        end
    end
    q_near = nearest_node;
end

%G.add_edge(q_near,q_rand)
function edges = add_edge(q_near, q_rand, edges)
    %               Source  Dest
    edges = [edges; q_near q_rand ];
end

function found_path = check_goal_state(G, node_path)
    found_path = false;
    for i = 1:1:length(node_path)
        if node_path(i).coordinates == G
            disp("Path found");
            found_path = true;
        end
    end
end

function plot_path(iteration, edges)
    if iteration == 40 || iteration == 100 || iteration == 1000
        figure
        hold on
        rectangle("Position",[0 0 4 1]); %Set up C Spcae
        axis([0 4 0 1])
        rectangle("Position", [2.5 .5 .25 .25], "Curvature", [1 1])
        for i = 1:1:length(edges)
            x_vector = [edges(i, 1).coordinates(1) edges(i, 2).coordinates(1)];
            y_vector = [edges(i, 1).coordinates(2) edges(i, 2).coordinates(2)];
            plot(x_vector, y_vector)
        end
        hold off
    end
end