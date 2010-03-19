 function R_updated = launchRandomWalker_RWtool(image3D,S, R)
% S_UPDATED = LAUNCHRANDOMWALKER_RWTOOL(IMAGE3D,S) performs random walk
% based segmentation. 
% Input:  IMAGE3D = 3D image
%               S = structure containing previous results of mask and
%                   probability map along with other parameters (see
%                   setUpGUI.m for other paramenters)
% Output: S_updated = structure containing updated segmentation results of
%                     mask and probability map
%
% 03/15/2010 - Nayanjyoti Pathak

% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307,
% USA.


% Get current slice number
sliceNum = get(S.sl,'value');

% Get buffer amounts
bfr = str2mat((get(S.ed2,'string')));
xy_bfr = str2double(bfr(1,:)); z_bfr = str2double(bfr(2,:));
% Get screen size
SCR = get(0,'Screensize');
% Save some memory
image3D   = im2single(image3D);

% Pad the previous results with zeros 
[r, c, f] = size(image3D);
temp_probabilities = zeros(r+2*xy_bfr, c+2*xy_bfr, f+2*z_bfr);
temp_probabilities(xy_bfr+1:r+xy_bfr,xy_bfr+1:c+xy_bfr, z_bfr+1:f+z_bfr)...
                   = R.temp_probabilities; 
temp_mask          = zeros(r+2*xy_bfr, c+2*xy_bfr, f+2*z_bfr);
temp_mask(xy_bfr+1:r+xy_bfr,xy_bfr+1:c+xy_bfr, z_bfr+1:f+z_bfr) ... 
                   = R.temp_mask;
               
% Get the current slice for display
img   = image3D(:,:,sliceNum);

% Plot currently selected slice for input of seed points
RW.fh = figure('name','Place foreground and background seeds here', ...
               'units','pixels', ...
               'resize','off', ...
               'position',[SCR(3)-SCR(4)/r*c ,1, SCR(4)/r*c, SCR(4)], ...
               'NumberTitle','off');
imagesc(img);colormap(gray);hold on;

% Loop, picking up the points.
xy = [];
disp('FOREGROUND')
disp('Left mouse button picks points.')
disp('Right mouse button picks last point.')
but = 1;
numpts = 0;
class_label = [];
while ((but == 1) || (but == 2))
    [xi,yi,but] = ginput(1);
    if (but ~= 2)
	plot(xi,yi,'r.','MarkerSize',5)
	numpts = numpts+1;
	xy(:,numpts) = [xi;yi]; %#ok<*AGROW>
	class_label = [class_label 1];
    end
    if (but == 2)
	disp('undoing last point')
	xy(:,numpts) = [];
	numpts = numpts - 1;
	class_label(length(class_label))= [];
    end
end


disp('BACKGROUND')
but = 1;

while ((but == 1) || (but == 2))
    [xi,yi,but] = ginput(1);
    if (but ~= 2)
	plot(xi,yi,'b.','MarkerSize',5)
	numpts = numpts+1;
	xy(:,numpts) = [xi;yi];
	class_label = [class_label 2];
    end

    if (but == 2)
	disp('undoing last point')
	xy(:,numpts) = [];
	class_label(length(class_label))= [];
	numpts = numpts - 1;
    end
end

% Rounding to avoid any non integer index access errors
xy = round(xy);

% Create a sub sample of the 3D image with selected region of interest
% based on locations of the seed points. 
[sub_image3D, sub_xy, subInd] = subSample(xy, image3D, sliceNum, xy_bfr, z_bfr);
[X Y dummy] = size(sub_image3D); %#ok<*NASGU>

% update indices
indexes = sub2ind([X Y],sub_xy(2,:),sub_xy(1,:)) + z_bfr*X*Y;

% Apply the random walker algorithm on the sub sampled image
[mask,probabilities] = myRandomWalker(sub_image3D,indexes,class_label);

% Assign the results in appropriate locations
temp_probabilities(subInd.yRngMin:subInd.yRngMax,subInd.xRngMin:subInd.xRngMax,...
    subInd.zRngMin:subInd.zRngMax) = probabilities(:,:,:,1);
temp_mask(subInd.yRngMin:subInd.yRngMax,subInd.xRngMin:subInd.xRngMax,...
    subInd.zRngMin:subInd.zRngMax) = mask;

% Clean up few variables
clear sub_image3D sub_xy subInd indexes

% Chop off the buffer regions
temp_probabilities([1:xy_bfr,end-xy_bfr+1:end],:,:) = [];
temp_probabilities(:,[1:xy_bfr,end-xy_bfr+1:end],:) = [];
temp_probabilities(:,:,[1:z_bfr,end-z_bfr+1:end])   = [];

% Chop off the buffer regions
temp_mask([1:xy_bfr,end-xy_bfr+1:end],:,:) = [];
temp_mask(:,[1:xy_bfr,end-xy_bfr+1:end],:) = [];
temp_mask(:,:,[1:z_bfr,end-z_bfr+1:end])   = [];

% Update the results
R_updated.temp_probabilities = temp_probabilities;
R_updated.temp_mask          = temp_mask;

% Close the figure
close(RW.fh)


    