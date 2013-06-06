function I = spectral_clustering_from_affinity_mat(A, k, sel)
% input processing
    if nargin == 2
       sel = 1;
    end
% main
    switch sel
    case 1
      I = spectral_clustering_Ng(A, k);
    case 2
      I = spectral_clustering_Shi_Malik(A, k);
    case 3
      I = spectral_clustering_Unnormalized(A, k);
    end
end

function I = spectral_clustering_Unnormalized(A, k)
    n = size(A,1);
    %% 2. Get Laplacian
    D = zeros(n);
    for i=1:n
        D(i,i) = sum(A(i,:));
    end
    % L
    L = D - A;
    %% 3. Choose top K eigenvectors and Form Matrix X
    [V, D] = eig(L); % *colum* of V is the eigenvectors of L
                     % V is already sorted in asceding order of eigenvalues
    X = V(:, 1 : k); % Need the k smallest eigenvectors
    plot_matrix_of_eigvectors(X, k)
    %% 5. Clustering Y via K-means
    repeat_nr = 50;
    [I, ~] = kmeans(X, k, 'replicates', repeat_nr);
end

function I = spectral_clustering_Ng(A, k)
    n = size(A, 1);
    %% 2. Get Laplacian
    D = zeros(n);
    for i=1:n
        D(i,i) = sum(A(i,:));
    end
    % L = D.^(-0.5) * A * D.^(-0.5);
    L = zeros(size(A));
    for i=1:size(A,1)
        for j=1:size(A,2)
            L(i,j) = A(i,j) / (sqrt(D(i,i)) * sqrt(D(j,j)));
        end
    end
    %% 3. Choose top K eigenvectors and Form Matrix X
    [V, D] = eig(L); % *colum* of V is the eigenvectors of L
                     % V is already sorted in asceding order of eigenvalues
    X = V(:, end-k+1 : end);
    %% 4. Form Y by renormalizing X
    Y = zeros(size(X));
    for i=1:n
        denominator = norm(X(i,:));
        for j=1:k
            Y(i,j) = X(i,j)/denominator;
        end
    end

    plot_matrix_of_eigvectors(Y, k)
    %% 5. Clustering Y via K-means
    repeat_nr = 50;
    [I, ~] = kmeans(Y, k, 'replicates', repeat_nr);
%   draw_result(I2, S);
%   repeat = input('1 to repeat, 0 stop');
end

function I = spectral_clustering_Shi_Malik(A, k)
    n = size(A,1);
    %% 2. Get Laplacian
    D = zeros(n);
    for i=1:n
        D(i,i) = sum(A(i,:));
    end
    L = D - A;
    %% 3. Choose top K eigenvectors and Form Matrix X
    [V, D] = eig(L, D); % *colum* of V is the eigenvectors of L
                        % V is already sorted in asceding order of eigenvalues
    X = V(:, 1 : k); % Need the k smallest eigenvectors
    plot_matrix_of_eigvectors(X, k)
    %% 5. Clustering Y via K-means
    repeat_nr = 50;
    [I, ~] = kmeans(X, k, 'replicates', repeat_nr);
end

function plot_matrix_of_eigvectors(S, k)
     n = size(S, 1);
    if size(S, 2) == 2
      figure;
      hold on;
      plot(S(1:n/2,1), S(1:n/2,2), 'r.');
      plot(S(n/2+1:n,1), S(n/2+1:n,2), 'b+');
      hold off;
    elseif size(S, 2) == 3
      figure;
      plot3(S(1:n/2,1), S(1:n/2,2), S(1:n/2,3), 'r.');
      plot3(S(n/2+1:n,1), S(n/2+1:n,2), S(n/2+1:n,3),'b+');
    end
end
