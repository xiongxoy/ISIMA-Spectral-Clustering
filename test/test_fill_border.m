S = zeros(6,6);
S(3:4, 3:4) = [1 2; 3 4];
S_ = fill_border(S, d);
b = (S_ == [1 1 1 2 2 2;
       1 1 1 2 2 2;
       1 1 1 2 2 2;
       3 3 3 4 4 4;
       3 3 3 4 4 4;
       3 3 3 4 4 4]);
if ~b
  error('failed: test_fill_border');
end
