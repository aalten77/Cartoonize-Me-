function Edges = cannyEdgeDetector2( I, ksize, sigma, iter )

gaus_kern = fspecial('gaussian', ksize, sigma);

for j = 1:iter
    I = imfilter(I, gaus_kern);
end

Edges = edge(I, 'canny');

return

% I = rgb2gray(RGB);
% I = im2double(I);
%grayscale
%  level = graythresh(I);
% Edges = edge(I, 'canny');
%  Edges = edge(I, 'log'); %, [level*0.5 level]
%  figure, imshow(Edges)
% H = [-1, -1, -1; -1, 8, -1; -1, -1, -1];
% % H = fspecial('laplacian');
% Lap = imfilter(I, H, 'conv');
% Lap = im2double(Lap);
% figure, imshow(Lap)
% level = graythresh(Lap);
% Edges = 1-Lap;
% % Edges = im2bw(Lap, 0.5);
%  figure, imshow(Edges)
%  Edges = ~(Edges);

%Sobel mask |G| = |Gx| + |Gy|
% find magnitude of correlation
Gx = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
Gy = [ -1, -2, -1; 0, 0, 0; 1, 2, 1];

%MAGNITUDE
Gradx = imfilter(I, Gx, 'conv');
Grady = imfilter(I, Gy, 'conv');
Edges = double(sqrt(Gradx.^2 + Grady.^2)); %euclidean distance


%NORMALIZATION
minimum = min(min(Edges));
maximum = max(max(Edges));

Edges = ((Edges-minimum).*(1.0/(maximum-minimum)));
Edges = 1.0 - im2bw(Edges, 0.15);
figure, imshow(Edges)

end

