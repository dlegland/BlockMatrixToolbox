function X = blockProduct_us(A, B)
% compute 'us'-type for Block Diagonal matrices.
%
% It corresponds to usual product along blocks, and scalar product within blocks.
%
% A must be a scalar block diagonal matrix, the number of column blocks of
% A and the number of row blocks of B must be the same, the row partition
% of B must be uniform.
%
% Example
%   B = BlockDiagonal(magic(2), rand(2,3));
%   A = BlockDiagonal(1, 1);
%   X = blockProduct_us(A,B)
%

% ------
% Author: Mohamed Hanafi
% e-mail: mohamed.hanafi@oniris-nantes.fr
% Created: 2015-06-00,  using Matlab(R2015a)

% check conditions on block dimensions
[nA, pA] = size(getMatrix(A));
nB = size(getMatrix(B),1);
kA = blockSize(A,1);
kbarA = blockSize(A,2);
if or(round((nB/pA))~=(nB/pA),or(all([kA kbarA]~=size(getMatrix(A))), all(IntegerPartition(round((nB/pA)*ones(1,pA)))~=blockDimensions(B,1))))
    error('Each block from A must be a scalar and the block structure of A and B must be same and the rows of the blocks from B must be of the same size');
end

% create blockdims of X
XBlock = cell(1,blockSize(A, 1));
for iBlock = 1:blockSize(A, 1)
    % extract diagonal blocks of the two input block matrices
    BlockA = getBlock(A, iBlock, iBlock);
    BlockB = getBlock(B, iBlock, iBlock);
    % compute 's'-product of blocks
    XBlock{iBlock} = BlockA * BlockB;
end

% assign result
X = BlockDiagonal(XBlock);
