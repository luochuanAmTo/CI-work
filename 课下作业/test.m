% test.m
% 参数设置
dim = 30;
pop_size = 40;
max_iter = 3000;
n_runs = 10;  % 重复测试次数
funcIds = 1:15;
algorithms = {'PSO', 'X_PSO', 'DE_rand_1'};

% 预分配存储结果
results = cell(length(funcIds), length(algorithms));
for fid = 1:length(funcIds)
    for aid = 1:length(algorithms)
        results{fid, aid} = zeros(n_runs, max_iter);
    end
end

% 运行测试
for fid_idx = 1:length(funcIds)
    funcId = funcIds(fid_idx);
    fprintf('Testing Function %d...\n', funcId);
    
    for aid = 1:length(algorithms)
        algo = algorithms{aid};
        fprintf('  Algorithm: %s\n', algo);

        % 使用局部变量存储 parfor 输出，防止 cell 索引冲突
        history_mat = zeros(n_runs, max_iter);

        parfor run = 1:n_runs  % 并行执行多个 independent runs
            switch algo
                case 'PSO'
                    history = PSO(dim, pop_size, max_iter, funcId);
                case 'X_PSO'
                    history = X_PSO(dim, pop_size, max_iter, funcId);
                case 'DE_rand_1'
                    history = DE_rand_1(dim, pop_size, max_iter, funcId);
            end
            history_mat(run, :) = history';  % 转置成行向量存储
        end

        % 收集结果
        results{fid_idx, aid} = history_mat;
    end
end

% 绘制收敛曲线和箱图
for fid_idx = 1:length(funcIds)
    funcId = funcIds(fid_idx);
    pso_mean = mean(results{fid_idx, 1}, 1);
    xpso_mean = mean(results{fid_idx, 2}, 1);
    de_mean = mean(results{fid_idx, 3}, 1);
    
    % 收敛曲线
    figure('Position', [100, 100, 800, 600]);
    semilogy(pso_mean, 'b', 'LineWidth', 1.5); hold on;
    semilogy(xpso_mean, 'r', 'LineWidth', 1.5);
    semilogy(de_mean, 'g', 'LineWidth', 1.5);
    title(sprintf('Function %d Convergence Curve', funcId));
    xlabel('Iteration');
    ylabel('Best Fitness (log scale)');
    legend('PSO', 'X\_PSO', 'DE\_rand\_1');
    grid on;
    saveas(gcf, sprintf('func%d_curve.fig', funcId));
    saveas(gcf, sprintf('func%d_curve.png', funcId));
    close;
    
    % 箱图
    final_values = [
        results{fid_idx, 1}(:, end), ...
        results{fid_idx, 2}(:, end), ...
        results{fid_idx, 3}(:, end)
    ];
    
    figure('Position', [100, 100, 600, 400]);
    boxplot(final_values, 'Labels', {'PSO', 'X\_PSO', 'DE\_rand_1'});
    title(sprintf('Function %d Final Fitness Distribution', funcId));
    ylabel('Fitness');
    set(gca, 'YScale', 'log');
    grid on;
    saveas(gcf, sprintf('func%d_boxplot.fig', funcId));
    saveas(gcf, sprintf('func%d_boxplot.png', funcId));
    close;
end

% 生成结果表格
table_data = zeros(length(funcIds), 6);
for fid_idx = 1:length(funcIds)
    for aid = 1:3
        final_fitness = results{fid_idx, aid}(:, end);
        table_data(fid_idx, (aid-1)*2 + 1) = mean(final_fitness);
        table_data(fid_idx, (aid-1)*2 + 2) = std(final_fitness);
    end
end

% 创建并保存表格
var_names = {'PSO_Mean', 'PSO_Std', 'X_PSO_Mean', 'X_PSO_Std', 'DE_Mean', 'DE_Std'};
row_names = arrayfun(@(x)sprintf('Func%02d', x), funcIds, 'UniformOutput', false);
result_table = array2table(table_data, 'VariableNames', var_names, 'RowNames', row_names);
disp(result_table);
writetable(result_table, 'convergence_results.csv', 'WriteRowNames', true);
