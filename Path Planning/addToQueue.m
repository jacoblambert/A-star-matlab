function [ queue ] = addToQueue( queue, Q, final_pos )
% addToQueue adds Q to the queue...

    queue.index = [queue.index ; Q.index];
    queue.cost = [queue.cost ; Q.cost];
    man_dist = manDist(Q.index,final_pos);
    queue.manhattan = [queue.manhattan; man_dist];
    queue.priority = [queue.priority; Q.cost + man_dist];

end

