function X = blockProduct_su(A, B)
% compute 'su'-type for block diagonal matrices.
%
% It corresponds to scalar product along blocks, and usual product within
% blocks. 
%
% It corresponds to multiplying a oneBlock Block-Matrix A by a block
% diagonal matrix B  rowblocks of B must be uniform with each parts equals
% columns of A.
%
% Example
%   B = BlockDiagonal(magic(3), rand(3,4));;
%   A = oneBlock(ones(2,3));
%   X = blockProduct_su(A,B);
%
% References: M. Günther, L. Klotz. Linear Algebra and its Applications.
% 437, pp. 948-956,(2012) 


% ------
% Author: Mohamed Hanafi
% e-mail: mohamed.hanafi@oniris-nantes.fr
% Created: 2015-06-00,  using Matlab(R2015a)

% check conditions on dimensions
kB = blockSize(B,1);
browstest = IntegerPartition(size(getMatrix(A),2)*ones(1,kB));
browsB =IntegerPartition(blockDimensions(B,1));
if  or(all(blockSize(A)~=[1, 1]), all(browstest~=browsB));
    error('row blocks of B must be uniform with each part equals size(A,2)');
end

% create X
BlockA = getMatrix(A);
XBlock = cell(1,blockSize(B, 1));
for iBlock = 1:blockSize(B, 1)
    % extract diagonal blocks of the two input block matrices
    BlockB = getBlock(B, iBlock, iBlock);
    
    % compute 's'-product of blocks
    XBlock{iBlock} = BlockA * BlockB;
end

% assign result
X = BlockDiagonal(XBlock);
