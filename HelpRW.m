function txt = HelpRW
% This file contains the help text for the RW_tool.m GUI.
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

txt = {' Help and step by step guide on random walker based segmentation tool'
' This documentation explains the random walker based segmentation'
' graphical user interface (GUI) and overall procedure for the segmentation'
''
''
' Data pre-processing before calling the RW_tool'
' The MRI images are available either in DICOM or NIFTI formats. Before'
' feeding into the RW_tool we read image data as 3D MATLAB variables'
''
' Loading a Nifti File into MATLAB '
' You can use anything that will bring the image into the MATLAB workspace'
' as a 3D variable. For example, we used the function load_nii.m from'
' Tools for NIfTI and ANALYZE image by Jimmy Shen, which can be downloaded' 
' from http://www.mathworks.com/matlabcentral/fileexchange/...'
' 8797-tools-for-nifti-and-analyze-image'
''
' Example:'
''
' >> image3D = load_nii("Flair.nii", 1, [], [], [], [], [], "Q");'
''
' Alternatively, you can use the built-in mri MATLAB sample dataset:'
''
' >> load mri'
' % Convert the 4D dataset (D) to 3D:'
' >> image3D(:,:,:) = D(:,:,1,:)'
''
''
' Launching the RW_tool'
' The RW_tool requires one input, the image data to be analyzed. To launch '
' the RW_tool type RW_tool(image3D) in MATLAB command prompt. This will '
' bring up the RW Segmentation tool GUI.'
''
' >> RW_tool(image3D)'
''
' Understanding the RW Segmentation tool GUI parts'
' Axes'
' The RW Segmentation tool GUI shows two image windows. The left one shows'
' the input image with a particular slice displayed and the right one'
' shows the segmentation results as a probability map for the same slice.'
''
''
' Toggle buttons'
' Visualize image -- allows visualization of images'
' Undo            -- restores the segmentation results to previous state'
'                    (only one step backward is supported)'
' Select Slice    -- Selects the current slice and calls the random walker'
'                    algorithm.'
' Done?           -- Allows the user to declare that s/he is done'
'                    segmenting and provides an option to save the results.'
''
''
' Slider bar'
' The slider bar allows navigation between different slices of both input'
' image and the results. It displays the first and last slice numbers of'
' the 3D image as well as the current slice number. Pressing on arrow marks'
' changes the current position by one unit and pressing on the slider body'
' changes the current position by ten units.'
''
''
' Buffer'
' xy-buffer       -- This allows selection of number of voxels in x and y' 
'                    directions as buffer'
' z-buffer        -- This allows selection of equal number of slices before'
'                    and after the current slice'
''
''
' Calling the random walker algorithm'
'  The Select Slice button calls the randow walker algorithm and displays'
'  the current slice on a separate figure window. It asks to select'
'  FOREGROUND and BACKGROUND seed points as input to the algorithm. First it'
'  asks for the FOREGROUND seeds and then for the background seeds.' 
''
' What do the 3 mouse buttons do?'
'  Left   -- picks points.'
'  Right  -- picks the last point indicating the end of selection.'
'  Middle -- undo last picked point'
''
''
' How to put seed points'
' The extreme left and right seed points correspond to the minimum and'
' maximum x respectively. Similarly, the top and bottom-most seed points'
' indicate the minimum and maximum y respectively. xy-buffer is added to'
' all four directions to create a bounding box. With this bounding box and'
' z-buffer a sub 3D volume is seleted for the analysis. It is therefore'
' important trying to select only the region of interest and not too much'
' of background to reduce unnecessary computational burden. (Remember our'
' segmentation goal is to extract out the region of interest, i.e. the'
' FOREGROUND).'};

