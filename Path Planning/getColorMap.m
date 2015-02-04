function [ cmap ] = getColorMap(status)
%%% Generates colormap

% Rainbow
if status == 1
    cmap = flipud(colormap('jet')); % the jet colormap is so fucking hot
    cmap(1,:) = zeros(3,1); % make first entry be white (unvisited)
    cmap(end,:) = ones(3,1); % make last entry black (walls)
    cmap = flipud(cmap);
end

% Dead or Alive
% 0 = White (unvisited), 1 = Green (Alive), 2 = Red (Dead) 3 = Yellow (Path), 
% 4 = Black (wall)
if status == 2
cmap = [1 1 1; 0 1 0; 1 0 0; 1 1 0; 0 0 0];
end

end

