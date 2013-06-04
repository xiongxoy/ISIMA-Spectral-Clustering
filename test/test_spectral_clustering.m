%% Introduction
% Author: Zhou Xiong
%   Data: 9/4/2013
function test_spectral_clustering()

%% generator test S
S = sample_generator('2-cocentric-circles');
k = 2;
%% clustering and plot
   %IDX = spectral_clustering(S, k, 0.05);
   IDX = spectral_clustering(S, k, 0.05);
figure;
title 'Final Result'
hold on;
%  IDX = reshape(IDX, size(S));
for i=1:size(IDX, 1)
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

