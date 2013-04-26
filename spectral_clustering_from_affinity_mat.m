function I = spectral_clustering_from_affinity_mat(A, k)
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

    %% 5. Clustering Y via K-means
    repeat_nr = 50;
    [I C] = kmeans(Y, k, 'replicates', repeat_nr);
%   draw_result(I2, S);
%   repeat = input('1 to repeat, 0 stop');
end

