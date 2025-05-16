function [best_fitness_history] = DE_rand_1(dim, pop_size, max_iter, funcId)
    % 根据测试函数设置搜索范围
    [lb, ub] = getBounds(funcId);
    
    % 参数设置
    F = 0.5;    % 缩放因子
    CR = 0.9;   % 交叉概率
    
    % 初始化种群
    pop = lb + (ub - lb) .* rand(pop_size, dim);
    fitness = arrayfun(@(i) Fitness(pop(i,:), funcId), 1:pop_size)';
    [best_fitness, best_idx] = min(fitness);
    best_fitness_history = zeros(max_iter, 1);
    
    for iter = 1:max_iter
        new_pop = pop;
        new_fitness = fitness;
        
        for i = 1:pop_size
            % 随机选择三个不同的个体
            idxs = 1:pop_size;
            idxs(i) = [];
            r = idxs(randperm(length(idxs), 3));
            r1 = r(1); r2 = r(2); r3 = r(3);
            
            % 变异操作
            v = pop(r1, :) + F * (pop(r2, :) - pop(r3, :));
            
            % 交叉操作
            u = pop(i, :);
            cross_points = rand(1, dim) < CR;
            if sum(cross_points) == 0
                cross_points(randi(dim)) = true;
            end
            u(cross_points) = v(cross_points);
            
            % 边界处理
            u = max(min(u, ub), lb);
            
            % 选择操作
            u_fitness = Fitness(u, funcId);
            if u_fitness < new_fitness(i)
                new_pop(i, :) = u;
                new_fitness(i) = u_fitness;
                if u_fitness < best_fitness
                    best_fitness = u_fitness;
                end
            end
        end
        
        pop = new_pop;
        fitness = new_fitness;
        best_fitness_history(iter) = best_fitness;
    end
end
