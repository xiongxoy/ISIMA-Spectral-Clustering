function IDX = texture_analyser(I)
%% classify each piexl by texture
  d = 2;
  s = size(I);
  F = cells(s);
  for i=1:s(1)
    for j=1:s(2)
      try
        F{i,j} = {texture_extractor(I(i-d:i+d; j-d:j+d))};
      catch err_msg
        ;
    end
  end
  F = fill_border(F, d);
  IDX = texture_seg(F, k);
end

function IDX = texture_seg(F, k)
  A = compute_similarity(F);
  tIDX = spectral_clustering_from_affinity_mat(A, k);
  IDX = reshape(tIDX, size(F));
end

function fill_border(S, d)
% fill corners
  s = size(S);
  for i=1:d
    for j=1:d
      F{i,j} = F{d+1, d+1};
      F{s(1)-i, j} = F{s(1)-d, d+1};
      F{s(1)-i, s(2)-j} = F{s(1)-d, s(2)-d};
      F{i, s(2)-j} = F{d+1, S(2)-d};
    end
  end
% fill edge
  for i=d+1:s(1)-d
    for j=1:d
      F{i, j} = F{i, d+1};
    end
  end
  for i=1:d
    for j=d+1:s(2)-d
      F{i, j} = F{d+1, j};
    end
  end
  for i=s(1)-d+1:s(1)
    for j=d+1:s(2)-d
      F{i, j} = F{s(1)-d, j};
    end
  end
  for i = d+1:s(1)-d
    for j = s(2)-d+1:s(2)
      F{i, j} = F{i, s(2)-d};
    end
  end
end

