I = four_complex_rectangle();
k = 4;
IDX = texture_analyser(I, k);

for i =1:k
  figure(i);clf;
  imagesc(double(IDX == i));
end
