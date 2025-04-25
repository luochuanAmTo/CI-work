% 参数设置
popsize = 50;
dimension = 30;
xmax = 100;
xmin = -100;
maxiter = 1000;
FuncId = 1;  % 假设1对应Sphere函数

% 运行算法
[bestx, bestf, history] = DE_rand_2_2(popsize, dimension, xmax, xmin, maxiter, FuncId);

% 结果可视化
figure;
semilogy(history);
xlabel('迭代次数');
ylabel('最佳适应度(log)');
title('DE/rand/2优化过程');
grid on;