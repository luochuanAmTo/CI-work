function [newpop] =crossoverPMX(pop,pc)
%% 交叉操作（映射交叉）：适用于TSP问题
[row,col]=size(pop);
newpop = zeros(size(pop)); % 修正初始化方式

for i=1:2:row-1
    if rand <= pc
        % 1.选择两个随机交叉点
        points = sort(randperm(col,2));
        c1 = points(1);
        c2 = points(2);
        
        % 2.映射交叉操作
        parent1 = pop(i,:);
        parent2 = pop(i+1,:);
        child1 = parent1;
        child2 = parent2;
        
        % 中间段交换
        child1(c1:c2) = parent2(c1:c2);
        child2(c1:c2) = parent1(c1:c2);
        
        % 处理冲突（部分映射）
        % 处理child1的非中间段
        for j = [1:c1-1, c2+1:col]
            while ismember(child1(j), child1(c1:c2))
                idx = find(parent2(c1:c2) == child1(j));
                child1(j) = parent1(c1 + idx - 1);
            end
        end
        
        % 处理child2的非中间段
        for j = [1:c1-1, c2+1:col]
            while ismember(child2(j), child2(c1:c2))
                idx = find(parent1(c1:c2) == child2(j));
                child2(j) = parent2(c1 + idx - 1);
            end
        end
        
        newpop(i,:) = child1;
        newpop(i+1,:) = child2;
    else
        newpop(i,:) = pop(i,:);
        newpop(i+1,:) = pop(i+1,:);
    end
end
end