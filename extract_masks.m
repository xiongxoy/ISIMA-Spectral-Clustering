%% extract masks from indexes
function masks = extract_masks(IDX)
  for i = 1:k
    masks{i} = find(IDX == i);
  end
end
