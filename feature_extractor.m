function F = feature_extractor(I, type)
% This function extracts features specified by @a type from @a I
% @param I inpute image
% @param type feature types in the format  'Feature1_Feature2..._FeatureN'
% @return F a cell matrix specifying feature vetors for each pixel

  if nargin == 1
    error('Error: Please Specify Feature Type.')
  end

  disp('A')
  F = cell(size(I));
  if ~isempty(strfind(type, 'Intensity'))
    disp('B')
    add_Intensity(I, F);
    disp('C')
  end
  disp('D')
  if ~isempty(strfind(type, 'Partial_X'))
    error('Error: Partial_X is not implemented yet.')
  end
  if ~isempty(strfind(type, 'Partial_Y'))
    error('Error: Partial_Y is not implemented yet.')
  end
  if ~isempty(strfind(type, 'Variance'))
    add_Variance(I, F);
  end
  if ~isempty(strfind(type, 'Mean'))
    add_Mean(I, F);
  end
  % if ~isempty(strfind(type, 'XY'))
  % XY information is naturally encoded in the feature matrix F
  % end
  if isempty(F)
    warning('No Feature is Extracted');
  end
end

function add_Partial_X(I, F)
  [p q] = size(I);
  for i = 1:p
    for j = 1:q
      % TODO Not implemented yet.
    end
  end
end

function add_Mean(I, F)
  [p q] = size(I);
  for i = 1:p
    for j = 1:q
      try
        patch = I(i-1:i+1, j-1:j+1);
        F{i,j}(end+1) = mean(patch(:));
      catch Error_Msg
        F{i,j}(end+1) = nan; %  XXX Find a better way?
      end
    end
  end
end

function add_Variance(I, F)
  [p q] = size(I);
  for i = 1:p
    for j = 1:q
      try
        patch = I(i-1:i+1, j-1:j+1);
        F{i,j}(end+1) = var(patch(:));
      catch Error_Msg
        F{i,j}(end+1) = nan; %  XXX Find a better way?
      end
    end
  end
end

function add_Intensity(I, F)
  [p q] = size(I);
  for i = 1:p
    for j = 1:q
      F{i,j}(end + 1) =  I(i,j);
    end
  end
end
