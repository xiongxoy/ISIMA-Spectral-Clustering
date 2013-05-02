%% read image and preprocess it
I = imread('resource/beach_sky.jpg');
if size(size(I)) ~= 2
  I = rgb2gray(imresize(I, 0.17));
end
% I = double(I); do we need this?
I = flipud(I');
k = 3;
%% segmenting image
IDX = image_seg(I, k, 'Intensity');
%% create masks
masks = cell(1, k);
masks = extract_masks(IDX);
%% show segments
close all;
for i = 1:k
  figure(k); clk;
  imshow(I(masks{i}));
end

