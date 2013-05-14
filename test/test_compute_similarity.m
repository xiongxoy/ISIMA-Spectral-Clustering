function test_compute_similarity()
  p = 20;
  q = 20;
  I = zeros(p, q);
  I(1:p/2, 1:q/2) = 0;
  I(1:p/2, q/2+1:q) = 30;
  I(p/2+1:p, q/2+1:q) = 30;
  I(p/2+1:p, 1:q/2) = 90;
  F = num2cell(I);
  A = compute_similarity(F);

  close all;
  figure; clf;
  imagesc(I);
  pause;
  k = 3;
  IDX = image_seg(I, k);
  IDX
  for i = 1:k
    figure; clf;
    imagesc(double(IDX == i));
  end

end
