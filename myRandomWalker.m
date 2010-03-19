function [mask,probabilities] = myRandomWalker(image3D,seeds,labels,beta)
% [MASK,PROBABILITIES] = RANDOM_WALKER(IMAGE3D,SEEDS,LABELS,BETA) uses the 
% random walker segmentation algorithm to produce a segmentation given a 3D 
% image, input seeds and seed labels.
% 
% Inputs: IMAGE3D - The 3D image to be segmented
%         SEEDS   - The input seed locations (given as image indices, i.e., 
%            as produced by sub2ind)
%         LABELS  - Integer object labels for each seed.  The labels 
%            vector should be the same size as the seeds vector.
%         BETA    - Optional weighting parameter (Default beta = 90)
% 
% Output: MASK    - A labeling of each pixel with values 1-K,indicating the
%            object membership of each pixel
%         PROBABILITIES - Pixel (i,j) belongs to label 'k' with probability
%            equal to probabilities(i,j,k)
% 
% 
% 10/31/05 - Leo Grady
% Modified by:
% 03/15/2010 - Nayanjyoti Pathak
%
% Based on the paper:
% Leo Grady, "Random Walks for Image Segmentation", IEEE Trans. on Pattern 
% Analysis and Machine Intelligence, Vol. 28, No. 11, pp. 1768-1783, 
% Nov., 2006.
% 
% Available at: http://www.cns.bu.edu/~lgrady/grady2006random.pdf
% 
% Note: Requires installation of the Graph Analysis Toolbox available at:
% http://eslab.bu.edu/software/graphanalysis/

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

% Read inputs
if nargin < 4
    beta = 90;
end

% Find image size
[X Y Z] = size(image3D);

% Error catches
exitFlag = 0;

% Check for NaN/Inf image values
if(sum(isnan(image3D(:))) || sum(isinf(image3D(:)))) 
    disp('ERROR: Image contains NaN or Inf values - Do not know how to handle.')
    exitFlag=1;
end

% Check seed locations argument
if(sum(seeds<1) || sum(seeds>size(image3D,1)*size(image3D,2)*size(image3D,3)) || (sum(isnan(seeds)))) 
    disp('ERROR: All seed locations must be within image.')
    disp('The location is the index of the seed, as if the image is a matrix.')
    disp('i.e., 1 <= seeds <= size(image3D,1)*size(image3D,2)')
    exitFlag=1;
end

% Check for duplicate seeds
if(sum(diff(sort(seeds))==0))
    disp('ERROR: Duplicate seeds detected.')
    disp('Include only one entry per seed in the "seeds" and "labels" inputs.')
    exitFlag=1;
end

% Check seed labels argument
TolInt=0.01*sqrt(eps);
if(length(labels) - sum(abs(labels-round(labels)) < TolInt)) 
    disp('ERROR: Labels must be integer valued.');
    exitFlag=1;
end

% Check beta argument
if(length(beta)~=1) 
    disp('ERROR: The "beta" argument should contain only one value.');
    exitFlag=1;
end

if(exitFlag)
    disp('Exiting...')
    [mask,probabilities] = deal([]);
    return
end

% Build graph
[points, edges3D] = myLattice(X,Y,Z);
imgVals=image3D(:);

weights = myMakeweights(edges3D,imgVals,beta);
L = laplacian(edges3D,weights);

% Determine which label values have been used
label_adjust          = min(labels); 
labels                = labels-label_adjust+1; % Adjust labels to be > 0
labels_record(labels) = 1;
labels_present        = find(labels_record);
number_labels         = length(labels_present);

% Set up Dirichlet problem
boundary = zeros(length(seeds),number_labels);
for k = 1:number_labels
    boundary(:,k) = (labels(:)==labels_present(k));
end

% Solve for random walker probabilities by solving combinatorial Dirichlet
% problem
probabilities = myDirichletboundary(L,seeds(:),boundary);

% Generate mask
[dummy mask]  = max(probabilities,[],2);
mask          = labels_present(mask)+label_adjust-1; % Assign original labels to mask
mask          = reshape(mask,[X Y Z]);
probabilities = reshape(probabilities,[X Y Z number_labels]);

