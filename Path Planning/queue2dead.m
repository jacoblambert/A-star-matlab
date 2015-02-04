function [ queue, dead ] = queue2dead(queue, dead, Q_index)
% Removes the entry in queue with index Q_index and moves it to the dead

% Add at the end of the dead states
dead.index = [dead.index; [queue.index(Q_index,1) queue.index(Q_index,2)]];
dead.cost = [dead.cost ; queue.cost(Q_index)];
dead.manhattan = [dead.manhattan ; queue.manhattan(Q_index)];
dead.priority = [dead.priority ; queue.priority(Q_index)];

% Logical index, the one to be removed is set to false
index = true(1,size(queue.cost,1));
index(Q_index) = false;

% Remove from queue
queue.index = queue.index(index,:);
queue.cost = queue.cost(index);
queue.manhattan = queue.manhattan(index);
queue.priority = queue.priority(index);

end

