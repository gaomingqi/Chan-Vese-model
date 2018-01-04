% Active Contour using Chan-Vese fitting energy without narrow band
% Author: Mingqi Gao, College of Computer Science, Chongqing University
% Contact: im.mingqi@gmail.com
% Main Reference in this project:
% [1] "Active Contours Without Edges", 
%     Tony F. Chan and Luminita A. Vese. IEEE Trans on Image Processing, 2001.
% [2] "Level Set Evolution Without Re-initialization: A New Variational Formulation"
%     Chunming Li, Chenyang Xu, Changfeng Gui, and Martin D. Fox. IEEE CVPR, 2005
close all;
Img = imread('images/euro-night-lights.jpg');

if size(Img, 3) > 1
    u0 = rgb2gray(Img);    % »Ò¶È»¯
else
    u0 = Img;
end
u0 = double(u0);    % u0 means the given image (grey level)

%% set parameters
maxIter = 120;  % maximum iteration number;
lambda = 1;      % coefficient of cv term;
nu = .5;        % coefficient of smooth term, increase it can obtain more smooth segmentation result;
mu = 1;         % coefficient of penalty term with respect to level set function \phi,
                % used to make \phi close enough to the signal distance function (SDF);
epsilon = 1;    % parameter of regularized Heaviside function and its derivative;
timeStep = .1;  % time step.

% initialize level set function or load a existing initial contour
%--- if you want initialize the active contour by Manual setting, please
%remove the following comments:
% m = roipoly;  % select a polygonal region by hand;
% phi = bwdist(m) - bwdist(1-m) + im2double(m) - .5;  % compute SDF according to m;
%--- Load existing initial contour
load('initial contours/init_contour1.mat');  % circle contour
% load('initial contours/init_contour2.mat');    % 9 even-distributed retangle contours

% show the given image with initial contour;
subplot(1, 2, 1), imshow(u0, [0 255]), title('Given image u0');
phi = double(phi);
phi = imresize(phi, size(u0));
hold on;
contour(phi, [.5 .5], 'r', 'linewidth', 2);
hold off;

%% evolution process
tic     % record the starting time of evolution process;
for i = 1:maxIter
    % display current evolving contour every 5 iterations;
    if mod(i, 5) == 0 || i == 1
        pause(.1);
        subplot(1, 2, 2), 
        imshow(u0, [0, 255]), hold on;
        contour(phi, [0 0], 'r', 'linewidth', 2);
        % show the number of iteration;
        iterNum=[num2str(i), ' iterations'];
        title(iterNum);
        hold off;

%--- if you want to save the segmentation process as a GIF file, please
%    remove the following comments:
%         frame = getframe(gcf);
%         im = frame2im(frame);   % extract image from current figure;
%         [I, map] = rgb2ind(im,256);
%         
%         if i==1;
%              imwrite(I, map, 'results/evo_process.gif', 'gif', 'Loopcount', inf,...
%                  'DelayTime', 0.3);  % initialize GIF file;
%         else
%             imwrite(I, map, 'results/evo_process.gif', 'gif', 'WriteMode', 'append',...
%                 'DelayTime', 0.2);  % add new frame every each 5 iterations;
%         end
%--- 
    end 
    phi = Evolution(phi, u0, nu, mu, timeStep, lambda, epsilon); % compute updated \phi;
end

toc     % display evolution time;

%% save the mask of segmentation result;
Iseg = zeros(size(phi));
Iseg(phi > 0) = 1;
imwrite(Iseg, 'results/seg_result.jpg');

disp('end of Chan-Vese seg program');