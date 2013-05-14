function test_get_index()
% c = (i-1) * q + j,  1 <= j <= q
p = 10;
q = 10;
c = 1;
for i = 1:p
  for j = 1:q
    [x y] = get_index(c, p, q);
    if x ~= i
      disp('A')
    end
    if y ~= j
      disp('B')
    end
    c = c+1;
  end
end
