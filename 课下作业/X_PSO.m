function [gbest_fitness_history] = X_PSO(dim, pop_size, max_iter, funcId)
% X_PSO - 带收缩因子的改进型粒子群优化算法
% 输入参数：
%   dim       : 搜索维度
%   pop_size  : 种群大小
%   max_iter  : 最大迭代次数
%   funcId    : 测试函数编号
% 输出参数：
%   gbest_fitness_history : 全局最优适应度历史记录

%% 获取测试函数边界
[lb, ub] = getBounds(funcId);

%% 算法参数设置
phi = 4.1;        % 收缩因子参数 (c1 + c2 = 4.1)
k = 2 / abs(phi - 2 + sqrt(phi^2 - 4*phi)); % 收缩因子计算
c1 = 2.05;        % 个体学习因子
c2 = 2.05;        % 社会学习因子

%% 种群初始化
pop_pos = lb + (ub - lb) .* rand(pop_size, dim); % 随机初始化位置
pop_vel = zeros(pop_size, dim);                 % 初始速度为0

%% 计算初始适应度
fitness = arrayfun(@(i) Fitness(pop_pos(i,:), funcId), 1:pop_size)';
pbest_pos = pop_pos;          % 个体历史最优位置
pbest_fitness = fitness;      % 个体历史最优适应度
[gbest_fitness, gbest_idx] = min(fitness); % 全局最优适应度
gbest_pos = pop_pos(gbest_idx, :);         % 全局最优位置

%% 收敛曲线记录
gbest_fitness_history = zeros(max_iter, 1);

%% 主循环
for iter = 1:max_iter
    % ========== 速度更新 ==========
    r1 = rand(pop_size, dim);
    r2 = rand(pop_size, dim);
    pop_vel = k * (pop_vel + c1*r1.*(pbest_pos - pop_pos) + c2*r2.*(gbest_pos - pop_pos));
    
    % ========== 位置更新 ==========
    pop_pos = pop_pos + pop_vel;
    
    % ========== 边界处理 ==========
    pop_pos = max(min(pop_pos, ub), lb);
    
    % ========== 适应度计算 ==========
    new_fitness = arrayfun(@(i) Fitness(pop_pos(i,:), funcId), 1:pop_size)';
    
    % ========== 更新个体最优 ==========
    update_mask = new_fitness < pbest_fitness;
    pbest_pos(update_mask, :) = pop_pos(update_mask, :);
    pbest_fitness(update_mask) = new_fitness(update_mask);
    
    % ========== 更新全局最优 ==========
    [current_min, current_idx] = min(pbest_fitness);
    if current_min < gbest_fitness
        gbest_fitness = current_min;
        gbest_pos = pbest_pos(current_idx, :);
    end
    
    % ========== 记录收敛曲线 ==========
    gbest_fitness_history(iter) = gbest_fitness;
    
    % ========== 进度显示 ==========
    if mod(iter, 500) == 0
        fprintf('Iter %d, Best Fitness = %.4e\n', iter, gbest_fitness);
    end
end
end