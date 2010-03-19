function weights = myMakeweights(edges3D,imgVals,beta,points,geomScale,EPSILON)
% WEIGHTS = MYMAKEWEIGHTS(EDGES3D,IMGVALS,BETA,POINTS,GEOMSCALE,EPSILON)
% computes weights for a point and edge list based upon element values and 
% Euclidean distance.  The user controls the parameters beta and 
% geomScale that bias the weights toward distance or pixel values, 
% respectively. 
%
% Inputs:   EDGES3D   - An Mx2 list of M edges indexing into points
%           IMGVALS   - An NxK list of nodal values 
%           BETA      - The scale parameter for imgVals (e.g., 20)
%           POINTS    - Optional NxP list of N vertex locations in P 
%               dimensions           
%           GEOMSCALE - Optional scale parameter for points (required if
%               points are specified)
%           EPSILON   - Optional value of the minimum allowable weight, used
%               to ensure numerical stability.  Default: EPSILON = 1e-5.
%
% Outputs:  WEIGHTS   - An Mx1 vector indexed by edge containing the weights 
%           corresponding to that edge
%
% Note1: The L2 norm is used to compute intensity difference of 
% color vectors.  Therefore, the colors vectors should be pre-converted to 
% best color space (e.g., LUV) for the problem.
%
%
% 6/23/03 - Leo Grady
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
% Date - $Id: makeweights.m,v 1.5 2003/08/21 17:29:29 lgrady Exp $
%========================================================================%

%Constants
if nargin < 6
    EPSILON = 1e-5;
end

%Compute intensity differences
if beta > 0
    valDistances = sqrt(sum((imgVals(edges3D(:,1),:)- ...
        imgVals(edges3D(:,2),:)).^2,2));
    valDistances=normalize(valDistances); %Normalize to [0,1]
else
    valDistances=zeros(size(edges3D,1),1);
    beta=0;
end

%Compute geomDistances, if desired
if (nargin > 3) & (geomScale ~= 0)
    geomDistances=sqrt(abs(sum((points(edges3D(:,1),:)- ...
        points(edges3D(:,2),:)).^2,2)));
    geomDistances=normalize(geomDistances); %Normalize to [0,1]
else
    geomDistances=zeros(size(edges3D,1),1);
    geomScale=0;
end

%Compute Gaussian weights
weights=exp(-(geomScale*geomDistances + beta*valDistances))+...
     EPSILON;
