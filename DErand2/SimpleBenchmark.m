function f = SimpleBenchmark(x, FuncId)
    % 示例目标函数，根据 FuncId 选择不同函数
    switch FuncId
        case 1
            f = sum(x.^2); % Sphere 函数
        case 2
            f = sum(abs(x)) + prod(abs(x)); % Schwefel's Problem 1.2
        otherwise
            error('未知的 FuncId');
    end
end
