function [Output_Volume] = ...
    myLoftAndRotate(input_matrix,scale_factor,angle)
%written by Logan Williams, 5/10/2012

%this function will accept a 2D or 3D input matrix 
% and loft it along the z axis to make it a cube.  
% If angle is set to a non-zero value, the matrix
%will also be rotated using the rigid3D function.

%THIS FUNCTION ONLY WORKS RIGHT FOR MATRICIES THAT 
% ARE SQUARE IN X AND Y there is no error checking
% to enforce this requirement

%if the matrix is already a 3D volume, but not a cube,
%this function will loft it along the z axis to make
% it a cube by lofting the space between the original
% planes of the matrix. WRITTEN, BUT NOT TESTED YET

%input_matrix should already be square, or it will not loft to a cube

%scale_factor should be less than 1, to avoid memory
% over runs.Defaults to 1 if no scale factor is given

%angle is in degrees, defaults to zero if no angle is
% given.  The rotation will only be in the x-z plane.
% If some other rotation plane is desired,
%call this function to loft with an angle of zero,
% then call rigid3D afterwards for arbitrary rotation

%input matrix is converted to single to minimize 
%memory use

if nargin < 3
    angle = 0;   
end
if nargin < 2
    scale_factor = 1; 
end

A = size(input_matrix);

if A(1) ~= A(2)
    warning('Input matrix is not square in x & y, will not loft properly')
end


%Resize the matrix to be more memory efficient
if scale_factor ~= 1
    
%     str = sprintf('Recommended scale factor is (%s) for 100x100x100 cube', 1/(A(1)/100));
%     disp(str);
    
    input_matrix = imresize(input_matrix, scale_factor,'bilinear');  
    
%     if scale_factor > 0.5
%         warning('Scaling factor > 0.5 could result in memory overrun, proceeding anyway. . .')
%     end
    if (A(1)*scale_factor) > 100
        warning('Matrix size > 100x100x100 could result in memory overrun, proceeding anyway. . .')
    end

end

A = size(input_matrix);  %get resized input matrix
n = A(1);  %length of resized y dimension, chosen arbitrarily


%if input matrix is 2D, loft using repmat
if length(A) == 2
    S=zeros(n,n,n);
    S=single(S);    
    S=repmat(input_matrix,[1 1 n]); %loft the image by n layers
end

%if input matrix is 3D, loft between existing layers
if length(A) == 3
    nz=length(input_matrix(1,1,:));
    S = zeros(n,n,n);
    S=single(S);
    for c=1:1:n
        S(:,:,c) = single(abs(input_matrix(:,:,ceil(c/(n/nz)))));
    end
end
    
if angle ~= 0
    if angle ~=90
        S=rigid3D(S,angle,0,0,0,0,0);
    end
    
    if angle == 90
        S = permute(S,[1 3 2]);  %not sure if this is the right permutation
        % not 1 3 2, 3 2 1, 3 1 2
    end    
end

Output_Volume = S;


end  %function end
