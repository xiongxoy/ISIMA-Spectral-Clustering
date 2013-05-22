function F = texture_analyser(I, d)
%% classify each piexl by texture
  d = 3;
  s = size(I);
  F = cell(s);
  %threshold whole image
  %level = graythresh(I);
  %I = im2bw(I, level);
  tic;
  for i=1+d:s(1)-d
    for j=1+d:s(2)-d
        F{i,j} = texture_extractor(I(i-d:i+d, j-d:j+d));
    end
  end
  F = fill_border(F, d);
  toc;
end


