function [gbest_fitness_history] = PSO(dim, pop_size, max_iter, funcId)
    % 根据测试函数设置搜索范围
    [lb, ub] = getBounds(funcId);
    
    % 参数设置
    w = 0.729;     % 惯性权重
    c1 = 1.49445;  % 个体学习因子
    c2 = 1.49445;  % 社会学习因子
    
    % 初始化种群
    pop_pos = lb + (ub - lb) .* rand(pop_size, dim);
    pop_vel = zeros(pop_size, dim);
    
    % 计算初始适应度
    fitness = arrayfun(@(i) Fitness(pop_pos(i,:), funcId), 1:pop_size)';
    pbest_pos = pop_pos;
    pbest_fitness = fitness;
    [gbest_fitness, gbest_idx] = min(fitness);
    gbest_pos = pop_pos(gbest_idx, :);
    
    % 保存收敛曲线
    gbest_fitness_history = zeros(max_iter, 1);
    
    for iter = 1:max_iter
        % 更新速度和位置
        r1 = rand(pop_size, dim);
        r2 = rand(pop_size, dim);
        pop_vel = w * pop_vel + c1 * r1 .* (pbest_pos - pop_pos) + c2 * r2 .* (gbest_pos - pop_pos);
        pop_pos = pop_pos + pop_vel;
        
        % 边界处理
        pop_pos = max(min(pop_pos, ub), lb);
        
        % 计算新适应度
        new_fitness = arrayfun(@(i) Fitness(pop_pos(i,:), funcId), 1:pop_size)';
        
        % 更新个体最优和全局最优
        update_idx = new_fitness < pbest_fitness;
        pbest_pos(update_idx, :) = pop_pos(update_idx, :);
        pbest_fitness(update_idx) = new_fitness(update_idx);
        
        [current_gbest, current_idx] = min(pbest_fitness);
        if current_gbest < gbest_fitness
            gbest_fitness = current_gbest;
            gbest_pos = pbest_pos(current_idx, :);
        end
        
        gbest_fitness_history(iter) = gbest_fitness;
    end
end