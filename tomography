format compact
close all
%%%This code is based on Frensel Reconstruction
%%%Record and Reconstruct images at various angle 
%%%multiply the image matrix and built a 3D image

%Reconstruction Parameters
scale = .05;  			%scale for resizing the holograms (conserves memory)
d = [0.33];			Re	  %distance
w = 635e-9;			  	%wavelength
dx = 2.2e-6;			  %pixel size, assumed square
padsize = 1950;  		%size of zero padding (increases resolution)

ref = rot90(imread('ref_sq14.bmp','bmp'),2);    %reference beam
for i = [1:length(d)]
    obj = rot90(imread('pic0.bmp','bmp'),2);                          %read in interference pattern
    H0 = abs(myFresnel(obj,d(i),w,dx,false,1,1,padsize,ref));         %Fresnel Reconstruction
    H0 = myLoftAndRotate(H0,scale,0);                                 %lofts 2D matrix to 3D, but doesn't rotate
    
    %repeat for the other 12 angles
    obj = rot90(imread('pic15.bmp','bmp'),2);
    H15 = abs(myFresnel(obj,d(i),w,dx,false,1,1,padsize,ref));
    H15 = myLoftAndRotate(H15,scale,15);                              %rotate by 15 degree

    obj = rot90(imread('pic30.bmp','bmp'),2);
    H30 = abs(myFresnel(obj,d(i),w,dx,false,1,1,padsize,ref));
    H30 = myLoftAndRotate(H30,scale,30);  

    obj = rot90(imread('pic45.bmp','bmp'),2);
    H45 = abs(myFresnel(obj,d(i),w,dx,false,1,1,padsize,ref));
    H45 = myLoftAndRotate(H45,scale,45);  

    obj = rot90(imread('pic60.bmp','bmp'),2);
    H60 = abs(myFresnel(obj,d(i),w,dx,false,1,1,padsize,ref));
    H60 = myLoftAndRotate(H60,scale,60);  

    obj = rot90(imread('pic75.bmp','bmp'),2);
    H75 = abs(myFresnel(obj,d(i),w,dx,false,1,1,padsize,ref));
    H75 = myLoftAndRotate(H75,scale,75);  

    obj = rot90(imread('pic90.bmp','bmp'),2);
    H90 = abs(myFresnel(obj,d(i),w,dx,false,1,1,padsize,ref));
    H90 = myLoftAndRotate(H90,scale,90);  

    obj = rot90(imread('pic105.bmp','bmp'),2);
    H105 = abs(myFresnel(obj,d(i),w,dx,false,1,1,padsize,ref));
    H105 = myLoftAndRotate(H105,scale,105);  

    obj = rot90(imread('pic120.bmp','bmp'),2);
    H120 = abs(myFresnel(obj,d(i),w,dx,false,1,1,padsize,ref));
    H120 = myLoftAndRotate(H120,scale,120);  

    obj = rot90(imread('pic135.bmp','bmp'),2);
    H135 = abs(myFresnel(obj,d(i),w,dx,false,1,1,padsize,ref));
    H135 = myLoftAndRotate(H135,scale,135);  

    obj = rot90(imread('pic150.bmp','bmp'),2);
    H150 = abs(myFresnel(obj,d(i),w,dx,false,1,1,padsize,ref));
    H150 = myLoftAndRotate(H150,scale,150);  

    obj = rot90(imread('pic165.bmp','bmp'),2);
    H165 = abs(myFresnel(obj,d(i),w,dx,false,1,1,padsize,ref));
    H165 = myLoftAndRotate(H165,scale,165);  

    obj = rot90(imread('pic180.bmp','bmp'),2);
    H180 = abs(myFresnel(obj,d(i),w,dx,false,1,1,padsize,ref));
    H180 = myLoftAndRotate(H180,scale,180);  

    %%  Multiply the various angles
    H13 = H0.*H15.*H30.*H45.*H60.*H75.*H90.*H105.*H120.*H135.*H150.*H165.*H180;
    figure
    myDisplay3d(H13,0.0003) %all 13 Angles (0.0003 threshold is best)
    view(-68,28); axis tight
    grid on
    title(strcat('Tomographic Reconstruction,d =',d(i),'m'))

    %%  Automatically set tick marks on the axis of the figures
    s = length(H0);
    Inc = (w*d/((1940+2*padsize)*(dx)))/scale;  %480 is original hologram size
    Inc = Inc.*1000; %change increment to (mm) for plotting

    tickmarksx = 1:floor(s/6):s;
    tickmarksy = 1:floor(s/6):s;
    tickmarksz = 1:floor(s/6):s;
    scalex = 0:floor(s/6)*Inc:(Inc*length(H0));
    scaley = 0:floor(s/6)*Inc:(Inc*length(H0));
    scalez = 0:floor(s/6)*Inc:(Inc*length(H0));

    set(gca,'XTick',tickmarksx)
    set(gca,'XTickLabel',scalex)
    set(gca,'YTick',tickmarksy)
    set(gca,'YTickLabel',scaley)
    set(gca,'ZTick',tickmarksz)
    set(gca,'ZTickLabel',scalez)
    ylabel('y (mm)') 
    xlabel('x (mm)')
    zlabel('z (mm)')
end
