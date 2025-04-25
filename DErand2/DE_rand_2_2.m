function [gbestx, gbestfitness, gbesthistory] = DE_rand_2(popsize, dimension, xmax, xmin, maxiter, FuncId)
    % 差分进化算法: DE/rand/2
    % 输入参数:
    %   popsize - 种群大小
    %   dimension - 问题维度
    %   xmax - 搜索空间上限
    %   xmin - 搜索空间下限
    %   maxiter - 最大迭代次数
    %   FuncId - 测试函数编号
    % 输出参数:
    %   gbestx - 全局最优解
    %   gbestfitness - 全局最优适应度
    %   gbesthistory - 历代最优适应度记录
    %   final_population - 最终种群
    
    % 参数设置
    F = 0.5;   % 缩放因子
    CR = 0.9;  % 交叉概率
    
    % 初始化种群
    x = xmin + (xmax - xmin) .* rand(popsize, dimension);
    fitnessx = zeros(1, popsize);
    
    % 计算初始适应度
    for i = 1:popsize
        fitnessx(i) = SimpleBenchmark(x(i,:), FuncId);
    end
    
    % 记录最优解
    [gbestfitness, pos] = min(fitnessx);
    gbestx = x(pos,:);
    gbesthistory = zeros(maxiter, 1);
    
    % 主循环
    for iter = 1:maxiter
        for i = 1:popsize
            % 1. 变异操作 (DE/rand/2)
            r = selectID(popsize, i, 5);
            v = x(r(1),:) + F*(x(r(2),:) - x(r(3),:)) + F*(x(r(4),:) - x(r(5),:));
            
            % 2. 交叉操作
            jrand = randi(dimension);
            u = x(i,:);
            for j = 1:dimension
                if rand <= CR || j == jrand
                    u(j) = v(j);
                end
            end
            
            % 边界检查
            u = min(max(u, xmin), xmax);
            
            % 3. 选择操作
            ufitness = SimpleBenchmark(u, FuncId);
            if ufitness < fitnessx(i)
                x(i,:) = u;
                fitnessx(i) = ufitness;
                
                % 更新全局最优
                if ufitness < gbestfitness
                    gbestfitness = ufitness;
                    gbestx = u;
                end
            end
        end
        
        % 记录当前最优
        gbesthistory(iter) = gbestfitness;
        
        % 显示进度
        if mod(iter, 100) == 0
            fprintf('迭代 %d, 最佳适应度: %e\n', iter, gbestfitness);
        end
    end
    
    final_population = x;
end

% 改进的辅助函数：更高效地选择不重复索引
function vec = selectID(popsize, i, count)
    candidates = setdiff(1:popsize, i);  % 排除当前个体
    idx = randperm(length(candidates), count);  % 随机选择count个
    vec = candidates(idx);
end