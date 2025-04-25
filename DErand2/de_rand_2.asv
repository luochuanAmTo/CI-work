function [gbestx, gbestfitness, gbesthistory,final_population] = DE_rand_2(popsize, dimension, xmax, xmin, vmax, vmin, maxiter, FuncId)
    % 差分进化算法: DE/rand/2
    % 修改说明：将变异策略改为DE/rand/2，需要选择5个不同个体
    
    % 空间分配
    x = rand(popsize, dimension);  % 存储整个种群
    v = rand(popsize, dimension);   % 存储有效向量
    u = rand(popsize, dimension);   % 存储试验向量
    fitnessx = rand(1, popsize);    % 存储个体适应度
    
    gbesthistory = rand(maxiter, 1); % 收敛曲线记录
    
    F = 0.5;  % 缩放因子
    CR = 0.9; % 交叉概率
    
    ComputeFitness = @SimpleBenchmark; % 设置适应度函数
    
    % 种群初始化
    for i = 1:popsize
        x(i,:) = xmin + (xmax - xmin) .* rand(1, dimension);
        fitnessx(i) = ComputeFitness(x(i,:), FuncId);
    end
    
    [gbestfitness, pos] = min(fitnessx);
    gbestx = x(pos,:);
    
    iter = 1;
    while iter <= maxiter
        for i = 1:popsize
            %% 1. DE/rand/2变异：选择5个不同个体
            r = selectID(popsize, i, 5);  % 选择5个不同索引
            r1 = r(1); r2 = r(2); r3 = r(3); r4 = r(4); r5 = r(5);
            
            % DE/rand/2变异公式
            v(i,:) = x(r1,:) + F*(x(r2,:) - x(r3,:)) + F*(x(r4,:) - x(r5,:));
            
            %% 2. 交叉操作
            jrand = randi([1,dimension]);
            for j = 1:dimension
                if (rand <= CR || j == jrand)
                    u(i,j) = v(i,j);
                else
                    u(i,j) = x(i,j);
                end
            end
            
            %% 3. 选择操作
            ufitness = ComputeFitness(u(i,:), FuncId);
            if ufitness <= fitnessx(i)
                x(i,:) = u(i,:);
                fitnessx(i) = ufitness;
            end
        end
        
        %% 4. 更新全局最优
        [gbestfitness, gbestid] = min(fitnessx);
        gbestx = x(gbestid,:);
        gbesthistory(iter) = gbestfitness;
        
        fprintf("算法DE/rand/2, 第%d代, 最佳适应度 = %e\n", iter, gbestfitness);
        iter = iter + 1;
    end
end

% 辅助函数：选择n个不重复且不等于i的索引
function ids = selectID(popsize, i, n)
    ids = [];
    while length(ids) < n
        candidate = randi(popsize);
        if candidate ~= i && ~ismember(candidate, ids)
            ids = [ids, candidate];
        end
    end
end