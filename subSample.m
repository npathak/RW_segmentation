function [sub_image3D, sub_xy, subInd] = subSample(xy, image3D, ...
    sliceNum, xy_bfr, z_bfr)
% [SUB_IMAGE3D, SUB_XY, SUBIND] = SUBSAMPLE(XY, IMAGE3D, SLICENUM, ...
% XY_BFR, Z_BFR) generates a sub sample of a 3D image with a region of
% interest specified by input seed points and buffer amounts. A rectangle
% is formed with extreme x and y locations of seed points adding a buffer
% amount of XY_BFR. Z_BFR specifies the number of slices to be considered
% before and after the current slice. 
%
% Inputs:  XY       = seed points
%          IMAGE3D  = 3D image matrix
%          SLICENUM = slice under selection
%          XY_BFR   = x,y direction buffer amounts
%          Z_BFR    = z buffer amount
% Inputs:  SUB_IMAGE3D = sub sampled 3D volume
%          SUB_XY      = scaled seed points to the sub sample image
%          SUBIND      = scaled seed point indices
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

[r, c, f] = size(image3D);
% Pad the 3D image with specified buffers
t_image3D = zeros(r+2*xy_bfr, c+2*xy_bfr, f+2*z_bfr);
t_image3D(xy_bfr+1:end-xy_bfr, xy_bfr+1:end-xy_bfr, z_bfr+1:end-z_bfr)...
    = image3D;

x_min = min(xy(1,:));
x_max = max(xy(1,:));
y_min = min(xy(2,:));
y_max = max(xy(2,:));

% x range calculation
xRngMin = x_min;
xRngMax = x_max+2*xy_bfr;

% y range calculation
yRngMin = y_min;
yRngMax = y_max+2*xy_bfr;

% z range calculation
zRngMin = sliceNum;
zRngMax = sliceNum+2*z_bfr;

sub_image3D = t_image3D(yRngMin:yRngMax, xRngMin:xRngMax, zRngMin:zRngMax);

sub_xy(1,:) = xy(1,:)-xRngMin+xy_bfr+1;
sub_xy(2,:) = xy(2,:)-yRngMin+xy_bfr+1;

subInd.xRngMin = xRngMin;
subInd.xRngMax = xRngMax;
subInd.yRngMin = yRngMin;
subInd.yRngMax = yRngMax;
subInd.zRngMin = zRngMin;
subInd.zRngMax = zRngMax;
