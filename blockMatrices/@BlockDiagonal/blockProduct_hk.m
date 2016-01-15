function X = blockProduct_hk(A, B)
% compute 'hh'-type for block diagonal matrices.
%
% It corresponds to Hadamard product along blocks, and Kronecker product
% within blocks. 
%
% block-matrices must have the same block-Size.
%
%   Example
%     A = BlockDiagonal(magic(2), magic(2))
%     B = BlockDiagonal(magic(1), magic(2))
%     X = blockProduct_hk(A,A)
%
% References: A. R. Horn,R Mathias.Linear Algebra and its Applications.
% 172, pp.337-346,(1992) 
%
% ------
% Author: Mohamed Hanafi
% e-mail: mohamed.hanafi@oniris-nantes.fr
% Created: 2015-06-00,  using Matlab(R2015a)

% check conditions on dimensions
if all(blockSize(A) ~= blockSize(B));
    error('BlockSize of A and BlockSize of B must be the same');
end

% create X
XBlock = cell(1,blockSize(B, 1));
for iBlock = 1:blockSize(B, 1)
    % extract diagonal blocks of the two input block matrices
    BlockB = getBlock(B, iBlock, iBlock);
    BlockA = getBlock(A, iBlock, iBlock);
    
    % compute 'k'-product of blocks
    XBlock{iBlock} = kron(BlockA, BlockB);
end

% assign result
X = BlockDiagonal(XBlock);
