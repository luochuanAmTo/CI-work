clc; 
clear; 
format short;

%% 1. 初始化种群和适应度
rng("shuffle"); % 设置随机种子
population_size = 40;
disp('(1)-随机生成个体适应度：');
fit_original = rand(1, population_size) * 100; % 生成0-100之间的随机适应度

% 显示所有个体适应度
for i = 1:population_size
    fprintf("fit_original(%d) = %.2f\n", i, fit_original(i));
end

% 绘制适应度分布图
figure;
subplot(2,1,1);
bar(fit_original);
title('原始适应度分布');
xlabel('个体编号');
ylabel('适应度值');
grid on;

%% 2. 处理最小化问题 - 使用取倒数的方法
fit_min = 1 ./ (fit_original + eps); 
% 计算适应度比例
p_min = fit_min ./ sum(fit_min);

subplot(2,1,2);
bar(fit_min);
title('最小化问题转换后的适应度');
xlabel('个体编号');
ylabel('转换后适应度');
grid on;

% 显示最小化问题的适应度比例
disp('(2)-最小化问题的适应度比例：');
disp(p_min');

% 绘制最小化问题的适应度比例饼图
figure;
pie(p_min);
title('最小化问题的适应度比例分布');

%% 3. 最大化问题 - 直接使用原始适应度
fit_max = fit_original;
p_max = fit_max ./ sum(fit_max);

% 显示最大化问题的适应度比例
disp('(3)-最大化问题的适应度比例：');
disp(p_max');

% 绘制最大化问题的适应度比例饼图
figure;
pie(p_max);
title('最大化问题的适应度比例分布');

%% 4. 计算适应度比例的累加和
cum_min = cumsum(p_min);
cum_max = cumsum(p_max);

% 绘制累积概率分布图
figure;
subplot(2,1,1);
bar(cum_min);
title('最小化问题的累积概率分布');
xlabel('个体编号');
ylabel('累积概率');
grid on;

subplot(2,1,2);
bar(cum_max);
title('最大化问题的累积概率分布');
xlabel('个体编号');
ylabel('累积概率');
grid on;

%% 5. 轮盘赌选择过程
num_selections = 5; % 选择5个个体
prob = rand(1, num_selections); % 生成选择概率

% 最小化问题的选择
parent_min = zeros(1, num_selections);
for i = 1:num_selections
    parent_min(i) = find(prob(i) <= cum_min, 1);
end

% 最大化问题的选择
parent_max = zeros(1, num_selections);
for i = 1:num_selections
    parent_max(i) = find(prob(i) <= cum_max, 1);
end

% 显示选择结果
disp('(4)-生成随机选择概率数值：');
disp(prob);

disp('最小化问题选择的个体编号：');
disp(parent_min);

disp('最大化问题选择的个体编号：');
disp(parent_max);

%% 6. 可视化轮盘赌选择过程
figure;
% 最小化问题选择可视化
subplot(2,1,1);
plot(cum_min, 'b-o', 'LineWidth', 1.5);
hold on;
for i = 1:num_selections
    line([0, population_size], [prob(i), prob(i)], 'Color', 'r', 'LineStyle', '--');
    selected = parent_min(i);
    plot(selected, cum_min(selected), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    text(selected, cum_min(selected), sprintf(' %d', selected), 'VerticalAlignment', 'bottom');
end
title('最小化问题的轮盘赌选择过程');
xlabel('个体编号');
ylabel('累积概率');
legend('累积概率', '随机数', '选中个体');
grid on;
hold off;

% 最大化问题选择可视化
subplot(2,1,2);
plot(cum_max, 'b-o', 'LineWidth', 1.5);
hold on;
for i = 1:num_selections
    line([0, population_size], [prob(i), prob(i)], 'Color', 'r', 'LineStyle', '--');
    selected = parent_max(i);
    plot(selected, cum_max(selected), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    text(selected, cum_max(selected), sprintf(' %d', selected), 'VerticalAlignment', 'bottom');
end
title('最大化问题的轮盘赌选择过程');
xlabel('个体编号');
ylabel('累积概率');
legend('累积概率', '随机数', '选中个体');
grid on;
hold off;
