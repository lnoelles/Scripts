%allows user to select a single video to analyze. It then looks through that
%video's folder and finds the corresponding default grid. The video
%and grid paths are then fed into AnalyzeFullVideo.

%Improvements needed: 

%1)The current folder needs to be changed to the video folder and back
%so that the scripts can be run, as they are in different folders.

%2)Will want to allow the user to select several videos. This will come when
%the analysis is improved for a single video. This will also require a more
%sophisticated way of getting the matching default grid, though the current method
%takes 0.01 s and a loop could potentially be used.

%3)This assumes that the video and default grid filenames stop overlapping
%after 'MMStack'. If the file naming scheme is changed, this will need to be
%modified. Perhaps find a more general way to do this?

function [a,b]=ScriptToRunAnalysis()

%save the current folder so we can return to it later
scriptfolder=pwd;

%get user to select a video to analyze
[vid_name,vid_folder]=uigetfile('*.tif','Select a video to analyze');
%get the full path to the video (so it includes the filename)
vid_path=fullfile(vid_folder,vid_name);
%find index where 'MMStack' begins
compareindex=regexp(vid_name,'MMStack')-1;

%find associated default grid

%load default grids from current folder into a structure
cd(vid_folder); %change current folder to video's folder
default_grids=dir('*_DefaultGrid*.mat'); %load default grids
cd(scriptfolder); %go back to previous current folder

%get the grid names
grid_names={default_grids.name};
%compare vid_name to grid_names to find corresponding grid
grid_index=cellfun(@(x)strncmp(x,vid_name,compareindex),grid_names);
matching_grid=cell2mat(grid_names(grid_index));

%get default grid path by tacking on video folder info (this assumes that
%the grid and video can be found in the same folder, as they should be)
grid_path=strcat(vid_folder,matching_grid);

[a,b]=AnalyzeFullVideo(vid_path,grid_path);

end