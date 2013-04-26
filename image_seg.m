function [IDX] = image_seg(I, k, type)
% This function is used for segmenting an image
% @param I the input image, only gray scale image is allowed
% @param k the image should be segemented into k parts
% @param type the type of features used
% @return IDX is the index assigned to each pixel
  if nargin < 2
    error('Error: Not Enough Argument.')
  end

  if nargin == 2
    type = 'Intensity'
  end

  [p q] = size(I);
  IDX1 = spectral_clustering_segmentation(I, k, type)
  IDX = reshape(IDX1, p, q);
end

%% TODO S is a matrix of cells,
%% each colum is a factor of wij
%% the 2-norm of S{i}{f_number} - S{j}{f_number} is D(i,j)
function W = feature_fusion(F, type)
  % TODO 分别计算特征，然后乘起来，就得到了我们需要的特征
  % 现在是简答相乘，不考虑Feature的特性，应该有一个预处理的函数
  % 先写个dummy函数吧
  Fval = feature_evaluate(F, type);
  % F{i, f_number} -> D{i,j,f_number} -> sigma = max(D) / 6 ->
  % W(i,j) = W(i,j) * exp( (D{i,j}/sigma)^2 ) ->
  % norm(i1-i2, j1-j2) in range/not in range
  [p q] = size(F);
  D = cell(p, p, q);

end

function Fval = feature_evaluate(F, type)
  Fval = F;
end

function IDX = spectral_clustering_segmentation(I, k, type)
  %% extract features
  F = feature_extractor(I, type);
  %% feature fusion
  S = feature_fusion(F, type);
  IDX = spectral_clustering(S, k);
  %% get affinity matrix

  %% get Laplacian matrix
  %% clustering with k-means
  %% return index
end

function sig = compute_sigma(S)

end

