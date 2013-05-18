function F_ = fill_border(F, d)
% fill corners
  s = size(F);
  for i=1:d
    for j=1:d
      F{i,j} = F{d+1, d+1};
      F{s(1)-(i-1), j} = F{s(1)-d, d+1};
      F{s(1)-(i-1), s(2)-(j-1)} = F{s(1)-d, s(2)-d};
      F{i, s(2)-(j-1)} = F{d+1, s(2)-d};
    end
  end
% fill edge
  for i=d+1:s(1)-d
    for j=1:d
      F{i, j} = F{i, d+1};
    end
  end
  for i=1:d
    for j=d+1:s(2)-d
      F{i, j} = F{d+1, j};
    end
  end
  for i=s(1)-d+1:s(1)
    for j=d+1:s(2)-d
      F{i, j} = F{s(1)-d, j};
    end
  end
  for i = d+1:s(1)-d
    for j = s(2)-d+1:s(2)
      F{i, j} = F{i, s(2)-d};
    end
  end
  F_ = F;
end
