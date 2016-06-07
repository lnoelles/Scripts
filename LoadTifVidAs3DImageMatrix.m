function [ Video ] = LoadTifVidAs3DImageMatrix( FilePath )
%Loads a tiff stack as a 3D matrix: widthxheightxframe

%How to taken from: http://www.matlab-cookbook.com/recipes/0900_Movies/030_readTiffMovie.html
%And adapted and written out for my purposes. But mostly just copied
%because this seems to be the simplist most straightforward way to do it.
%load info from file
%Overall, there is something weird when I try to load the image/video, but
%after the manipulations of the binding event function, the resulting
%images seem normal, so I'm leaving it for now
info=imfinfo(FilePath);
%Extract frame number of video
FrameNumber=size(info,1);
%Figure out size of multidimensional array. It will be height x width x number
%of videos
VideoSize=[info(1).Height,info(1).Width,FrameNumber];
%make an array of zeros of size Video Size to load the video into
Video=ones(VideoSize);

%Load in video frame by frame
for i=1:FrameNumber
    Video(:,:,i)=imread(FilePath,i);
end

end

