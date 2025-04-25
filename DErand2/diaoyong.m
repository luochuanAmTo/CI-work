% DE_rand_2调用脚本
clear all;
close all;
clc;

%% 1. 参数设置
popsize = 50;       % 种群大小
dimension = 30;     % 问题维度 (典型测试维度)
xmax = 100;         % 搜索空间上限 
xmin = -100;        % 搜索空间下限
vmax = [];          % DE算法不使用速度限制(保留参数但忽略)
vmin = [];          % DE算法不使用速度限制(保留参数但忽略)
maxiter = 1000;     % 最大迭代次数
FuncId = 1;         % 测试函数编号(假设1是Sphere函数)

%% 2. 调用DE/rand/2算法
tic;  % 开始计时
[gbestx, gbestfitness, gbesthistory] = DE_rand_2(...
    popsize, dimension, xmax, xmin, vmax, vmin, maxiter, FuncId);
toc;  % 结束计时

%% 3. 结果展示
disp('===== 优化结果 =====');
disp(['最优解: ', num2str(gbestx)]);
disp(['最优适应度: ', num2str(gbestfitness)]);

% 绘制收敛曲线
figure;
semilogy(gbesthistory, 'LineWidth', 2);
xlabel('迭代次数');
ylabel('最佳适应度(log)');
title('DE/rand/2算法收敛曲线');
grid on;

%% 4. 验证边界约束(可选)
% 检查最终种群是否满足边界约束
final_population = x; % 假设x是最终种群(需在DE_rand_2中返回或保存)
out_of_bounds = sum(final_population(:) > xmax | final_population(:) < xmin);
disp(['超出边界的个体数: ', num2str(out_of_bounds)]);

%% 5. 多次运行统计(可选)
runs = 10;
results = zeros(runs, 1);
for k = 1:runs
    [~, results(k), ~] = DE_rand_2(popsize, dimension, xmax, xmin, [], [], maxiter, FuncId);
end
disp('===== 多次运行统计 =====');
disp(['平均适应度: ', num2str(mean(results))]);
disp(['标准差: ', num2str(std(results))]);
disp(['最佳运行结果: ', num2str(min(results))]);
disp(['最差运行结果: ', num2str(max(results))]);