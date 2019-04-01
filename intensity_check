%Partial code from Fresnel Reconstruction Used to match intensity of object, reference beam
clc
clear all;

% Input Image
image = imread('queen3.bmp');
image = double(rgb2gray(image));

% Crop to have rows equal to columns
[Ny,Nx] = size(image);
minN = min(Ny,Nx);
image = image(1:minN,1:minN);

mean = 1/(Nx*Ny)*sum(sum(image))

figure
mesh(image);
