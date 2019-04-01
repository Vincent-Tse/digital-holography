# digital-holography
digital holography with matlab

Code used are based from 
Nemetallah, G. T., Aylo, R., & Williams, L. A. (2015). Analog and digital holography with MATLAB. SPIE press.

For Phys 397 project
University of Alberta

Vincent Tse

Partner: Alejandro Salazar Lobos

## Components

frensel_reconstruction.m
  * Take interference pattern and reconstruct image
  
tomography.m
  * Take various frensel reconstructed images of object side view and build a 3D model of such
  * sub-function:Rigid3D.m,myLoftAndRotate.m,myDisplay3d.m,myFresnel.m
  
Rigid3D.m
  * Rotate the 3D matrix
  
myLoftAndRotate.m
  * Raise 2D matrix to 3D and use Rigid3D.m to rotate
  
myDisplay3d.m
  * Take a 3D matrix and display the corresponding 3D images
  
myFresnel.m
  * work under same principle of frensel_reconstruction
  
