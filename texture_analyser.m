function IDX = texture_analyser(I, k)
%% classify each piexl by texture
  d = 2;
  s = size(I);
  F = cell(s);
  %threshold whole image
  %level = graythresh(I);
  %I = im2bw(I, level);
  tic;
  for i=1+d:s(1)-d
    for j=1+d:s(2)-d
        F{i,j} = texture_extractor(I(i-d:i+d, j-d:j+d));
    end
  end
  F = fill_border(F, d);
  toc;
  IDX = texture_seg(F, k);
end

function IDX = texture_seg(F, k)
  A = compute_similarity(F);
  toc;
  tIDX = spectral_clustering_from_affinity_mat(A, k);
  toc;
  IDX = reshape(tIDX, size(F));
  toc;
end


