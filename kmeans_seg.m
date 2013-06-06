function [IDX] = kmeans_seg(I, k)
F = feature_extractor(I);
d = size(F{1});
S = cell2mat(F(:)); % each row of mat S is a data point
IDX = kmeans(S, 3, 'replicate', 20);
IDX = reshape(IDX, size(I, 1), size(I, 2));
end

