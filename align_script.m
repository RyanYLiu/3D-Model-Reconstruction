load('mesh.mat')

order = [1 7 2 5 4 3 6];
for i=1:6
    % get optimal rotation and translation
    [Rot(:,:,i),t(:,:,i)] = alignment(Y{1,order(i)},Y{1,order(i+1)},xL{1,...
        order(i)},xL{1,order(i+1)},order(i),order(i+1));
    
    for j=i:-1:1
        disp('rotating')
        Y{1,order(i+1)} = Rot(:,:,j)*Y{1,order(i+1)} + repmat(t(:,:,j),1,size(Y{1,order(i+1)},2));
    end
    
    % perform icp
    disp('icp')
    [TR, TT] = icp(Y{1,i},Y{1,i+1},15, 'Matching', 'kDtree');
    Y{1,i+1} = TR*Y{1,i+1} + repmat(TT,1,size(Y{1,i+1},2));
end



figure(25); clf;
h1 = trisurf(tri{1,1},Y{1,1}(1,:),Y{1,1}(2,:),Y{1,1}(3,:));
set(h1,'edgecolor','none')
hold on;
h2 = trisurf(tri{1,2},Y{1,2}(1,:),Y{1,2}(2,:),Y{1,2}(3,:));
set(h2,'edgecolor','none')
hold on;
h3 = trisurf(tri{1,3},Y{1,3}(1,:),Y{1,3}(2,:),Y{1,3}(3,:));
set(h3,'edgecolor','none')
hold on;
h4 = trisurf(tri{1,4},Y{1,4}(1,:),Y{1,4}(2,:),Y{1,4}(3,:));
set(h4,'edgecolor','none')
hold on;
h5 = trisurf(tri{1,5},Y{1,5}(1,:),Y{1,5}(2,:),Y{1,5}(3,:));
set(h5,'edgecolor','none')
hold on;
h6 = trisurf(tri{1,6},Y{1,6}(1,:),Y{1,6}(2,:),Y{1,6}(3,:));
set(h6,'edgecolor','none')
hold on;
h7 = trisurf(tri{1,7},Y{1,7}(1,:),Y{1,7}(2,:),Y{1,7}(3,:));
set(h7,'edgecolor','none')
set(gca,'projection','perspective')
axis image; axis vis3d;
camorbit(45,0);
camorbit(0,-120);
camroll(-8);

lighting flat;
shading interp;
material dull;
camlight headlight;
