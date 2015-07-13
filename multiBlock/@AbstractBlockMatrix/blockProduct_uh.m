function X = blockProduct_uh(A, B)
% compute 'uh'-type product for block matrices.
%
% It corresponds to usual product along blocks and Hadamard product within
% the blocks. 
% The block-rows of A and B are uniform and parts are equal to
% size(A,1)/BlockSize(A,1).
% The block-columns of A and B are uniform and are equal to
% size(A,2)/BlockSize(B,1).
%
% Example:
%   B = BlockMatrix(reshape(1:36, [6 6]), {[2 2 2], [3 3]});;
%   disp(B);
%   A = BlockMatrix(reshape(1:36, [4 9]), {[2 2], [3 3 3]});
%   X = blockProduct_uh(A, B)
%

% ------
% Author: Mohamed Hanafi
% e-mail: mohamed.hanafi@oniris-nantes.fr
% Created: 2015-06-00,  using Matlab(R2015a)

% check conditions on block dimensions
[nA,pA] = size(getMatrix(A));
kA    = blockSize(A,1);
kbarA = blockSize(A,2);
kB    = blockSize(B,1);
kbarB = blockSize(B,2);

pA1 = IntegerPartition(round((nA/kA)*ones(1,kA)));
pA2 = IntegerPartition(round((pA/kB)*ones(1,kbarA)));
pB1 = IntegerPartition(round((nA/kA)*ones(1,kB)));
pB2 = IntegerPartition(round((pA/kB)*ones(1,kbarB)));
BdimA = BlockDimensions({pA1, pA2});
BdimB = BlockDimensions({pB1, pB2});
if or(or(all(BdimA~=blockDimensions(A)),all(BdimB~=blockDimensions(B))), or(round((nA/kA))~=(nA/kA),round((pA/kB))~=(pA/kB)))
    error('the block-rows of A and B are uniform and parts are equal to size(A,1)/BlockSize(A,1) and the block-columns of A and B are uniform and are equal to size(A,2)/BlockSize(B,1)');
end

% create blockdims of X
brows = blockDimensions(A,1);
bcol = blockDimensions(B,2);
X = BlockMatrix.zeros(BlockDimensions({brows, bcol}));

for iBlock = 1:blockSize(A, 1)
    for jBlock = 1:blockSize(B, 2)
        % compute (i,j) blocks
        s = zeros(brows(iBlock),bcol(jBlock));
        for kBlock = 1:blockSize(A, 2)
            % extract blocks of the two input block matrices
            BlockA = getBlock(A, iBlock, kBlock);
            BlockB = getBlock(B, kBlock, jBlock);
            s = s + BlockA.* BlockB;
        end
        % assign result
        setBlock(X, iBlock, jBlock, s);
    end
end
