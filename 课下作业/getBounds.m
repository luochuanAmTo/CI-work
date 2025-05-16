function [lb, ub] = getBounds(funcId)
    switch funcId
        case {1,2,3,4,5,6,7}
            lb = -100; ub = 100;
        case 8
            lb = -500; ub = 500;
        case 9
            lb = -30; ub = 30;
        case 10
            lb = -1.28; ub = 1.28;
        case 11
            lb = -600; ub = 600;
        case 12
            lb = -32; ub = 32;
        case {13,14}
            lb = -5.12; ub = 5.12;
        case 15
            lb = -0.5; ub = 0.5;
        otherwise
            error('Invalid function ID');
    end
end