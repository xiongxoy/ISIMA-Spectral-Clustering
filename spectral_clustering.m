%%
% S is the input data set, each row is a data point
% k is the cluster number
% sel select algorithms
function [I] = spectral_clustering(S, k, sel, sig)
    if nargin == 4
        I = spectral_clustering_fixed_sigma(S, k, sel, sig);
    elseif nargin == 3
        I = spectral_clustering_fixed_sigma(S, k, sel);
    else
      error();
    end
end

%%% one pass of the algorithm
% TODO refactor this algorithm for more general use
function I = spectral_clustering_fixed_sigma(S, k, sel, sig)
    F = num2cell(S, 2); % every row is a data point
    if nargin == 4
      A = compute_similarity(F, sig);
    else
      A = compute_similarity(F);
    end
    I  =  spectral_clustering_from_affinity_mat(A, k, sel);
end

