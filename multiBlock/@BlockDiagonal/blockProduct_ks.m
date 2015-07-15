function X = blockProduct_ks(A, B)
% compute 'ks'-type product for block diagonal matrices.
%
% It corresponds to kronecker product along the blocks and scalar product
% within the blocks. 
%
% A must be a Blockscalar-Matrix and B must be oneBlock-Matrix
%
% Example
%   A = BlockDiagonal(1, 2,3)
%   B = oneBlock(magic(3))
%   X = blockProduct_ks(A,B)
%

% ------
% Author: Mohamed Hanafi
% e-mail: mohamed.hanafi@oniris-nantes.fr
% Created: 2015-06-00,  using Matlab(R2015a)

% check conditions on dimensions
[nA, pA] = size(getMatrix(A));
kA = blockSize(A,1);
kbarA = blockSize(A,2);
kB = blockSize(B,1);
kbarB = blockSize(B,2);
if or(all([nA,pA] ~= [kA,kbarA]), all([kB,kbarB] ~= [1,1]))
    error(' Blocks of A must be a scalars and B must be one block-matrix');
end

% Compute blocks of X
XBlock = cell(1,blockSize(A, 1));
BlockB = getMatrix(B);
for iBlock = 1:blockSize(A, 1)
    % extract diagonal blocks of the two input block matrices
    BlockA = getBlock(A, iBlock, iBlock);
    
    % compute 'h'-product of blocks
    XBlock{iBlock} = BlockA * BlockB;
end

% assign result
X = BlockDiagonal(XBlock);
