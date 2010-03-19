function x = conjgrad(A,b,tol)
% X = CONJGRAD(A,B) solves the linear system of equations A*x=b. 
% X = CONJGRAD(A,B,TOL) solves with specified tolerance TOL. default is
% 1e-10.
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

    if nargin<3
        tol=1e-10;
    end
    r = b + A*b;
    y = -r;
    z = A*y;
    s = y'*z;
    t = (r'*y)/s;
    x = -b + t*y;
  
    for k = 1:numel(b);
       r  = r - t*z;
       if( norm(r) < tol )
            return;
       end
       B = (r'*z)/s;
       y = -r + B*y;
       z = A*y;
       s = y'*z;
       t = (r'*y)/s;
       x = x + t*y;
    end
 end
