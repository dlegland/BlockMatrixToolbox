function BM = oneBlock(mat)
%ONEBLOCK Converts a matrix to a 1-1 BlockMatrix
%
%   DEPRECATED: use BlockMatrix.oneBlock instead
%
%   Example
%   BM = oneBlock(magic(3));
%   reveal(BM)
%       3
%    3  +
%
%   See also
%   BlockMatrix, scalarBlock
 
% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2015-05-18,    using Matlab 8.4.0.150421 (R2014b)
% Copyright 2015 INRA - Cepia Software Platform.

n = size(mat, 1);
p = size(mat, 2);
BM = BlockMatrix(mat, n, p);
