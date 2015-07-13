function X = blockProduct_us(A, B)
% compute 'us'-type product for block matrices.
%
% It corresponds to usual product along the blocks and scalar product
% within the blocks. 
%
% A must be a scalar block-matrix, the number of column-blocks of A, the
% number of row-blocks of B must be the same, and the row partition of B
% must be uniform.
%
% Example :
%   B = BlockMatrix(reshape(1:36, [9 4]), {[3 3 3], [2 2]});
%   disp(B);
%   A = scalarBlock(ones(2,3));
%   X = blockProduct_us(A, B)
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

% create blockdims of res
bdimX = BlockDimensions({IntegerPartition(round((nB/pA))*ones(1,nA)), blockDimensions(B,2)});
X = BlockMatrix.zeros(bdimX);
brows = blockDimensions(B,1);
bcol = blockDimensions(B,2);

for iBlock = 1:blockSize(A, 1)
    for jBlock = 1:blockSize(B, 2)
        % compute (i,j) blocks
        s = zeros(brows(iBlock), bcol(jBlock));
        for kBlock = 1:blockSize(A, 2)
            % extract blocks of the two input block matrices
            BlockA = getBlock(A, iBlock, kBlock);
            BlockB = getBlock(B, kBlock, jBlock);
            s = s + BlockA * BlockB;
        end
        % assign result
        setBlock(X, iBlock, jBlock, s);
    end    
end
