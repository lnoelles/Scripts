function [ MostIntenseSpot ] = BindingByMatrixGeneration(SingleFrame,ImagesGenerated)
%Trying something weird here. It might be a long shot. It might also work.
%This function will be part of a larger group of functions that will
%attempt to identify binding events by tracking the movement of the
%brightest AREA of pixels from frame to frame. The theory is that there
%will be overlap in where the brightest area of pixels is located if there
%is binding, because from frame to frame it's caused by the same source.
%While areas of brightness that are not caused by binding events will move
%from frame to frame much more because of a) oligo speed and b) different
%sources for the brightest patch. This is really a long shot though, but I
%do want to try it.
%   This function will take a single video frame as input (or a still
%   image), locate the brightest square area of dimension parameter and
%   output a new matrix the same size as the original, but with 0 outside
%   of the brightest area and 1 inside the brightest area.
%   Image should already be loaded with imread (that step will be performed
%   in one of the higher functions when I get there)
%   Images Generated: set to 1 if you want analysed images and 0 if you
%   don't (0 is recommended for large data sets)

%Parameters
AreaSize=6; %specify length of area to be examined

%generate an image if parameter is specified (might take this out)
if ImagesGenerated==1
    %Create figure for comparison
    figure
    %set the colour map to black and white
    %produce the image
    image(mat2gray(SingleFrame))
end

%determine dimensions of image.
[M,N]=size(SingleFrame);

%Create matrix to store mean intensity results
MeanInt=zeros(M-AreaSize,N-AreaSize); %this gives number of areas to check
MatrixOfSizeArea=zeros(M,N);

%Determine the mean intensity of each AreaxArea section of the matrix
for i=1:(M-AreaSize) %loop through rows
    for j=1:(N-AreaSize) %loop through columns
        %define the matrix of size area
        for k=1:AreaSize %look through next AreaSize rows
            for l=1:AreaSize %look through next AreaSize columns
                %get intensity of each pixel in this particular area
                MatrixOfSizeArea(k,l)=SingleFrame(i-1+k,j-1+l);
            end
        end
        %find mean intensity of the area
        MeanInt(i,j)=mean(mean(MatrixOfSizeArea));
    end
end

%Find which mean intensity is max.
MaxAll=max(max(MeanInt));
%determine the index of the max value
[MaxLocationX,MaxLocationY]=find(MeanInt==MaxAll,1);

%Create output matrix
MostIntenseSpot=zeros(M,N);

for i=MaxLocationX:MaxLocationX+AreaSize-1
    for j=MaxLocationY:MaxLocationY+AreaSize-1
        MostIntenseSpot(i,j)=255;%so it is visible on images to check work
    end
end

%generate an image if parameter is specified
if ImagesGenerated==1
    %Create figure for comparison
    figure
    %set the colour map to black and white
    co=[0:255]/256; 
    colormap([co;co;co]');
    %produce the image
    image(MostIntenseSpot)
end

end

