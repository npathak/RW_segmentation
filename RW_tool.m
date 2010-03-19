function [] = RW_tool(image3D)
% [] = RW_TOOL(IMAGE3D) calls random walker algorighm on input 3D image
% 
% Requires graphAnalysisToolbox-1.0. by Leo Grady
% download link: http://eslab.bu.edu/software/graphanalysis/graphanalysis.html
%
% Example:
% load mri
% % Convert the 4D dataset (D) to 3D:
% image3D(:,:,:) = D(:,:,1,:);
% RW_tool(image3D)
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

addpath ('vendor/graphAnalysisToolbox-1.0/')
addpath ('vendor/NIFTI_Shen/')

% Initialize or load previous results
R      = get3DimageHandle(image3D);
R_undo = get3DimageHandle(image3D);

% Set up the Randow Walker graphical user interface  for analysis of white
% matter segmentation.
S = setUpGUI(image3D);

% Set the callbacks
set(S.sl,'callback',{@sl_call,{image3D, S, R}})
set(S.tg(:),{'callback'},{{@tg_call,{image3D, S, R, R_undo}}})

%-----------------------------------------
function [] = tg_call(varargin)
% Callback for togglebuttons.

[h,data] = varargin{[1,3]};  % Get calling handle and data.
[image3D, S, R, R_undo] = data{[1, 2, 3, 4]};
slider_value = int16(get(S.sl,'value'));
 
if get(h,'val')==0
    set(h,'val',1)
end

L = get(S.ax,'children');  % The image object.

% Switch for appropriate toggle button action. 
switch h
    case S.tg(1) % Visualize Image
        set(S.tg([2,3,4,5,6]),'val',0)
        set([S.ax(:);L{1};L{2};S.sl;S.tx1(:);S.ed2(:);S.tx2(:);S.ph(2)],{'visible'},{'on'})
        set(S.tx,{'visible'},{'off'})
    case S.tg(2) % Undo
        set(S.tg([1,3,4,5,6]),{'val'},{0})
        set([S.ax(:);L{1};L{2};S.sl;S.tx1(:);S.ed2(:);S.tx2(:);S.ph(2)],{'visible'},{'on'})
        set(S.tx,{'visible'},{'off'})
        R.temp_mask          = R_undo.temp_mask;
        R.temp_probabilities = R_undo.temp_probabilities;
        set(S.fh,'CurrentAxes',S.ax(2))
        imagesc(R.temp_probabilities(:,:,slider_value));colormap(gray);axis off
    case S.tg(4) % Select Slice
        set(S.tg([1,2,3,5,6]),{'val'},{0})
        set([S.ax(:);L{1};L{2};S.sl;S.tx1(:);S.ed2(:);S.tx2(:);S.ph(2)],{'visible'},{'on'})
        set(S.tx,{'visible'},{'off'})
        
        % Select slice for segmentation and call RW algorithm
        R_undo.temp_mask          = R.temp_mask;
        R_undo.temp_probabilities = R.temp_probabilities;
        R_updated = launchRandomWalker_RWtool(image3D,S,R);
        R.temp_probabilities = R_updated.temp_probabilities;
        R.temp_mask          = R_updated.temp_mask;
        set(S.fh,'CurrentAxes',S.ax(2))
        imagesc(R.temp_probabilities(:,:,slider_value));colormap(gray);axis off
    case S.tg(5) % Done?
        set(S.tg([1,2,3,4,6]),{'val'},{0})
        set([S.ax(:);L{1};L{2};S.sl;S.tx1(:);S.ed2(:);S.tx2(:);S.ph(2)],{'visible'},{'on'})
        set(S.tx,{'visible'},{'off'})
        set(S.tg(5),{'string'}, {'Done!'})

        % Save the final result in user specified file (name)
        prompt = {'Save As'};
        dlg_title = 'Save Final Probability Map';
        num_lines = 1;
        def = {'probMap001'};
        answer = cell2mat(inputdlg(prompt,dlg_title,num_lines,def));
        save([answer '.mat'],'R')
    case S.tg(6) % Load Results
        set(S.tg([1,2,3,4,5]),{'val'},{0})
        set([S.ax(:);L{1};L{2};S.sl;S.tx1(:);S.ed2(:);S.tx2(:);S.ph(2)],{'visible'},{'on'})
        set(S.tx,{'visible'},{'off'})
        
        % Load previously saved result for visualization and modification
        [FileName,PathName] = uigetfile('*.mat','Select the file');
        result = load(strcat(PathName, FileName));
        R.temp_probabilities = result.R.temp_probabilities; 
        R.temp_mask = result.R.temp_mask;
        set(S.fh,'CurrentAxes',S.ax(2))
        imagesc(R.temp_probabilities(:,:,slider_value));colormap(gray);axis off
    otherwise % ABOUT
        set(S.tg([1,2,4,5,6]),{'val'},{0})
        set([S.sl;S.ax(:);S.tx1(:);S.ed2(:);L{1};L{2};S.tx2(:);S.ph(2)],{'visible'},{'off'})
        set(S.tx,'visible','on')       
end

%-----------------------------------------
function [] = sl_call(varargin)
% Callback for the edit box and slider.
[h,data]        = varargin{[1,3]};
[image3D, S, R] = data{[1, 2, 3]};
SL              = get(S.sl,{'min','value','max'});  % Get the slider's info.
E               = str2double(get(h,'string'));  % Numerical edit string.

% Update image display with the slider location
slider_value = int16(get(S.sl,'value'));
set(S.fh,'CurrentAxes',S.ax(1))
% Display input image
imagesc(image3D(:,:,slider_value));colormap(gray);axis off;

% Display results as probability map
set(S.fh,'CurrentAxes',S.ax(2))
imagesc(R.temp_probabilities(:,:,slider_value));colormap(gray);axis off

% Slider switch
switch h
    case S.tx1(1)
        if E <= SL{2}
            set(S.sl,'min',E)
        elseif E < SL{3}
            set(S.sl,'val',E,'min',E)
            set(S.tx1(2),'string',E)
        else
            set(h,'string',SL{1})
        end
    case S.tx1(2)
        if E >= SL{1} && E <= SL{3}
            set(S.sl,'value',E) 
        else
            set(h,'string',SL{2})
        end
    case S.tx1(3)
        if E >= SL{2}
            set(S.sl,'max',E)
        elseif E > SL{1}
            set(S.sl,'val',E,'max',E) 
            set(S.tx1(2),'string',E) 
        else
            set(h,'string',SL{3})
        end      
    case S.sl
        set(S.tx1(2),'string',SL{2}) 
    otherwise
        % Do nothing
end



