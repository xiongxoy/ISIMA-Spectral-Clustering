%%
% I(i) is the cluster the corresponding row i lies in
% S is the input data set, each row is a data point
% k is the cluster number
function [I] = spectral_clustering(S, k, sig)
    if nargin == 3
        [~,I] = spectral_clustering_fixed_sigma(S, k, sig);
        return
    elseif nargin == 2
        % TODO use the 1/6 of distance range as sigma
        [I, ~] = spectral_clustering_fixed_sigma(S, k, sig);
        return
    end
end

function [I] = golded_search(S, k)
    sigma_a = 0.000001;
    sigma_b = 0.15;
    error = 1e-4;
    %% get sigma to minimize the distortion by golded search
    x1 = sigma_a + 0.382 * (sigma_b - sigma_a);
    x2 = sigma_a + 0.618 * (sigma_b - sigma_a);
    disp('begin');
    v1 = spectral_clustering_fixed_sigma(S, k, x1);
    v2 = spectral_clustering_fixed_sigma(S, k, x2);
    while sigma_b - sigma_a > error
        close ALL;
        disp('progress');
        disp([sigma_b  sigma_a]);
        if v1 < v2
            sigma_b = x2;
            x2 = x1;
            v2 = v1;
            x1 = sigma_a + 0.382 * (sigma_b - sigma_a);
            v1 = spectral_clustering_fixed_sigma(S,k,x1);
        else
            sigma_a = x1;
            x1 = x2;
            v1 = v2;
            x2 = sigma_a + 0.618 * (sigma_b - sigma_a);
            v2 = spectral_clustering_fixed_sigma(S,k,x2);
        end
    end
    sig = 0.5 * (sigma_a + sigma_b);
    disp('sig');
    disp(sig);
    [I,d ] = spectral_clustering_fixed_sigma(S, k, sig);
end

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
%% one pass of the algorithm
% TODO refactor this algorithm for more general use
function [I, d] = spectral_clustering_fixed_sigma(S, k, sig)
    n = size(S, 1); % data set size
    l = size(S, 2); % data dimension
    A = zeros(n);
    %% 1. Form affinity matrix A
    for i=1:n
        for j=1:n
            if i==j
                A(i,j) = 0;
            else
                A(i,j) = compute_Aij(S, i, j, sig);
            end
        end
    end
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

    %% for debug
    figure
    title 'Plot of Y'
    hold on
    plot(Y(1:360,1), Y(1:360,2), 'b+');
    plot(Y(361:720,1), Y(361:720,2), 'r*');
    hold off

    %% 5. Clustering Y via K-means
    repeat = 1;
    while repeat == 1;
        [I2 C] = kmeans(Y, k, 'replicates', 100);
        draw_result(I2, S);
%         repeat = input('1 to repeat, 0 stop');
        break;
    end

    %% for debug
    Y_1 = Y(I2==1, :);
    Y_2 = Y(I2==2, :);
    figure;
    hold on;
    plot(Y_1(:,1), Y_1(:,2), 'b+');
    plot(Y_2(:,1), Y_2(:,2), 'r*');
    hold off;

    %% 6. Get I from previous result
    I = I2;
    %% compute distortion
    d = distortion(Y, I, C);
end

function draw_result(IDX, S)
figure;
title 'Plot of Result'
hold on;
for i=1:size(IDX,1)
    if IDX(i) == 1
        plot(S(i,1),S(i,2),'m.');
    elseif IDX(i) == 2
        plot(S(i,1),S(i,2),'g+');
    elseif IDX(i) == 3
        plot(S(i,1),S(i,2),'b*');
    elseif IDX(i) == 4
        disp('ERROR: No Such Kind');
    end
end
hold off;
end
%% compute distortion of a clustering
function d = distortion(S, I, C)
    d = 0;
    for i=1:size(I)
        c = C(I(i));
        d = d + norm(S(i, :)-c)^2;
    end
end
%% compute A(i,j) from S
function a = compute_Aij(S, i, j, sig)
    si = S(i, :);
    sj = S(j, :);
    t2 = -norm(si-sj).^2 / (2 * sig^2);
    a = exp(t2);
end
