%% Stochastic ensemble consensus implementation
function IDX = SEC(I)
if true
  I = double(I);
  I = I ./ 255;
  m = 150; % nr of subclasses
  IDX = compute_ks(I, m)
else
  I = double(I);
  IDX = image_seg(I, 3);
  IDX = double(IDX);
end
  for i = 1:1
    IDX = one_pass(IDX, I)
  end
end
function IDX_ = one_pass(IDX, I)
  [p q] = size(IDX);
  IDX_ = zeros(size(IDX));
  for i = 1:p
    for j = 1:q
      T = generate_ensemble(size(IDX), [i j]);
      IDX_(i, j) = consensus_func([i j], T, I, IDX);
    end
  end
end
function T = generate_ensemble(I_size, s)
  p = I_size(1);
  q = I_size(2);
  T = [];
  for i = 1:p
    for j = 1:q
      %p_in  = 1 / norm([i j]-s).^0.6;
      p_in  = 1 / norm([i j]-s);
      if rand <= p_in
        T(end+1, :) = [i j];
      end
    end
  end
end
function ks = consensus_func(s, T, I, IDX)
  foo = [];
  for i = 1:size(T, 1)
    phi = compute_phi_s_ti(I, s, T(i, :));
    bar = ones(1, phi) .* IDX(T(i, 1), T(i, 2));
    foo = [foo bar];
  end
  %if mod(size(foo, 2), 2) == 0
  %end
  ks = round(median(foo));
end
function phi = compute_phi_s_ti(I, s, t)
  beta = 2;
  phi = exp(-beta * (I(s(1), s(2))-I(t(1), t(2)))^2 );
  phi = round(phi);
end
function phi = compute_phi_s_ti_old(I, s, T)
  alpha = 20; w = 0.4;

  term1 = 0;
  for i = 1:size(T, 1);
    foo = I(s(1), s(2)) - I(T(i, 1), T(i, 2));
    foo = foo ^ 2;
    term1 = term1 + exp(-foo/((1+foo)*w));
  end
  phi = round(alpha * term1);
end
function IDX = compute_ks(I, m)
  IDX = zeros(size(I));
  for i = 1:size(IDX, 1) * size(IDX, 2)
    IDX(i) = round(m * I(i));
  end
end
