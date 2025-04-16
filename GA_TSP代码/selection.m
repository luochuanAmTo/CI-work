function [newpop] = selection(pop, fitness)
% 选择操作：轮盘赌的方法选择出新的种群个体

[row, ~] = size(pop);
newpop = zeros(size(pop));

switch randi(2)
    case 1 % 轮盘赌方法
        fitness = 1 ./ fitness;  % 适应度越小（路径越短）越好，取倒数
        prob = fitness / sum(fitness); % 概率归一化
        cumprob = cumsum(prob);        % 累加概率

        for i = 1:row
            r = rand;
            idx = find(cumprob >= r, 1, 'first');
            newpop(i,:) = pop(idx,:);
        end

    case 2 % 竞标赛方法（锦标赛）
        k = 3; % 每次从中随机挑k个竞争
        for i = 1:row
            candidates = randi([1 row], 1, k);
            [~, best] = min(fitness(candidates));
            newpop(i,:) = pop(candidates(best), :);
        end
end
end
