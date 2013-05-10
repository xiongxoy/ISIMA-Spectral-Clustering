function F_ = normalize_features(F)
%% normalize to gaussian
  d = size(F{1});
  [p q] = size(F);

  S = ones(p*q, d);
  for i = 1:p
    for j = 1:q
      S( (i-1)*q + i ) = F{i, j};
    end
  end

  S_mean = mean(S);
  S_sigma = sqrt(var(S));
  for i = 1:p
    S(i, :) = (S(i, :) - S_mean) ./ S_sigma;
  end

  for i = 1:p
    for j = 1:q
      F{i, j} = S( (i-1)*q + i , :);
    end
  end

  F_ = F;
end
