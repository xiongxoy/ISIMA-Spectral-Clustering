function [IDX] = image_seg(I, k)
% This function is used for segmenting an image
% @param I the input image, only gray scale image is allowed
% @param k the image should be segemented into k parts
% @param types the type of features used
% @return IDX is the index assigned to each pixel
  if nargin < 2
    error('Error: Not Enough Argument.')
  end

  if nargin == 2
    types = 'Intensity';
  end

  [p q] = size(I);
  IDX1 = spectral_clustering_segmentation(I, k);
  IDX = reshape(IDX1, p, q);
end


function IDX = spectral_clustering_segmentation(I, k)
  F = feature_extractor(I);
  A = compute_similarity(F);
  IDX = spectral_clustering_from_affinity_mat(A, k);
end
