function X = blockProduct_hh(A, B)
% compute 'hh'-type for block diagonal matrices.
%
% It corresponds to Hadamard product along the blocks, and Hadamard
% product within the blocks.
%
% block-matrices A and B must have the same block-dimension.
%
% Example:
%   A = BlockDiagonal(rand(3, 3), rand(2,2))
%   B = BlockDiagonal(magic(3), magic(2))
%   X = blockProduct_hh(A,B)
%

% ------
% Author: Mohamed Hanafi
% e-mail: mohamed.hanafi@oniris-nantes.fr
% Created: 2015-06-00,  using Matlab(R2015a)

% check conditions on dimensions
if all(blockDimensions(A) ~= blockDimensions(B));
    error('Block dimensions of block-matrices A and B must be the same');
end

% create X
XBlock = cell(1,blockSize(A, 1));
for iBlock = 1:blockSize(A, 1)
    % extract diagonal blocks of the two input block matrices
    BlockA = getBlock(A, iBlock, iBlock);
    BlockB = getBlock(B, iBlock, iBlock);
    
    % compute 'h'-product of blocks
    XBlock{iBlock} = BlockA .* BlockB;
end

% assign result
X = BlockDiagonal(XBlock);
