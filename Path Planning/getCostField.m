function [ cost_field ] = getCostField( occup_grid, queue, dead, status, optimal_path)
% This function generates a occupancy grid used for plotting
% Status == 1, each cell contains the cost-to-go
% Status == 2, each cell contains the state of that cell (dead, alive,
% unvisited, in queue)

N_row = size(occup_grid,1);
N_col = size(occup_grid,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if status == 1
    % Set walls
    occup_grid(occup_grid==1)=Inf;
    
    % Add costs
    N=size(queue.cost,1);
    for i=1:N
        occup_grid(queue.index(i,2),queue.index(i,1))=queue.cost(i);
    end

    N=size(dead.cost,1);
    for i=1:N
        occup_grid(dead.index(i,2),dead.index(i,1))=dead.cost(i);
    end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if status == 2 
    % Set walls
    occup_grid(occup_grid==1)=4;
    
    % Alive
    N=size(queue.cost,1);
for i=1:N
    occup_grid(queue.index(i,2),queue.index(i,1)) = 1;
end

    % Dead
N=size(dead.cost,1);
for i=1:N
    occup_grid(dead.index(i,2),dead.index(i,1)) = 2;
end

    % Next state to be expanded
    if ~exist('optimal_path','var')
        if ~isempty(queue.cost)
            [~, Q_index] = min(queue.priority);
            Q.index = queue.index(Q_index,:);
            occup_grid(Q.index(2),Q.index(1)) = 3;
        end
    else
        N_path = size(optimal_path,1);
        for i=1:N_path
            occup_grid(optimal_path(i,2),optimal_path(i,1)) = 3;
        end
    end
    
end

% pcolor cuts off last row and last column...

cost_field = zeros(N_row+1,N_col+1);
cost_field(1:N_row,1:N_col) = occup_grid;

end

