function [ occup_grid ] = getGrid( dim, wall_percent )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - getGrid generates a 2D occupancy grid with randomly generated walls.
% - dim is a structure with dim.xmax, dim.ymax, dim.xmin, dim.ymin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define map size
y_size = dim.ymax - dim.ymin;
x_size = dim.xmax - dim.xmin;

% Generate open map
occup_grid = zeros(y_size,x_size);

% Populate map with walls
num_obstacles = floor(y_size*x_size*wall_percent);

while (size(find(occup_grid==1),1)<num_obstacles)
    i=randi([1 x_size],1,1);
    j=randi([1 y_size],1,1);
    
    occup_grid(j,i)=1;
end
    
end
