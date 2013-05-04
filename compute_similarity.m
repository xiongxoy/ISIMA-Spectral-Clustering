function [D d_max] = compute_similarity(F)
  p = size(F, 1);
  q = size(F, 2);
  f_nr = size(F, 3);

  D = zeros(p*q, p*q, f_nr);
  d_max = zeros(1, f_nr);

  n = p*q;
  for k = 1:f_nr
    Fk = F(:,:,k);
    for i = 1:n
      for j = 1:n
        %i
        %j
        fi = Fk{i};
        fj = Fk{j};
        D(i, j, k) = norm(double(fi - fj));
        if D(i, j, k) > d_max(k)
          d_max(k) = D(i, j, k);
        end
      end
    end
  end
end

