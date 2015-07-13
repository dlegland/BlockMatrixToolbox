function BM = scalarBlock(mat)
%SCALARBLOCK  Converts a matrix to a BlockMatrix with only scalar blocks
%
%   BM = scalarBlock(MAT)
%
%   Example
%   BM = scalarBlock(magic(3));
%   reveal(BM)
%          1  1  1
%       1  +  +  +
%       1  +  +  +
%       1  +  +  +
%
%   See also
%   BlockMatrix, oneBlock
 
% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2015-05-18,    using Matlab 8.4.0.150421 (R2014b)
% Copyright 2015 INRA - Cepia Software Platform.

n = size(mat, 1);
p = size(mat, 2);
BM = BlockMatrix(mat, ones(1, n), ones(1, p));
