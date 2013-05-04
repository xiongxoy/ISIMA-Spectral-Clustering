function F = feature_extractor(I, type)
% This function extracts features specified by @a type from @a I
% @param I inpute image
% @param type feature types in the format  'Feature1_Feature2..._FeatureN'
% @return F a cell matrix specifying feature vetors for each pixel
  if nargin == 1
    error('Error: Please Specify Feature Type.')
  end
  disp('A')
  F = {};
  if strcmp(type, 'Intensity')
    disp('B')
    F = num2cell(I);
    disp('C')
  end
  disp('D')
  if strcmp(type, 'Partial_X')
    error('Error: Partial_X is not implemented yet.')
  end
  if strcmp(type, 'Partial_Y')
    error('Error: Partial_Y is not implemented yet.')
  end
  if strcmp(type, 'Variance')
    get_Variance(I, F);
  end
  if strcmp(type, 'Mean')
    get_Mean(I, F);
  end
  % if  strcmp(type, 'XY')
  % XY information is naturally encoded in the feature matrix F
  % end
  if isempty(F)
    warning('No Feature is Extracted');
  end
  disp('E')
end

function get_Partial_X(I, F)
  [p q] = size(I);
  for i = 1:p
    for j = 1:q
      % TODO Not implemented yet.
    end
  end
end

function get_Mean(I, F)
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

function get_Variance(I, F)
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

function A = get_Intensity(I)
  [p q] = size(I);
  A = cell(p, q);
  for i = 1:p
    for j = 1:q
      A{i,j} =  [I(i,j)];
    end
  end
end

function idx = cell_find(C, s)
for i = 1:min(size(C))
  if strcmp(C{i}, s) == true
    idx = i;
    return
  end
end
idx = 0;
return
end
