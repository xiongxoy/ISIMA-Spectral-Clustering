function [i, j] = get_index(c, p, q)
% c = (i-1) * q + j,  1 <= j <= q
  if mod(c, q) ~= 0
    i = floor(c / q) + 1;
    j = c - (i-1) * q;
  else
    i = c / q ;
    j = q;
  end
end

