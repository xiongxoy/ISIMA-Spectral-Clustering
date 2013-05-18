function F = texture_extractor(I)
% @param I gray-level image, should be uint8
% @return F feature vector of I
  level = graythresh(I);
  bw = im2bw(I, level);
% bw = bwareaopen(bw, 50);
  glcm = graycomatrix(bw);
  glcm = glcm + glcm';
  glcm = glcm ./ sum(glcm(:));

  % Get row and colum subscripts of GLCM.
  s = size(glcm);
  [c, r] = meshgrid(1:s(1), 1:s(2));
   c = c(:); r = r(:);
  % calculate features
  F = [];
  F(end+1) = calculateHomogeneity(glcm, r, c);
  F(end+1) = calculateEnergy(glcm);
  %F(end+1) = calculateEntropy(glcm);
end

function E = calculateEntropy(glcm)
end

function E = calculateEnergy(glcm)
  bar = glcm.^2;
  E = sum(bar(:));
end

function H = calculateHomogeneity(glcm, r, c)
  term1 = (1 + abs(r-c));
  term = glcm(:) ./ term1;
  H = sum(term);
end
%% thresholding
%% extract graycomatrix
%% 四块大区，各自得到一个数值
%% 然后在分别四分，
%%   如果是一致的区域，就不要分了
%%   如果是变动大的区域，就要继续分
%  有必要合么？
