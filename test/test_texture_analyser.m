I = four_complex_rectangle();
k = 4;
IDX = image_seg(I, 4);
%IDX = texture_seg(I, k);

for i =1:k
  figure(i);clf;
  imagesc(double(IDX == i));
end
