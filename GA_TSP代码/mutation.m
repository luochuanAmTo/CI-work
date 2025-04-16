function [newpop] =mutation(pop,pm)
%% 变异操作：解决TSP问题
[row,col]=size(pop);
newpop = pop;

for i=1:row
    if rand<=pm
        % 3.1 产生两个不同变异点
        pos = randperm(col,2);
        
        % 3.2 执行交换变异（swap mutation）
        temp = newpop(i,pos(1));
        newpop(i,pos(1)) = newpop(i,pos(2));
        newpop(i,pos(2)) = temp;
    end
end
end