function [ OverlapValues, BindingEvents ] = AnalyzeFullVideo( FilePath, FittedGridFilePath )
%This file takes a file path for an entire video and a corresponding grid,
%generated from Catherine's GridRegistration code, that is fitted to the
%video. It splits the video into pits and passes each pit to
%'AnalysePit', which in turn passes each frame to
%'BindingByMatrixGeneration'. It returns two matrices: one of how much
%overlap there was between photons and one of whether or not there was a
%binding event.
%Input is a file path each for the image to be analysed and the fitted
%grid.

%Load file as a video
FullVid=LoadTifVidAs3DImageMatrix(FilePath);%Can also call TifSample from Catehrine's code at this step to load the vid.

%Find the dimensions of the video
M=size(FullVid,1);
N=size(FullVid,2);
FrameNumber=size(FullVid,3);

%Load the file path
load(FittedGridFilePath);
%seperate out parameters into usable variables.
PitPositions=floor(varargout{1,1});
NumPits=size(PitPositions,1);
Radius=floor(varargout{1,2});
NumRows=varargout{1,3};
NumColumns=varargout{1,4};

%calculate background intensity
%[~,Background]=CalculateBackground(FullVid,Radius);
%subtract background intensity
vid_no_background=FullVid;%-Background;

%Create figure of first frame to check my work
%Create figure for comparison
%The file used here is purely for test purposes as I am unable to figure
%out how to load a single frame of a tif as an image
SingleFrame=imread(FilePath);

%testing
figure
%produce the image
imshow(mat2gray(SingleFrame))
%allow image to stay while I add things to it
hold on

%Create matrix for use in loop.
OverlapValues=zeros(NumPits,1);
BindingEvents=zeros(NumPits,1);
%create a waitbar
h=waitbar(0,'Analysing Each Pit.');
%Create small segments of video, each the size of a pit. Step 1:

for i=1:NumPits
    waitbar(i/NumPits,h)
    try
        SinglePitCentre=[PitPositions(i,1),PitPositions(i,2)];
        PitTemplate=vid_no_background((SinglePitCentre(2)-Radius):(SinglePitCentre(2)+Radius),(SinglePitCentre(1)-Radius):(SinglePitCentre(1)+Radius),:);
        %analyze the single pit by passing it to AnalysePit (which in
        %turn passes it to BindingByMatrixGeneration frame by frame)
        [OverlapValues(i),BindingEvents(i)]=AnalysisOverVideo(PitTemplate);
        %plot a circle around the pit to verify what we are measuring
        if BindingEvents(i,1)==1
            viscircles(SinglePitCentre,Radius,'EdgeColor','g');
        elseif BindingEvents(i,1)==0
            viscircles(SinglePitCentre,Radius,'EdgeColor','r');
        else
            viscircles(SinglePitCentre,Radius,'EdgeColor','c');
        end
    catch
        continue;
    end
    %testing
    %figure
    %imshow(mat2gray(PitTemplate(:,:,1)))
end
close(h);

%Turn the vector into a matrix that corresponds with the pit positions
OverlapValues=reshape(OverlapValues,NumRows,[]);
OverlapValues=OverlapValues';
BindingEvents=reshape(BindingEvents,NumRows,[]);
end

