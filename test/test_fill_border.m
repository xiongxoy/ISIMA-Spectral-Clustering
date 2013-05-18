S = zeros(8,8);
S(4:5, 4:5) = [1 2; 3 4]
S = num2cell(S);
S = fill_border(S, 3)