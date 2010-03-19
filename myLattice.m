function [points,edges3D] = myLattice(X,Y,Z)
% [POINTS,EDGES3D] = MYLATTICE(X,Y,Z) generates a 3D, 
% "6-connected" Cartesian lattice with dimensions X, Y and Z. 
%
% Inputs:    X/Y/Z - The dimensions of the lattice (i.e., the number of 
%               nodes will equal X*Y*Z)
%
% Outputs:  POINTS  - Nx2 lattice nodes
%           EDGES3D - Mx2 lattice edges
%
%
% 6/5/03 - Leo Grady
% Modified by:
% 03/15/2010 - Nayanjyoti Pathak

% Copyright (C) 2002, 2003 Leo Grady <lgrady@cns.bu.edu>
%   Computer Vision and Computational Neuroscience Lab
%   Department of Cognitive and Neural Systems
%   Boston University
%   Boston, MA  02215
%
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
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
%
% Date - $Id: lattice.m,v 1.2 2003/08/21 17:29:29 lgrady Exp $
%========================================================================%

% Check for single point
if X*Y==1
    points=[1;1];
    edges=[];
    return
end

% Use uit16 to save some memory
rangex=uint16(0:(X-1));
rangey=uint16(0:(Y-1));
rangez=uint16(0:(Z-1));
[x y z]=meshgrid(rangey, rangex, rangez);

% Points
points = [x(:),y(:),z(:)]; % y, x, z order
N=X*Y;

% Find edges 
edges = single([[1:N]',[(1:N)+1]']);
edges = [[edges(:,1);[1:N]'],[edges(:,2);[1:N]'+X]];

excluded = find((edges(:,1)>N)|(edges(:,1)<1)|(edges(:,2)>N)| ...
    (edges(:,2)<1));
edges([excluded;[X:X:((Y-1)*X)]'],:)=[];
M = 1:N;
numPts = size(x,1)*size(x,2);
edges = [edges;M',M'+numPts];
numPlanes = size(x,3);
nextPlane = size(x,1)*size(x,2);
edges3D = edges;
clear x y z M

edges3D = {edges3D};

for index = 2:numPlanes
    edges3D(index) = {[edges+nextPlane*(index-1)]};
    index;
end

var1 = edges3D{index}; 
var1(end-numPts+1:end,:) = []; 
edges3D(index) = {var1}; 
edges3D = edges3D'; 
edges3D = cell2mat(edges3D);


