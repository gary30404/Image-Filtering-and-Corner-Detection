% My Harris detector
% The code calculates
% the Harris Feature/Interest Points (FP or IP) 
% 
% When u execute the code, the test image file opened
% and u have to select by the mouse the region where u
% want to find the Harris points, 
% then the code will print out and display the feature
% points in the selected region.
% You can select the number of FPs by changing the variables 
% max_N & min_N

%%%
%corner : significant change in all direction for a sliding window
%%%

%%
% parameters
% corner response related
sigma=2;
n_x_sigma = 6;
alpha = 0.04;
% maximum suppression related
Thrshold=20;  % should be between 0 and 1000
r=6; 


%%
% filter kernels
dx = [-1 0 1; -1 0 1; -1 0 1]; % horizontal gradient filter 
dy = dx'; % vertical gradient filter
g = fspecial('gaussian',max(1,fix(2*n_x_sigma*sigma)), sigma); % Gaussien Filter: filter size 2*n_x_sigma*sigma


%% load 'Im.jpg'
frame = imread('data/Im.jpg');
I_ori = double(frame);
I = double(rgb2gray(frame));
figure(1);
imagesc(frame);

%%%%%%%%%%%%%%Intrest Points %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
k = waitforbuttonpress;
button_down = get(gca,'CurrentPoint');
rectregion = rbbox;               
button_up = get(gca,'CurrentPoint');
point1 = button_down(1,1:2);            
point2 = button_up(1,1:2);
lowerleft = min(point1, point2);
upperright = max(point1, point2); 
ymin = round(lowerleft(1));
ymax = round(upperright(1));
xmin = round(lowerleft(2));
xmax = round(upperright(2));
I = I_ori(xmin:xmax,ymin:ymax);
I_ori = I_ori(xmin:xmax,ymin:ymax,:);
%}
%%%%%%
% get image gradient
% [Your Code here] 
% calculate Ix
% calcualte Iy
Ix = conv2(I, dx, 'same');
Iy = conv2(I, dy, 'same');
%%%%%

% get all components of second moment matrix M = [[Ix2 Ixy];[Iyx Iy2]]; note Ix2 Ixy Iy2 are all Gaussian smoothed
% [Your Code here] 
% calculate Ix2  
% calculate Iy2
% calculate Ixy
Ix2 = conv2(Ix.^2, g, 'same');
Iy2 = conv2(Iy.^2, g, 'same');
Ixy = conv2(Ix.*Iy, g, 'same');
%%%%%

%% visualize Ixy
figure(2);
imagesc(Ixy);

%%%%%%% Demo Check Point -------------------

%%%%%
% get corner response function R = det(M)-alpha*trace(M)^2 
% [Your Code here] 
% calculate R
det = (Ix2.*Iy2) - Ixy.^2;
trace =Ix2 + Iy2;
R = det - alpha*(trace).^2;
%%%%%

%% make R value range from 0 to 1000
R=(1000/max(max(R)))*R;
figure(3);
imagesc(R);
%%%%%

%% using B = ordfilt2(A,order,domain) to complment a maxfilter
sze = 2*r+1; % domain width 
% [Your Code here] 
% calculate MX
MX = ordfilt2(R, sze^2, true(sze));
%%%%%

%%%%%
% find local maximum.
% [Your Code here] 
% calculate RBinary
RBinary = (R==MX)&(R>Thrshold); 
%%%%%


%% get location of corner points not along image's edges
offe = r-1;
count=sum(sum(RBinary(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe))); % How many interest points, avoid the image's edge   
R=R*0;
R(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe)=RBinary(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe);
[r1,c1] = find(R);
PIP=[r1,c1]; % IP , 2d location ie.(u,v)
  

%% Display
figure(4)
imagesc(uint8(I_ori));
hold on;
plot(c1,r1,'or');
return;
