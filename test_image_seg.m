%% read image and preprocess it
%I = imread('resource/beach_sky.jpg');
close all; clear;
real_image = false;
if real_image
  I = imread('resource/lake_sky.jpg');
  if size(I, 3) == 3
    I = rgb2gray(imresize(I, 40/size(I,2)));
  else
    I = I;
  end
else
  I = sample_generator('3-class-rectangle');
end

%I = flipud(I');
%imshow(I);

k = 3;
types = 'Intensity';
IDX = image_seg(I, k, types);
close all;
for i = 1:k
  figure(i); clf;
  imagesc(double(IDX == i));
end
  figure
  imagesc(I);
  figure; imshow(I);
  title 'original'
