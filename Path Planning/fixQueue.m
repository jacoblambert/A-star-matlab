function [ queue ] = fixQueue( queue, Q )
% Corrects an incorrect queue entry (cost2go lower than estimated)

% find Q in queue
index = find(queue.index(:,1)==Q.index(1) & queue.index(:,2)==Q.index(2));
queue.cost(index) = Q.cost; % correct cost
queue.priority(index) = queue.manhattan(index) + Q.cost; % correct G+H

end

