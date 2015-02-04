function [ optimal_path ] = getOptimalPath(dead, start_pos, final_pos )

%%%%%% Outputs the indices of the optimal path from start to finish %%%%%%

% Start at final_pos 
optimal_path = final_pos;
current_pos = final_pos;
found=0;

% Initialize
next_pos.index = [];
next_pos.cost = []; 

while found==0

%%%% If they are in the dead list, add neighbors to a potential queue %%%%

% Up
U.index = [current_pos(1) current_pos(2)-1];
U_index = find(dead.index(:,1)==U.index(1) & dead.index(:,2)==U.index(2),1);
if ~isempty(U_index)
    next_pos.index = [next_pos.index; U.index];
    next_pos.cost = [next_pos.cost; dead.cost(U_index)];
end

% Down
D.index = [current_pos(1) current_pos(2)+1];
D_index = find(dead.index(:,1)==D.index(1) & dead.index(:,2)==D.index(2),1);
if ~isempty(D_index)
    next_pos.index = [next_pos.index; D.index];
    next_pos.cost = [next_pos.cost; dead.cost(D_index)];
end

% Left
L.index = [current_pos(1)-1 current_pos(2)];
L_index = find(dead.index(:,1)==L.index(1) & dead.index(:,2)==L.index(2),1);
if ~isempty(L_index)
    next_pos.index = [next_pos.index; L.index];
    next_pos.cost = [next_pos.cost; dead.cost(L_index)];
end

% Right
R.index = [current_pos(1)+1 current_pos(2)];
R_index = find(dead.index(:,1)==R.index(1) & dead.index(:,2)==R.index(2),1);
if ~isempty(R_index)
    next_pos.index = [next_pos.index; R.index];
    next_pos.cost = [next_pos.cost; dead.cost(R_index)];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[~, Q_index] = min(next_pos.cost);
current_pos = next_pos.index(Q_index,:);
optimal_path = [optimal_path; current_pos];

if find(optimal_path(:,1)==start_pos(1) & optimal_path(:,2)==start_pos(2))
    found=1;
end

next_pos.index = [];
next_pos.cost = []; 

end

optimal_path = flipud(optimal_path);

end

