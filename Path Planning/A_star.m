function [ optimal_path ]= A_star(occup_grid, start_pos, final_pos)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             _      _____      _   _      __ _           _ _             %
%     /\   /\| |/\  |  __ \    | | | |    / _(_)         | (_)            %
%    /  \  \ ` ' /  | |__) |_ _| |_| |__ | |_ _ _ __   __| |_ _ __   __ _ %
%   / /\ \|_     _| |  ___/ _` | __| '_ \|  _| | '_ \ / _` | | '_ \ / _` |%
%  / ____ \/ , . \  | |  | (_| | |_| | | | | | | | | | (_| | | | | | (_| |%
% /_/    \_\/|_|\/  |_|   \__,_|\__|_| |_|_| |_|_| |_|\__,_|_|_| |_|\__, |%
%                                                                    __/ |%
% by Jacob Lambert                                                  |___/ %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialization

clear all
close all
clc
echo on

%%%%%%%%%%%%%%%%%%%%%%%%%%% Input Variable %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% occup_grid : 2D Occupancy Grid (Occupancy matrix, 0 = open, 1 = dead)
if ~exist('occup_grid','var') %% generate random grid if a map is not given
    dim.xmax=200;
    dim.xmin=0;
    dim.ymax=120;
    dim.ymin=0;
    wall_percent=0.35;
    occup_grid = getGrid(dim,wall_percent);
end   
% Origin of the map (1,1) is top left corner

% start_pos : Initial position on occup_grid (x,y)
if ~exist('start_pos','var')
    start_pos = getPos(occup_grid);
end

% final_pos : Goal on the map
if ~exist('final_pos','var')
    final_pos = getPos(occup_grid,start_pos);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%% Output Variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% optimalpath = optimal path ...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%% Initialize variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%
found = 0; % path finding convergence
% the queue of squares to visit
queue.index = []; % matrix position (index) (x,y)->(i,j)
queue.cost = []; % G cost-to-go from start_pos
queue.manhattan = []; % H manhattan distance to final_pos
queue.priority = [];% F = G + H visiting priority
% the list of visited squares we are done with
dead.index = []; 
dead.cost = []; 
dead.manhattan = []; 
dead.priority = [];
% initiate queue
queue.index = start_pos;
queue.cost = 0;
queue.manhattan = manDist(start_pos,final_pos);
queue.priority = queue.cost(1) + queue.manhattan(1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%% Optimal Path Search %%%%%%%%%%%%%%%%%%%%%%%%%%%%
while (found==0)

[~, Q_index] = min(queue.priority); % Find state to expand next

%%%%%%%%%%% Check neighbours and perform necessary operations %%%%%%%%%%%%%

%%%% Up %%%
U.index = [queue.index(Q_index,1) queue.index(Q_index,2)-1]; % Locate state within map
U.cost = queue.cost(Q_index)+1;
status = examineState(U, queue, dead, occup_grid); % Check the status of that state
%fprintf('Status of up with index [%d %d] neighbour is %d\n',U.index(1),U.index(2),status)

if status==1
    queue = addToQueue(queue, U, final_pos);
end
if status==2
    queue = fixQueue(queue, U);
end

%%%% Down %%%
D.index = [queue.index(Q_index,1) queue.index(Q_index,2)+1]; % Locate state within map
D.cost = queue.cost(Q_index)+1;
status = examineState(D, queue, dead, occup_grid); % Check the status of that state
%fprintf('Status of down with index [%d %d] neighbour is %d\n',D.index(1),D.index(2),status)

if status==1
    queue = addToQueue(queue, D, final_pos);
end
if status==2
    queue = fixQueue(queue, D);
end

% Left
L.index = [queue.index(Q_index,1)-1 queue.index(Q_index,2)]; % Locate state within map
L.cost = queue.cost(Q_index)+1;
status = examineState(L, queue, dead, occup_grid); % Check the status of that state
%fprintf('Status of left with index [%d %d] neighbour is %d\n',L.index(1),L.index(2),status)

if status==1
    queue = addToQueue(queue, L, final_pos);
end
if status==2
    queue = fixQueue(queue, L);
end

%%% Right %%%
R.index = [queue.index(Q_index,1)+1 queue.index(Q_index,2)]; % Locate state within map
R.cost = queue.cost(Q_index)+1;
status = examineState(R, queue, dead, occup_grid); % Check the status of that state
%fprintf('Status of right with index [%d %d] neighbour is %d\n',R.index(1),R.index(2),status)

if status==1
    queue = addToQueue(queue, R, final_pos);
end
if status==2
    queue = fixQueue(queue, R);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%% Move Q to the dead states %%%%%%%%%%%%%%%%%%%%%%%%%%%

[queue, dead] = queue2dead(queue,dead,Q_index);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Make plots %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % Set colormap
%     cmap = getColorMap(2);
%     colormap(cmap);
% 
% % Compute cost field
%     cost_field = getCostField(occup_grid,queue,dead,2);
%     cost_field(final_pos(2),final_pos(1))=0;
%     
% % Make plot
%     hold on
%     pcolor(cost_field)
%     plot(start_pos(1)+0.5,start_pos(2)+0.5,'g*','MarkerSize',10,'LineWidth',1)
%     plot(final_pos(1)+0.5,final_pos(2)+0.5,'y*','MarkerSize',10,'LineWidth',1)
%     hold off
%     drawnow

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Are we done? %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if find(queue.index(:,1)==final_pos(1) & queue.index(:,2)==final_pos(2))
    found = 1;
end

if isempty(queue.cost)
    found = 2;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

if found==1
    disp('Goal has been reached :)');
end
if found==2
    disp('No path found :(')
    optimal_path = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if found==1
%%%%%%%%%%%%%%%%%%%%%%%%% Compute Optimal Path %%%%%%%%%%%%%%%%%%%%%%%%%%%%

optimal_path = getOptimalPath(dead,start_pos,final_pos);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PLOTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Set colormap
    cmap = getColorMap(2);
    colormap(cmap);

% Compute cost field
    cost_field = getCostField(occup_grid,queue,dead,2,optimal_path);
    cost_field(final_pos(2),final_pos(1))=0;
    
% Make plot
    hold on
    pcolor(cost_field)
    plot(start_pos(1)+0.5,start_pos(2)+0.5,'g*','MarkerSize',10,'LineWidth',1)
    plot(final_pos(1)+0.5,final_pos(2)+0.5,'y*','MarkerSize',10,'LineWidth',1)
    hold off
    drawnow

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
% Set colormap
    cmap = getColorMap(1);
    colormap(cmap);

% Compute cost field
    cost_field = getCostField(occup_grid,queue,dead,1);
    cost_field(final_pos(2),final_pos(1))=0;
    
% Make plot
    hold on
    pcolor(cost_field)
    plot(start_pos(1)+0.5,start_pos(2)+0.5,'g*','MarkerSize',10,'LineWidth',1)
    plot(final_pos(1)+0.5,final_pos(2)+0.5,'y*','MarkerSize',10,'LineWidth',1)
    hold off
    drawnow

end
