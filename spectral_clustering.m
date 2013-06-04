%%
% I(i) is the cluster the corresponding row i lies in
% S is the input data set, each row is a data point
% k is the cluster number
function [I] = spectral_clustering(S, k, sig)
    if nargin == 3
        I = spectral_clustering_fixed_sigma(S, k, sig);
    elseif nargin == 2
        I = spectral_clustering_fixed_sigma(S, k);
    end
end

%%% one pass of the algorithm
% TODO refactor this algorithm for more general use
function I = spectral_clustering_fixed_sigma(S, k, sig)
    F = num2cell(S, 2); % every row is a data point
    if nargin == 3
      A = compute_similarity(F, sig);
    else
      A = compute_similarity(F);
    end
    I  =  spectral_clustering_from_affinity_mat(A, k);
end

