
function err = project_error_ext(params,X,xL, cam)

%
% wrap our project function for the purposes of optimization
%  params contains the parameters of the camera we want to 
%  estimate.  X,cx,cy are given.
%

%location of camera center  %not optimized
cam.R = buildrotation(params(1),params(2),params(3));
cam.t = params(4:6)';


x = project(X,cam);
err = x-xL;


figure(4);  clf;
plot(x(1,:),x(2,:),'b.'); hold on;
plot(xL(1,:),xL(2,:),'r.');
axis image;
drawnow;

