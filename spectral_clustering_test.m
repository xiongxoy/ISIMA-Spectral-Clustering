%% Introduction
% Author: Zhou Xiong
%   Data: 9/4/2013

%% generator test S
S = sample_generator('2-cocentric-circles');
%% clustering and plot
%   IDX = spectral_clustering(S, 2, 0.0303);
    IDX = spectral_clustering(S, 2);
%   IDX = spectral_clustering(S, 2);
figure;
title 'Final Result'
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