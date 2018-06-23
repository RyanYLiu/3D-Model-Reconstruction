%
% load results of reconstruction
%
load reconstruction


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% cleaning step 1: remove points outside known bounding box
%

% xmin = -200;
% xmax = 400;
% ymin = -200;
% ymax = 300;
% zmin = -200;
% zmax = 200;
% 
% goodpoints = find( (X(1,:)>xmin) & (X(1,:)<xmax) & (X(2,:)>ymin) & (X(2,:)<ymax) & (X(3,:)>zmin) & (X(3,:)<zmax) );
% fprintf('dropping %2.2f %% of points from scan\n',100*(1 - (length(goodpoints)/size(X,2))));


%
% drop points from both 2D and 3D list
%
% X = X(:,goodpoints);
% xR = xR(:,goodpoints);
% xL = xL(:,goodpoints);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% cleaning step 2: remove triangles which have long edges
%

trithresh = 10;   %10mm

fprintf('triangulating from left view\n');
tri = delaunay(xL(1,:),xL(2,:));
ntri = size(tri,1);
npts = size(xL,2);
terr = zeros(ntri,1);
for i = 1:ntri
  fprintf('\rtraversing triangles %d/%d',i,ntri);
  d1 = sum((X(:,tri(i,1)) - X(:,tri(i,2))).^2);
  d2 = sum((X(:,tri(i,1)) - X(:,tri(i,3))).^2);
  d3 = sum((X(:,tri(i,2)) - X(:,tri(i,3))).^2);
  terr(i) = max([d1 d2 d3]).^0.5;
end
fprintf('\n');
subt = find(terr<trithresh);

fprintf('dropping %2.2f %% of triangles from scan\n',100*(1 - (length(subt)/size(tri,1))));

tri = tri(subt,:);


%
% remove unreferenced points which don't appear in any triangle
%
allpoints = (1:size(X,2))';
refpoints = unique(tri(:)); %list of unique points mentioned in tri

% build a table describing how we reindex points
newid = -1*ones(size(allpoints));
newid(refpoints) = 1:length(refpoints);

%now newid(k) contains the new index for current point k
% apply this mapping to all the indicies in tri

tri = newid(tri);

% and drop un-referenced points
X = X(:,refpoints);
xR = xR(:,refpoints);
xL = xL(:,refpoints);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% display results
%
figure(1); clf;
xColor = 0.7*ones(size(X,2),3);
%set(gcf,'renderer','opengl')
%h = trimesh(tri,X(1,:),X(2,:),X(3,:),'edgecolor','k','facecolor','w');
h = trimesh(tri,X(1,:),X(2,:),X(3,:),'facevertexcdata',xColor,'edgecolor','interp','facecolor','interp');
axis image; axis vis3d;
set(gca,'projection','perspective')
set(gca,'CameraPosition',10*camL.t);
set(gca,'CameraUpVector',[0 -1 0]);
set(gca,'CameraViewAngle',8);
lighting phong;
shading interp;
camlight headlight;  


figure(1); clf;
h = trisurf(tri,X(1,:),X(2,:),X(3,:));
set(h,'edgecolor','none')
set(gca,'projection','perspective')
axis image; axis vis3d;
camorbit(45,0);
camorbit(0,-120);
camroll(-8);

lighting flat;
shading interp;
material dull;
camlight headlight;


