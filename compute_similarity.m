function A = compute_similarity(F)
% In this function the similarity between each feature point is computed
% Point to far from each other are not comsidered
  p = size(F, 1);
  q = size(F, 2);

  r = 1e5;
  D = zeros(p*q, p*q);
  d_max = 0;

  n = p*q;
  for i = 1:n
    for j = 1:i
      fi = F{i};
      fj = F{j};
      if point_distance(i, j, p, q) <= r
        D(i, j) = norm(double(fi - fj));
        if D(i, j) > d_max
          d_max = D(i, j);
        end
      end
      D(j, i) = D(i, j);
    end
  end

  P = zeros(n, n);
  p_max = min(r, floor( (n-1) * sqrt(2) ));
  %% deal with position information
  for i = 1:n
    for j = 1:i
      tmp = point_distance(i, j, p, q);
      if tmp <= r
        P(i, j) = tmp; % otherwise it would be 0;
      end
      P(j, i) = P(i, j);
    end
  end

  figure;clf;
  imagesc(D);
  title 'distance mat of D'
  figure;clf;
  imagesc(P);
  title 'distance mat of P'
  %D = D ./ d_max;
  %P = P ./ p_max;

  A1 = get_affinity_mat(D, d_max);
  A2 = get_affinity_mat(P, p_max, 4.0);
  %A =  A1 .* A2;
  A = A1;
  for i = 1:n
    for j = 1:i
      if point_distance(i, j, p, q) > r
        A(i, j) = 0;
        A(j, i) = 0;
      end
    end
  end

  figure;clf;
  imagesc(A1)
  title 'affinity mat of D'
  figure;clf;
  imagesc(A2)
  title 'affinity mat of P'
  figure;clf;
  imagesc(A);
  save('A');
  title 'affinity mat of final A'
  pause; close all;
end

function A = get_affinity_mat(D, d_max, sigma_)
  if nargin == 3
    my_sigma = sigma_;
  else
    my_sigma = d_max / 7;
  end
  A = (D(:, :) ./ my_sigma) .^ 2;
  idx_diag = boolean(eye(size(D)));
  sprintf('sigma is %d. \n', my_sigma)  %debug
  A = exp(-A);
  A(idx_diag) = 0;
end

function d = point_distance(i, j, p, q)
  [p1_i, p1_j] = get_index(i, p, q);
  [p2_i, p2_j] = get_index(j, p, q);
  d = norm(double([p1_i, p1_j] - [p2_i, p2_j]));
end

