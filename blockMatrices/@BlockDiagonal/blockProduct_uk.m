function X = blockProduct_uk(A, B)
% compute 'uk'-type for block diagonal matrices.
%
% It corresponds to usual product along blocks, and Kronecker product
% within blocks. 
%
% Block-rows of B and block-columns of A must be uniform.
%
% Example
%   A = BlockDiagonal(magic(2), magic(2))
%   X = blockProduct_uk(A, A')
%
% References : 	W. De Launey J. Seberrya Journal of Combinatorial Theory,
% Series A. 66 (2), pp. 192–213 (1994),

% ------
% Author: Mohamed Hanafi
% e-mail: mohamed.hanafi@oniris-nantes.fr
% Created: 2015-06-00,  using Matlab(R2015a)

% check conditions on block dimensions
% pA = size(getMatrix(A),2);
% nB = size(getMatrix(B),1);
% kB = blockSize(B,1);
% kbarA = blockSize(A,2);
% kbarB = blockSize(B,2);

% s1 = or(round((nB/kB))~=(nB/kB),round((pA/kB)~=(pA/kB)));
% p1 = IntegerPartition(round((nB/kB))*ones(1,kB));
% p2 = IntegerPartition(round((pA/kB))*ones(1,kbarA));
% s2 = or(p1~=blockDimensions(B,1),p1~=blockDimensions(A,2));
if not(and(isUniform(blockDimensions(A,2)),isUniform(blockDimensions(B,1))))
    error(' block rows of B and block columns of A must be uniform');
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
