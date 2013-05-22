function IDX = texture_seg(I, k)
  F = texture_analyser(I);
  F = normalize_features(F);
  A = compute_similarity(F);
  toc;
  tIDX = spectral_clustering_from_affinity_mat(A, k);
  toc;
  IDX = reshape(tIDX, size(F));
  toc;
end
