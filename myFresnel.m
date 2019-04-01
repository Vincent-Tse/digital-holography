function [Hr] = myFresnel(hologram,reconstruction_distance,...
    wavelength,pixel_size,in_line,phase_mask,...
    scale_factor,pad_size,ref)% We add the reference beam intensity profile
% %This function reconstructs a hologram using a fresnel transform
% %and returns the reconstructed complex image matrix
% 
% %reconstruction_distance in METERS
% %wavelength in METERS
% %pixel size in METERS (pixels are assumed to be SQUARE)
% 
% %if in_line is set to 1, the hologram will rescale with distance about the
% %zero order (usefull for in-line holograms), defaults to 0
% %NOTE: reconstruction_dist must be positive for in_line scaling to work
% 
% %phase_mask should be the same size as the hologram
% %if either one is not square, they will be cropped to square
% %if a scalar value is entered for phase_mask,
% %a constant array of that value is used (i.e. uniform phase, plane wave)
% 
% %scale_factor will change the size of the original hologram
% %scale factor should go above 1 now (updated 7 May 2013)
% %increasing the scale factor will dramatically improve the reconstruction
% %results when in the very near field (without extra padding)
% %scale_factor defaults to 1
% %reducing the scale factor too low (<1/2 or so) will begin vignetting the
% %image significantly, losing the higher spatial freq info due to
% %resampling losses.
% %for very large CCD arrays, scale the image down
% %for very near field holograms, scale the image up

%%%%%Begin Function
A = size(hologram);
if nargin < 8
    pad_size = 0;       %default to zero padding
end
if nargin < 7
    scale_factor = 1;   %default to original size
end
if nargin < 6
    phase_mask = 1;     %default to uniform phase (const, plane wave)
end
if nargin < 5
    in_line = 0;        %default to off-axis style hologram
end
if nargin < 4
    error('Not enough input arguments')    
end
if length(phase_mask) == 1
     phase_mask = ones(A).*phase_mask; 
end
B = phase_mask;
H = hologram;
R = ref;
d = reconstruction_distance;
w = wavelength;
dx = pixel_size;

%if the image is not square, crop to be square along the smallest dimension
%This cropping is done manually (i.e. without the imcrop function), and
%should be fairly robust
if A(1,1)<A(1,2)
    %crop the x axis of the image to match the y axis
    %crops symmetrically about the center
    H = H(:,round(A(1,2)/2+1-A(1,1)/2):round(A(1,2)/2+A(1,1)/2));
    B = B(:,round(A(1,2)/2+1-A(1,1)/2):round(A(1,2)/2+A(1,1)/2));
    R = R(:,round(A(1,2)/2+1-A(1,1)/2):round(A(1,2)/2+A(1,1)/2));
end

if A(1,1)>A(1,2)  
    %crop the y axis of the image to match the x axis
    H = H'; %transpose
    B = B';    
    R = R'; 
    C = size(H);  %this is the line that fixes this part
    %after transposing, the sizes didn't match anymore    
    H = H(:,round(C(1,2)/2+1-C(1,1)/2):round(C(1,2)/2+C(1,1)/2)); %crop
    B = B(:,round(C(1,2)/2+1-C(1,1)/2):round(C(1,2)/2+C(1,1)/2)); %crop
    R = R(:,round(C(1,2)/2+1-C(1,1)/2):round(C(1,2)/2+C(1,1)/2)); %crop
    H = H'; %transpose back
    B = B';
    R = R';
    %not sure if this works perfectly yet - havent had to try it
end

%use double precision to allow for complex numbers
H = double(H);
B = double(B);
R = double(R);

%if the image is too big to compute efficiently, scale it down.
%to scale above 1, the phase mask can cause problems because the phase
%does not scale well with bicubic resampling.  An appropriate phase mask
%should be generated external to this function
if scale_factor ~= 1
    H = imresize(H, scale_factor,'bicubic');  
    R = imresize(R, scale_factor,'bicubic'); 
    if length(B(:,1)) > 1  %only rescale profile if it's not a scalar
        B = imresize(B, scale_factor,'bicubic'); 
    end
    dx=dx/scale_factor;
end

n = length(H);   %size of hologram matrix nxn
H = double(H)-mean(mean(H));  %must be class double for imaginary #s

if pad_size > 0  %only pad array AFTER mean subtraction
    nr = length(H);  %save the orgiginal size
    H = padarray(H,[pad_size pad_size]);  %pad the array
    R = padarray(R,[pad_size pad_size]);
    n = length(H);  %reset n after padding
    dx = ((nr/(n-pad_size*2))*pixel_size);  %account for pad in scale
    dx=dx/scale_factor;

    if length(B(:,1)) > 2
%         fprintf('Cannot pad with beam profile input. /n Assuming plane wave. /n');
        B = 1;
    end
end

dy = dx;  %assumes square CCD pixels --> modify as needed for rectangle pixels
Hr = complex(zeros(n));  %reconstructed H
E = complex(zeros(n));  %exponential term

%verified correct feature size (i.e. reconstructed pixel sizes)
feature_size = abs(w*d/(length(H)*dx)) 

k = -n/2:1:n/2-1; %array same dimentions as hologram
l = -n/2:1:n/2-1;
[XX,YY] = meshgrid(k,l);

%Calculate the Fresnel Transform 
E(k+n/2+1,l+n/2+1) = B.*exp((-1i*pi/(w*d)).*((XX.*dx).^2 + (YY.*dy).^2));
%Reconstruction becomes complex valued
size(H);
size(R);
Hr = (fftshift(fft2(H.*R.*E)));

%If padded. . .
if pad_size >0   %cut the initial padding back out
    Hr = Hr(pad_size:nr+pad_size, pad_size:nr+pad_size);
end
    
%Rescaling for IN-LINE HOLOGRAMS ONLY
%scale by CCD size/object feature size = # of pixels to keep  
%rescales based upon the zero order size only
if in_line == 1
    N = min(A);  %smallest dimension of original hologram
    obj_f = w*d/(N*dx);    
    P = round(N*dx/obj_f);  %should be size of center region
    %if P is odd, make it even
    if (mod(P,2) == 1)  %if first demension has odd number of rows
        P = P+1;
    end
    %end rescaling of fresnel transform
  
    if (P<N)        
        [Hr] = Hr(round(N/2+1-P/2:N/2+P/2),round(N/2+1-P/2:N/2+P/2));
    end
    
    else if in_line == 0
       [Hr] = Hr;
    end 

end %end function
