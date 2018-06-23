function [R,t] = alignment(X1,X2,xL1,xL2,i,k)
% X1 = 3D points of image 1
% X2 = 3D points of image 2
% xL1 = points in left camera 1
% xL2 = points in left camera 2
% i = first image index
% k = second image index

% R = optimal rotation to align clicked points
% t = optimal translation to align clicked points
% load reconstruction.mat

imagedir1 = ['teapot/grab_' int2str(i-1)];
imagedir2 = ['teapot/grab_' int2str(k-1)];

% get 4 user clicks
for j=1:4
    [ind1(j),ind2(j)] = select2d(xL1,xL2,imagedir1,imagedir2)
end

% find the points corresponding to those clicks in the 3D points
X1 = X1(:,ind1);
X2 = X2(:,ind2);

% use SVD to find optimal R and t
X1c	= X1 - repmat(mean(X1,2),1,size(X1,2));
X2c	= X2 - repmat(mean(X2,2),1,size(X2,2));
H = X2c*X1c.';
[U,S,V]	= svd(H);
R = V*U.';
t =	mean(X1,2) - R*mean(X2,2);
% X2aligned = R*X2 + repmat(t,1,size(X2,2));

