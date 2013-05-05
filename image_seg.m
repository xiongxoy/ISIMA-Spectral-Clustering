function [IDX] = image_seg(I, k, types)
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
  IDX1 = spectral_clustering_segmentation(I, k, types);
  IDX = reshape(IDX1, p, q);
end

%% TODO S is a matrix of cells,
%% each colum is a factor of wij
%% the 2-norm of S{i}{f_number} - S{j}{f_number} is D(i,j)
function A = get_affinity_mat(D, d_max)
  % W(i,j) = W(i,j) * exp( (D{i,j}/sigma)^2 ) ->
  % norm(i1-i2, j1-j2) in range/not in range
  A = (D(:, :) ./ (d_max / 6)) .^ 2;
  sprintf('sigma is %d. \n', d_max / 6);
  A = exp(-A);
end

function IDX = spectral_clustering_segmentation(I, k, types)
  F = feature_extractor(I, types);
  A = compute_similarity(F);
  IDX = spectral_clustering_from_affinity_mat(A, k);
end

