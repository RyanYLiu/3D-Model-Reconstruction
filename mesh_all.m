%
% load results of reconstruction
%
load reconstruction


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% cleaning step 1: remove points outside known bounding box
%

% bounding box values
xmin = 220;
xmax = 415;
ymin = -10;
ymax = 200;
zmin = -600;
zmax = -400;
for i=1:7

    goodpoints = find( (X{1,i}(1,:)>xmin) & (X{1,i}(1,:)<xmax) & (X{1,i}(2,:)>ymin) & (X{1,i}(2,:)<ymax) & (X{1,i}(3,:)>zmin) & (X{1,i}(3,:)<zmax) );
    fprintf('dropping %2.2f %% of points from scan\n',100*(1 - (length(goodpoints)/size(X{1,i},2))));


    %
    % drop points from both 2D and 3D list
    %
    X{1,i} = X{1,i}(:,goodpoints);
    xR{1,i} = xR{1,i}(:,goodpoints);
    xL{1,i} = xL{1,i}(:,goodpoints);
    xColor{1,i} = xColor{1,i}(:,goodpoints);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % cleaning step 2: remove triangles which have long edges
    %
    
    trithresh = 11;   %11mm
    nbrthresh = 5;
    
    if i==7
        trithresh = 14;
    elseif i==6
        trithresh = 15;
    elseif i==1
        trithresh = 8;
    end
    
    % find the distances between each point and its neighbors
    [ltri, lnerr] = nbr_error(xL{1,i},X{1,i});
    [rtri, rnerr] = nbr_error(xR{1,i},X{1,i});
    
    % find all points in left and right points that do not exceed threshold
    goodpoints = find((lnerr<nbrthresh) & (rnerr<nbrthresh));
    
    % get all the good points
    X{1,i} = X{1,i}(:,goodpoints);
    xR{1,i} = xR{1,i}(:,goodpoints);
    xL{1,i} = xL{1,i}(:,goodpoints);
    xColor{1,i} = xColor{1,i}(:,goodpoints);
    
    % find the edge lengths of all triangles
    [tri_temp, lterr] = tri_error(xL{1,i},X{1,i});
    
    % remove those triangles
    subt = find(lterr<trithresh);


    fprintf('dropping %2.2f %% of triangles from scan\n',100*(1 - (length(subt)/size(tri_temp,1))));

    tri_temp = tri_temp(subt,:);


    %
    % remove unreferenced points which don't appear in any triangle
    %
    allpoints = (1:size(X{1,i},2))';
    refpoints = unique(tri_temp(:)); %list of unique points mentioned in tri

    % build a table describing how we reindex points
    newid = -1*ones(size(allpoints));
    newid(refpoints) = 1:length(refpoints);

    %now newid(k) contains the new index for current point k
    % apply this mapping to all the indicies in tri

    tri_temp = newid(tri_temp);
    % and drop un-referenced points
    X{1,i} = X{1,i}(:,refpoints);
    xR{1,i} = xR{1,i}(:,refpoints);
    xL{1,i} = xL{1,i}(:,refpoints);
    xColor{1,i} = xColor{1,i}(:,refpoints);
    
    % smooth out points by moving them to average of its neighbors
    Y{1,i} = nbr_smooth(tri_temp,X{1,i},5);
    if i==1
        tri = {tri_temp};
    else
        tri{i} = tri_temp;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % display results
    %



    figure(i+9); clf;
    h = trisurf(tri_temp,Y{1,i}(1,:),Y{1,i}(2,:),Y{1,i}(3,:));
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
    
    mesh_2_ply(Y{1,i}, xColor{1,i}, tri_temp, ['mesh_teapot', int2str(i-1), '.ply']);
end

save('mesh.mat', 'Y', 'tri', 'xL', 'xR', 'xColor')
