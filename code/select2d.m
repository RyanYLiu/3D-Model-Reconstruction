function [ind1,ind2] = select2d(xL1,xL2,imagedir1,imagedir2)
% xL1 = points in left camera of image 1
% xL2 =  points in left camera of image 2
% imagedir1 = directory of image 1
% imagedir2 = directory of image 2

% ind1 = index of closest point in left camera of image 1 to clicked point
% ind2 = index of closest point in left camera of image 2 to clicked point

l1_rgb = im2double(imread([imagedir1 '/color_C1_01.png']));
l2_rgb = im2double(imread([imagedir2 '/color_C1_01.png']));

% get users clicks
figure(20); clf;
imagesc(l1_rgb);
click1 = ginput(1).';

figure(21); clf;
imagesc(l2_rgb);
click2 = ginput(1).';

% find the points in left camera that is closest euclidean dist to click
[dist_L1, indL1] = min(sum((xL1-click1).^2));

[dist_L2, indL2] = min(sum((xL2-click2).^2));

ind1 = indL1;

ind2 = indL2;