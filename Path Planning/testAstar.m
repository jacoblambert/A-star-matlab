% test A-star
 time = [];
for i=1:1000
    tic
    optimal_path = A_star;
    time = [time; toc];
end
    