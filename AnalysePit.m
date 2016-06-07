function [ OverlapAmount, BindingEvent ] = AnalysePit(PitVid)
%Load a video file. It will load is as a video, run it through
%BindingByMatrixGeneration frame by frame to get an array of matrices that
%only contain values in the area of highest intensity. This will then be
%passed through some more analysis to determine where these areas are wrt
%to surrounding frames and use this information to determine wheter or not
%binding occurs. This method may not work in the rare case of binding
%occuring during a video.

%parameters
%threshold is the minimum number of overlapping pixels to classify the
%event as a binding event

%thresh=1100;

%if we decide to add a second check
high_thresh=1500;
low_thresh=1100;

%Find the dimensions of the imported video matrix
M=size(PitVid,1);
N=size(PitVid,2);
FrameNumber=size(PitVid,3);

%create output matrix for loop
AnalysedVid=zeros(M,N,FrameNumber);


%create a waitbar
h= waitbar(0,'Please Wait...');
%Run BindingByMatrixGeneration for each frame of the video and load the
%result into AnalysedVid
for i=1:FrameNumber
    waitbar(i/FrameNumber,h)
    AnalysedVid(:,:,i)=BindingByMatrixGeneration(PitVid(:,:,i),0);
    %Compare each frame to the frame before it to see if there is any overlap
    %between the non-zero elements. Output into a new matrix. From the ==
    %function, values will be 1 where there is overlap and 0 where there is
    %not.
    if i>1
        for j=1:M
            for k=1:N
                if AnalysedVid(j,k,i)~=0 && AnalysedVid(j,k,i)==AnalysedVid(j,k,i-1)
                    ComparisonMatrix(j,k,i-1)=1;
                end
            end
        end
        %keep track of how many times there is no overlap
        if ComparisonMatrix(:,:,i-1)==0
            NoBinding=NoBinding+1;
        else
            NoBinding=NoBinding-1;
        end
        %terminate the loop if the number of frames with no overlap exceeds 100
        %(chosen from analysing a handful of pits).
        if NoBinding==10
            break
        end
    end
end
close(h);

%Find how many non-zero elements there are
[X,~]=find(ComparisonMatrix);
OverlapAmount=size(X,1);
if OverlapAmount>high_thresh
    %disp('This is a binding event');
    BindingEvent=1;
elseif OverlapAmount<low_thresh
    %disp('This is not a binding event');
    BindingEvent=0;
else
    %disp('Mebs')
    BindingEvent=2;        
end

disp(NoBinding);
end

