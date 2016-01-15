function X = blockProduct_hs(A, B)
% compute 'hs'-type for block diagonal matrices.
%
% It corresponds to hadamard product along blocks, and scalar product
% within blocks. 
%
% Each block from A must be a scalar and the block structure of A and B
% must be same. 
%
% Example:
%   A = BlockDiagonal(rand(1), rand(1));
%   disp(A);
%   B = BlockDiagonal(magic(2), magic(2));
%   X = blockProduct_hs(A,B)
%

% ------
% Author: Mohamed Hanafi
% e-mail: mohamed.hanafi@oniris-nantes.fr
% Created: 2015-06-00,  using Matlab(R2015a)

% check conditions on block dimensions
[nA, pA] = size(getMatrix(A));
kA = blockSize(A,1);
kbarA = blockSize(A,2);
kB = blockSize(B,1);
kbarB = blockSize(B,2);
if or(all([kA kbarA]~=[kB kbarB]),all([kA kbarA]~=[nA pA]))
    error('A must be a scalar Block matrix and the block structure of A and B must be the same');
end

% Compute blocks of X
XBlock = cell(1,blockSize(A, 1));
for iBlock = 1:blockSize(A, 1)
    % extract diagonal blocks of the two input block matrices
    BlockA = getBlock(A, iBlock, iBlock);
    BlockB = getBlock(B, iBlock, iBlock);
    
    % compute 'h'-product of blocks
    XBlock{iBlock} = BlockA * BlockB;
end

% assign result
X = BlockDiagonal(XBlock);
