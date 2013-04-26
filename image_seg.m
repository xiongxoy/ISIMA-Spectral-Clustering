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
function A = feature_fusion(D, d_max, type)
  % TODO 分别计算特征，然后乘起来，就得到了我们需要的特征
  % 现在是简答相乘，不考虑Feature的特性，应该有一个预处理的函数
  % 先写个dummy函数吧
  % F{i, f_number} -> D{i,j,f_number} -> sigma = max(D) / 6 ->
  % W(i,j) = W(i,j) * exp( (D{i,j}/sigma)^2 ) ->
  % norm(i1-i2, j1-j2) in range/not in range
  [n, n, k] = size(D);
  A = (D(:, :, 1) ./ (d_max(1) / 6)) .^ 2;
  for i = 2:k
    A = A + (D(:, :, i) ./ (d_max(i) / 6)) .^ 2;
  end
  A = exp(-A);
end

function IDX = spectral_clustering_segmentation(I, k, type)
  F = feature_extractor(I, type);
  [D, d_max] = compute_similarity(F, type);
  A = feature_fusion(D, d_max, type);
  A = positional_filtering(A, F);
  IDX = spectral_clustering_from_affinity_mat(A, k);
end

function A = positional_filtering(A, F)
  %% deal with position feature
  [p q k] = size(F);
  n = p*q;
  pos_max = norm([n, n] - [1 1]);
  for i = 1:n
    for j = 1:n
      [p_xi p_yi] = get_index(i, p, q);
      [p_xj p_yj] = get_index(j, p, q);
      d = norm([p_xi p_yi] - [p_xj p_yj]);
      if d > pos_max / 5
        A(i, j) = 0;
      else
        A(i, j) = A(i, j) * exp( -(d/( pos_max./6 )).^2 );
      end
    end
  end
end

function [D d_max] = compute_similarity(F, type)
  p = size(F, 1);
  q = size(F, 2);
  f_nr = size(F, 3);
  D = zeros(p*q, p*q, f_nr);
  d_max = zeros(1, f_nr);

  for i = 1:p*q
    for j = 1:p*q
      for k = 1:f_nr
        [p_xi p_yi] = get_index(i, p, q);
        [p_xj p_yj] = get_index(j, p, q);
        D(i, j, k) = norm( F{p_xi, p_yi, k} - F{p_xj, p_yj, k} );
        if D(i, j, k) > d_max(k)
          d_max(k) = D(i, j, k);
        end
      end
    end
  end

end

function [p_x p_y] = get_index(i, p, q)
  % i = (p_x-1) * q + p_y
  p_y = mod(i, q);
  i = i - p_y;
  p_x = i / q + 1;
end
