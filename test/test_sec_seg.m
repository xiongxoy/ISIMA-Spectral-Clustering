%% read image and preprocess it
%I = imread('resource/beach_sky.jpg');
close all; clear;
real_image = true;
%real_image = false;
if real_image
  I = imread('resource/lake_sky.jpg');
  if size(I, 3) == 3
    I = rgb2gray(imresize(I, 20/size(I,2)));
  else
    I = I;
  end
else
  I = sample_generator('3-class-rectangle');
end

k = 3;
IDX = sec_seg(I, k);
close all;
for i = 1:k
  figure(i); clf;
  imagesc(double(IDX == i));
end
  figure
  imagesc(I);
  figure; imshow(I);
  title 'original'
