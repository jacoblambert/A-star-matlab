function [ status ] = examineState(Q, queue, dead, occup_grid)
% examineState checks the status of the state.
% Q: structure with Q.index and Q.cost
% queue: structure of alive states with queue.index, queue.cost,
% queue.manhattan, queue.priority
% dead: structure of dead states same as queue.
% occup_grid: 2D occupancy grid

% status:
% 0 = DO NOTHING (state is dead || out of bounds || occupied || or in queue
% with a lower cost-to-go
% 1 = ADD TO QUEUE (state is unvisited)
% 2 = REPLACE IN QUEUE (state is already in queue but this one has lower
% cost to go

% Check state versus map
while ~exist('status','var')
    
% check if out of bounds
    if (Q.index(1)<1 || Q.index(2)<1 || Q.index(1)>size(occup_grid,2) ...
            || Q.index(2)>size(occup_grid,1))
        status = 0;
        return
    end

% check if occupied 
    if (occup_grid(Q.index(2),Q.index(1))==1)
        status = 0;
        return
    end
    
% check if state is dead
if ~(isempty(dead.index))
    if find(dead.index(:,1)==Q.index(1) & dead.index(:,2)==Q.index(2))
        status = 0;
        return
    end
end
    
% check if is in queue
    queue_index = find(queue.index(:,1)==Q.index(1) & queue.index(:,2)==Q.index(2));

% if its not in queue, then its unvisited
     if isempty(queue_index)
         status = 1;
         return
     end
    
    if queue.cost(queue_index)<=Q.cost
        status = 0;
        return
    end
    
    if queue.cost(queue_index)>Q.cost
        status = 2;
        return
    end
    
end

end

