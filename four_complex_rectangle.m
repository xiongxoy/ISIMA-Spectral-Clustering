function  I = four_complex_rectangle()
  I = zeros(40, 40);
  c1 = 50;
  c2 = 200;
  p = 50;
  q = 50;
  I = zeros(p, q);
  I(1:p/2, 1:q/2) = c1;
  I(1:p/2, q/2+1:q) = c2;
  I(p/2+1:p, q/2+1:q) = c1;
  I(p/2+1:p, 1:q/2) = c2;

  I(1:p/2, 1:q/2) = add_gradient(I(1:p/2, 1:q/2), 0, 150,'x');
  I(p/2+1:p, 1:q/2) = add_texture(I(p/2+1:p, 1:q/2), 20, [5, 1], c1);
  I(1:p/2, q/2+1:q) = add_dots(I(1:p/2, q/2+1:q), 7, c1);
  
  I = uint8(I);
  imagesc(I);
end

function I_ = add_dots(I, d, c)
  [p q] = size(I);
  i = 1;
  while i < p*q
    I(i) = c;
    i = i + d;
  end
  I_ = I;
end
% use the supidest way which works
function I_ = add_texture(I, d, v, c)
  [p q] = size(I);
  i = 1;
  v = v ./ norm(v);
  % projection on axis 1
  d_1 = [1 0] * v';
  % projection on axis 2
  d_2 = [0 1] * v';
  while i <= p
    I = draw_line(I, [i, 1], v, c);
    i = i + d_1 * d;
  end
  i = 1;
  while i <= q
    I = draw_line(I, [1, i], v, c);
    i = i + d_2 * d;
  end
  I_ = I;
end
function I_ = draw_line(I, start, v, c)
  point = floor(start);
  point_ = point;
  v = v ./ norm(v);
  [p q] = size(I);
  while point(1) <= p && point(2) <= q
    I(point(1), point(2)) = c;
    point_ = point_ + v;
    point = floor(point_);
  end
  I_ = I;
end
function I_ = add_gradient(I, g_min, g_max, direction)
  if strcmpi('y', direction) == 1
    % gradient for direction y
    d = size(I, 1);
    g_step = (g_max - g_min) / d;
    for i = 1:d
      I(i, :) = g_min;
      g_min = g_min + g_step;
    end
  else
    % gradient for direction x
    d = size(I, 2);
    g_step = (g_max - g_min) / d;
    for i = 1:d
      I(:, i) = g_min;
      g_min = g_min + g_step;
    end
  end
  I_ = I;
end
