%% Introduction
% Author: Zhou Xiong
%   Data: 9/4/2013
function test_spectral_clustering()
  close all; clear;
  %% generator test S
  S = sample_generator('2-cocentric-circles');
  k = 2;
  one_pass(S, k, 1, 0.05);
  one_pass(S, k, 2, 0.05);
  one_pass(S, k, 3, 0.05);
end

function one_pass(S, k, sel, sig)
  if nargin == 3
    IDX = spectral_clustering(S, k, sel);
  else
    IDX = spectral_clustering(S, k, sel, sig);
  end
  disp('What')
  figure;
  title 'Final Result'
  hold on;
  for i=1:size(IDX, 1)
      if IDX(i) == 1
          plot(S(i,1),S(i,2),'m.');
      elseif IDX(i) == 2
          plot(S(i,1),S(i,2),'g+');
      elseif IDX(i) == 3
          plot(S(i,1),S(i,2),'b*');
      elseif IDX(i) == 4
        error();
      end
  end
  hold off;
  pause;
end
