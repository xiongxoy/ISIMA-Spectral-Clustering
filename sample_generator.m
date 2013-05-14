% Author: Zhou Xiong
%   Date: 9/4/2013
function S = sample_generator(sample_name)
    if strcmp('3-cocentric-circles',sample_name) == 1
      S = three_cocentric_circles();
    elseif strcmp('2-cocentric-circles',sample_name) == 1
      S = two_cocentric_circles();
    elseif strcmp('3-class-rectangle', sample_name) == 1
      S = three_class_rectangle();
    elseif strcmp('4-complex-rectangle', sample_name) == 1
      S = four_complex_rectangle();
    else
      error('No such sample!');
    end
end

function S = three_class_rectangle()
    p = 20;
    q = 20;
    S = zeros(p, q);
    S(1:p/2, 1:q/2) = 0;
    S(1:p/2, q/2+1:q) = 30;
    S(p/2+1:p, q/2+1:q) = 30;
    S(p/2+1:p, 1:q/2) = 90;
end
%% two circles
function S = two_cocentric_circles()
    center = [2.5 2.5];
    S = [];
    S = append_circle(S, 1, center);
    S = append_circle(S, 1.5, center);
    close All;
%    plot(S(:,1), S(:,2), '.');
end

%% three circles
function S = three_cocentric_circles()
    center = [2.5 2.5];
    S = [];
    S = append_circle(S, 0.5, center);
    S = append_circle(S, 1, center);
    S = append_circle(S, 1.5, center);
    close All;
%    plot(S(:,1), S(:,2), '.');
end

function R = append_circle(S, radius, center)
    for theta=1:360
        radian_noise = (theta + 5.*randn)/180 * pi;
        rho_noise = radius + 0.05 * radius * randn;
        x = center(1) + rho_noise .* cos(radian_noise);
        y = center(2) + rho_noise .* sin(radian_noise);
        S(end+1,:) = [x y];
    end
    R = S;
end
