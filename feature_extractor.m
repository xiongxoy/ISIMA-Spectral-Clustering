function F = feature_extractor(I, type)
% This function extracts features specified by @a type from @a I
% @param I inpute image
% @param type feature types in the format  'Feature1_Feature2..._FeatureN'
% @return F a cell matrix specifying feature vetors for each pixel
  if nargin == 1
    error('Error: Please Specify Feature Type.')
  end
  F = cell(size(I));
  if strcmp(type, 'Intensity')
    append_F(F, I);
  end
  if strcmp(type, 'Partial_X')
    error('Error: Partial_X is not implemented yet.')
  end
  if strcmp(type, 'Partial_Y')
    error('Error: Partial_Y is not implemented yet.')
  end
  if strcmp(type, 'Variance')
    append_F(F, get_Variance(I));
  end
  if strcmp(type, 'Mean')
    append_F(F, get_Mean(I));
  end
  % if  strcmp(type, 'XY')
  % XY information is naturally encoded in the feature matrix F
  % end
  if isempty(F)
    warning('No Feature is Extracted');
  end
end

function append_F(F, S)
p = size(F,1);
q = size(F,2);
for i = 1:p
  for j = 1:q
    F{i,j}(end+1) = S(i,j);
  end
end
end

function get_Partial_X(I, F)
  [p q] = size(I);
  for i = 1:p
    for j = 1:q
      % TODO Not implemented yet.
    end
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

function get_Variance(I, F)
  [p q] = size(I);
  S = zeros(size(I));
  for i = 1:p
    for j = 1:q
      try
        patch = I(i-1:i+1, j-1:j+1);
        S(i, j) = var(patch(:));
      catch Error_Msg
        S(i, j) = nan; % TODO Find a better way?
      end
    end
  end
end


