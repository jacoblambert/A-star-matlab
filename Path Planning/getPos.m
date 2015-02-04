function [ pos ] = getPos( occup_grid, start_pos )
% Randomly generates an open position on the map

if ~exist('start_pos','var')
    start_pos = [0 0];
end

while ~exist('pos','var')
    i = randi([1 size(occup_grid,2)],1,1);
    j = randi([1 size(occup_grid,1)],1,1);
    if (occup_grid(j,i)==0)
        if ~(i==start_pos(1) && j==start_pos(2))
            pos = [i j];
        end
    end
    
end

