%% Stochastic ensemble consensus implementation
function IDX = SEC(I)
  I = I ./ 255;
  n = 20; % nr of class
  m = 150; % nr of subclasses
  IDX = get_Ks(I, m);

  p_t_when_s  = 1 / abs(t-s).^0.6;
end
function f_N_t = generate_ensemble(I, s)
% TODO how to generate_ensemble
end
function ks = consensus_func(s, n_t, I, IDX)
  foo = [];
  for i = 1:size(n_t, 1)
    Phi = compute_Phi_s_ti(I, s, n_t(i, :));
    bar = ones(1, Phi) .* IDX(n_t(i, 1), n_t(i, 2));
    foo = [foo bar];
  end
  ks = median(foo);
end
function Phi = compute_Phi_s_ti(I, s, n_t)
% TODO (6) is not clear
  alpha = 20; w = 0.4;

  term1 = 0;
  for i = 1:size(n_t, 1);
    foo = I(s(1), s(2)) - I(n_t(i, 1), n_t(i, 2));
    foo = foo ^ 2;
    term1 = term1 + foo/((1+foo)*w);
  end
  Phi = round(alpha * exp(term1));
end
function IDX = compute_Ks(I, m)
  IDX = zeros(size(I));
  for i = 1:size(IDX, 1) * size(IDX, 2)
    IDX(i) = round(m * I(i));
  end
end
