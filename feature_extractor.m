function F = feature_extractor(I)
% This function extracts features specified by @a type from input image
% @param I inpute image
% @return F a cell matrix specifying feature vetors for each pixel
  F = cell(size(I));
  F = append_F(F, I);
  %F = append_F(F, get_pos_X(I));
  %F = append_F(F, get_pos_Y(I));
  %F = append_F(F, get_Variance(I));
  %F = append_F(F, get_Mean(I));
  if isempty(F)
    warning('No Feature is Extracted');
  end
end

function F_ = append_F(F, S)
p = size(F,1);
q = size(F,2);
for i = 1:p
  for j = 1:q
    F{i,j}(end+1) = S(i,j);
  end
end
F_ = F;
end

function S = get_pos_X(I)
  [p q] = size(I);
  S = ones(size(I));
  for i = 1:p
    S(i, :) = i;
  end
end

function S = get_pos_Y(I)
  [p q] = size(I);
  S = ones(size(I));
  for i = 1:q
    S(:, i) = i;
  end
end

function S = get_Partial_Y(I)
  [p q] = size(I);
  S = zeros(size(I));
  for i = 1:p-1
    S(i, :) = I(i+1, :) - I(i, :);
  end
end

function S = get_Partial_X(I)
  [p q] = size(I);
  S = zeros(size(I));
  for i = 1:q-1
    S(:, i) = I(:, i+1) - I(:, i);
  end
end

function S = get_Mean(I)
  [p q] = size(I);
  S = zeros(size(I));
  for i = 1:p
    for j = 1:q
      try
        patch = I(i-1:i+1, j-1:j+1);
        S(i,j) = mean(patch(:));
      catch Error_Msg
        S(i,j) = I(i, j); % TODO Find a better way?
      end
    end
  end
end

function S = get_Variance(I)
  [p q] = size(I);
  S = zeros(size(I));
  for i = 1:p
    for j = 1:q
      try
        patch = I(i-1:i+1, j-1:j+1);
        S(i, j) = var(patch(:));
      catch Error_Msg
        S(i, j) = 0; % TODO Find a better way?
      end
    end
  end
end


