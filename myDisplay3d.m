function [data_out] = Display3d(data_in, threshold,...
    smoothing, alpha_value)
%Written by Logan Williams, 5/10/2012

%this function will display a 3D volume using 
%isosurface,while performing simple thresholding.

%the threshold is a percentage of the maximum value, 
%and should vary between zero and 1

%smoothing will be gaussian smoothing.  The value of
%smoothing must conform to the smooth3 function,

%which requires odd integer values greater than 1.
%Setting smoothing to zero will disable smoothing
%alpha_value is the percentage of transparency
%between 0 and 1,with 1 = opaque and 0 = transparent

if nargin <4
    alpha_value = 1;  %1 = opaque
end

if nargin <3
    smoothing = 0;  %no smoothing
end

if nargin <2
    threshold = 0.1;  %default at 10% of max value
end

A = data_in;
S = size(A);
b = threshold; %Threshold as a percentage of the maximum value

if smoothing ~= 0
%     Hs = smooth3(A,'box',smoothing);
A = smooth3(A,'box',smoothing);
end

%this section unneccessary maybe -----------------
%threshold by finding all values less than the threshold value and setting
%them equal to zero
A(find(abs(A) < b.*abs(max(max(max(A)))))) = 0;
%-------------------------------------------------

isovalue = b*abs(max(max(max(A))))
V = abs(A);  %must use absolute maginitude (since A could be imaginary)
[m,n,p] = size(V);
[x,y,z] = meshgrid(1:m,1:n,1:p);
fv = isosurface(x,y,z,V,isovalue);
p = patch(isosurface(x,y,z,V,isovalue));
% p = reducepatch(p,0.15)  %doesn't work quite yet


alpha(alpha_value)
%figure(a+4)
isonormals(x,y,z,V,p);
set(p,'FaceColor','red','EdgeColor','none');
%daspect([1 1 1])
box on
%view(-16,-83); axis tight
view(20,80); %axis tight
camlight headlight
%lighting gouraud
lighting phong
xlabel('x')
ylabel('y')
zlabel('z')
title('')
axis([1 S(1) 1 S(2) 1 S(3)]);
