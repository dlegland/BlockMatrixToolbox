function X = blockProduct_uu(A, B)
% compute 'uu'-type product for Block diagonal Matrices
%
% It corresponds to usual product along the blocks and usual product within
% the blocks. 
%
% The block-rows of B and the block-columns of A must be equal.
%
% Example:
%   A = BlockDiagonal(rand(2,3), rand(2,2),rand(2,1));
%   B = BlockDiagonal(rand(3,2), rand(2,3),rand(1,2));
%   X = blockProduct_uu(A,B)
%

% Author: Mohamed Hanafi
% e-mail: mohamed.hanafi@oniris-nantes.fr
% Created: 2015-06-00,  using Matlab(R2015a)

% check conditions on dimensions
if blockDimensions(A, 2) ~= blockDimensions(B, 1);
    error(' block rows of B and block columns of A matrices must be equal');
end

% create X
XBlock = cell(1,blockSize(A, 2));
for iBlock = 1:blockSize(A, 2)
    % extract diagonal blocks of the two input block matrices
    BlockA = getBlock(A, iBlock, iBlock);
    BlockB = getBlock(B, iBlock, iBlock);
    
    % compute 'u'-product of blocks
    XBlock{iBlock} = BlockA * BlockB;
end

% assign result
X = BlockDiagonal(XBlock);
