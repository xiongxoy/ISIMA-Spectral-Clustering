%% read image and preprocess it
I = imread('resource/beach_sky.jpg');
if size(I, 3) == 3
  I = rgb2gray(imresize(I, 50/size(I,1)));
end
% I = double(I); %do we need this?
I = flipud(I');
imshow(I);
pause
k = 3;
%% segmenting image
types = {};
types{end+1} = 'Intensity';
IDX = image_seg(I, k, types);
%% show segments
close all;
for i = 1:k
  figure(i); clf;
 %I(IDX == k) = 0;
  imshow(double(I) .* double(IDX == i));
end

