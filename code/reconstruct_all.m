%
% load in calibration data
%

load calibration.mat

thresh = 0.037;
scandir = 'teapot/grab_';

for i=1:7
    [L_h,L_h_good] = decode([scandir int2str(i-1) '/frame_C1_'],0,19,thresh);
    [L_v,L_v_good] = decode([scandir int2str(i-1) '/frame_C1_'],20,39,thresh);
    [R_h,R_h_good] = decode([scandir int2str(i-1) '/frame_C0_'],0,19,thresh);
    [R_v,R_v_good] = decode([scandir int2str(i-1) '/frame_C0_'],20,39,thresh);


%
% visualize the masked out horizontal and vertical
% codes for left and right camera
%
    figure(i+1); clf;
    subplot(2,2,1); imagesc(R_h.*R_h_good); axis image; axis off;title('right camera, h coord');
    subplot(2,2,2); imagesc(R_v.*R_v_good); axis image; axis off;title('right camera,v coord');
    subplot(2,2,3); imagesc(L_h.*L_h_good); axis image; axis off;title('left camera,h coord');  
    subplot(2,2,4); imagesc(L_v.*L_v_good); axis image; axis off;title('left camera,v coord');  
    colormap jet

%
% combine horizontal and vertical codes
% into a single code and a single mask.
%
    
    % find background pixels to mask out by finding squared error
    l_rgb = im2double(imread([scandir int2str(i-1) '/color_C1_01.png']));
    l_rgb_bg = im2double(imread([scandir int2str(i-1) '/color_C1_00.png']));

    r_rgb = im2double(imread([scandir int2str(i-1) '/color_C0_01.png']));
    r_rgb_bg = im2double(imread([scandir int2str(i-1) '/color_C0_00.png']));

    l_color_mask = sum(abs(l_rgb - l_rgb_bg),3).^2 > thresh;
    r_color_mask = sum(abs(r_rgb - r_rgb_bg),3).^2 > thresh;

    Rmask(:,:,i) = r_color_mask & R_h_good & R_v_good;
    R_code = R_h + 1024*R_v;
    Lmask(:,:,i) = l_color_mask & L_h_good & L_v_good;
    L_code = L_h + 1024*L_v;



    %
    % now find those pixels which had matching codes
    % and were visible in both the left and right images
    %
    % only consider good pixels
    Rsub = find(Rmask(:,:,i));
    Lsub = find(Lmask(:,:,i));

    % find matching pixels 
    [matched,iR,iL] = intersect(R_code(Rsub),L_code(Lsub));
    indR = Rsub(iR);
    indL = Lsub(iL);

    % indR,indL now contain the indices of the pixels whose 
    % code value matched

    % pull out the pixel coordinates of the matched pixels
    [h,w] = size(Rmask(:,:,i));
    [xx,yy] = meshgrid(1:w,1:h);
    
    xR{1,i}(1,:) = xx(indR);
    xR{1,i}(2,:) = yy(indR);
    xL{1,i}(1,:) = xx(indL);
    xL{1,i}(2,:) = yy(indL);

    %
    % now triangulate the matching pixels using the calibrated cameras
    %
    X{1,i} = triangulate(xL{1,i},xR{1,i},camL,camR);
    
    % separate pixels into R G and B channels in right and left images
    l_r = l_rgb(:,:,1);
    l_g = l_rgb(:,:,2);
    l_b = l_rgb(:,:,3);
    r_r = r_rgb(:,:,1);
    r_g = r_rgb(:,:,2);
    r_b = r_rgb(:,:,3);
    
    % average of both left and right image colors
    xColor{1,i}(1,:) = 0.5*(l_r(indL) + r_r(indR));
    xColor{1,i}(2,:) = 0.5*(l_g(indL) + r_g(indR));
    xColor{1,i}(3,:) = 0.5*(l_b(indL) + r_b(indR));
    
    
    % plot 3D view
    figure(i+1); clf;
    plot3(X{1,i}(1, :), X{1,i}(2, :), X{1,i}(3, :), '.')
    axis image; axis vis3d; grid on;
    hold on;
    plot3(camL.t(1),camL.t(2),camL.t(3),'ro')
    plot3(camR.t(1),camR.t(2),camR.t(3),'ro')
    % axis([-200 400 -200 300 -200 200])
    set(gca,'projection','perspective')
    xlabel('X-axis');
    ylabel('Y-axis');
    zlabel('Z-axis');
end




%
% save the results of all our hard work
%
save('reconstruction.mat','X','xL','xR','camL','camR','Lmask','Rmask','xColor');


