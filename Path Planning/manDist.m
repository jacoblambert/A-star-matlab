function [ man_dist ] = manDist( index, final_pos )
% Computes manhattan distance to final position

man_dist = abs(final_pos(1) - index(1)) + abs(final_pos(2) - index(2));

end

