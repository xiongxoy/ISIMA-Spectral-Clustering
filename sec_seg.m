function IDX = sec_seg(I, k)
I = SEC(I)
if true
%% use EM for Mixture of Gaussian
  IDX = reshape(emgm(I(:)', k), size(I));
elseif true
  IDX = kmeans(I);
else
%% use Spectral Clustering
  F = feature_extractor(I, 'I');
  A = compute_similarity(F);
  IDX = spectral_clustering_from_affinity_mat(A, k);
end
end
