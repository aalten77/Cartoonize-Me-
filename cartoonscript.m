close all

sigma_d = 3;
sigma_r = 0.1; %4.25;
N_e = 3;
N_b = 4;

name = 'Santorini_sunset';
RGB = imread(sprintf('%s.jpg', name));
RGB = imresize(RGB, 0.5);
C = makecform('srgb2lab');
Lab = applycform(RGB, C);
w = 5;
curley_q = 3.1;


% I = rgb2gray(imread('selfie.jpg'));
% I = im2double(I);
% %grayscale
% G = I;
Lab = im2double(Lab);

% Lab2 = uint8(Lab*255);
% C = makecform('lab2srgb');
% RGB = applycform(Lab2, C);
% RGB = im2double(RGB);
% Edges = cannyEdgeDetector(RGB);

G = rgb2gray(RGB);
G = im2double(G);
% for i=1:N_e
%     G = bilateral2(G, w, sigma_d, sigma_r);
% end

Lum = Lab(:,:,1);
for i = 1:N_e
    Lum = bilateral2(Lum, w, sigma_d, sigma_r);
end
% gaus_kern = fspecial('gaussian', 9, 1);
% Lum_gaus = imfilter(Lum, gaus_kern);
% gaus_kern_sm = fspecial('gaussian', 9, .25);
% Lum_gaus_2 = imfilter(Lum, gaus_kern_sm);
% Lum = Lum_gaus_2;
% Lum = Lum - Lum_gaus;

thresh = graythresh(Lum);

Edges = edge(Lum, 'canny');%, [thresh*0.25 thresh*0.5]);

% Lum_max = max(max(Lum));
% Lum_min = min(min(Lum));

%Lum = ((Lum-Lum_min).*(1.0/(Lum_max-Lum_min)));

% Edges = im2bw(Lum, thres*0.5);
Edges = ordfilt2(Edges, 5, [0 1 0; 1 1 1; 0 1 0]);

figure; imshow(Edges);
% Edges = im2double(cannyEdgeDetector2(G, 15, 1, 3));

% Edges = ordfilt2(Edges, 4, [0 1 0; 1 0 1; 0 1 0]);
% gaus_kern = fspecial('gaussian', 3, 1);
% Edges = imfilter(Edges, gaus_kern);

NonEdges = 1.0 - Edges;
figure; imshow(NonEdges);

for j = 1:3
    for i=1:N_e
        Lab(:,:,j) = bilateral2(Lab(:,:,j), w, sigma_d, sigma_r);
    end
end

%show bilateral
Lab2 = uint8(Lab*255);
C2 = makecform('lab2srgb');
RGB2 = applycform(Lab2, C2);
RGB2 = im2double(RGB2);
figure, imshow(RGB2)
h2 = gcf;
saveas(h2, sprintf('%s_bilateral_%d.jpg', name, N_e));

%optional quantization step
Lab = im2uint8(Lab);
Lab = quantize(Lab);
Lab = uint8(Lab*255);
C = makecform('lab2srgb');
RGB = applycform(Lab, C);
RGB = im2double(RGB);

 
%  Edges = cannyEdgeDetector(RGB);
 
 for i=1:3
    RGB(:,:,i) = NonEdges.*RGB(:,:,i);
 end
 
%  RGB = imresize(RGB, 1/0.2);
 figure, imshow(RGB)
 h = gcf;
saveas(h, sprintf('%s_cartoon_%d.jpg', name, N_e));
 