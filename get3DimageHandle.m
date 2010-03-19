classdef get3DimageHandle<handle
    % GET3DIMAGEHANDLE initializes results for the random walker algorithm
    % and passes a handle to the results variables
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

    properties (GetAccess='public', SetAccess='public') 
        temp_probabilities
        temp_mask
    end
    
    methods
        function obj = get3DimageHandle(image3D)
            obj.temp_probabilities = zeros(size(image3D));
            obj.temp_mask          = zeros(size(image3D)); 
        end
    end   
end

