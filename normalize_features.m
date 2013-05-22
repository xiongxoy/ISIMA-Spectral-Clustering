function F_ = normalize_features(F)
%% normalize to gaussian
  d = max(size(F{1}));
  [p q] = size(F);

  S = zeros(p*q, d);
  for i = 1:p*q
    S(i, :) = F{i};
  end

  S_mean = mean(S);
  S_sigma = sqrt(var(S));
  for i = 1:p*q
    S(i, :) = (S(i, :) - S_mean) ./ S_sigma;
  end

  for i = 1:p*q
    F{i} = S(i, :);
  end

  F_ = reshape(F, size(F));
end
