function X = blockProduct_sh(A, B)
% compute 'sh'-type for block diagonal matrices
%
% It corresponds to scalar product along blocks, and Hadamard
% product within blocks.
%
% It corresponds to multiplying a oneBlock Matrix A by a block Diagonal matrix B
% Block-dimension of B must be uniform with the size of each block equals size(A)
%   
% Example
%   B = BlockDiagonal(magic(3), magic(3),magic(3));
%   A = oneBlock(eye(3));
%   X = blockProduct_sh(A,B)

% ------
% Author: Mohamed Hanafi
% e-mail: mohamed.hanafi@oniris-nantes.fr
% Created: 2015-06-00,  using Matlab(R2015a)

% check conditions on dimensions
kB = blockSize(B,1);
kbarB = blockSize(B,2);
p1 = IntegerPartition(size(getMatrix(A),1) * ones(1,kB));
p2 = IntegerPartition(size(getMatrix(A),2) * ones(1,kbarB));
Bdimtest = BlockDimensions({p1, p2});

if all(Bdimtest ~= blockDimensions(B))
    error('Block-dimension of B must be uniform with the size of each block equals size(A)');
end

% create X
BlockA = getMatrix(A);
% create blockdims of X
XBlock = cell(1,blockSize(B, 1));
for iBlock = 1:blockSize(B, 1)
    % extract diagonal blocks of the two input block matrices
    BlockB = getBlock(B, iBlock, iBlock);
    
    % compute 'h'-product of blocks
    XBlock{iBlock} = BlockA .* BlockB;
end

% assign result
X = BlockDiagonal(XBlock);
