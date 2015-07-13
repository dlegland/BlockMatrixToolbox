function X = blockProduct_hu(A, B)
% compute 'hu'-type product for block matrices.

% It corresponds to hadamard product along the blocks and usual product
% within the blocks. 
%
% block-columns of A and than block-rows of B must be the same.
%
% Example:
%    A = BlockMatrix(reshape(1:20, [5 4]), {[3 2], [2 2]});
%    disp(B);
%    B = BlockMatrix(reshape(1:12, [4 3]), {[2 2], [2 1]});
%    X = blockProduct_hu(A,B)
%
% Reference : R.A. Horn, R. Mathias, Y. Nakamura. Linear and Multilinear
% Algebra. 30, pp. 303–314,(1991) 

% ------
% Author: Mohamed Hanafi
% e-mail: mohamed.hanafi@oniris-nantes.fr
% Created: 2015-06-00,  using Matlab(R2015a)

% check conditions on block dimensions
kA = blockSize(A,1);
kbarA = blockSize(A,2);
kB = blockSize(B,1);
kbarB = blockSize(B,2);
bcol = blockDimensions(A,2);
brows = blockDimensions(B,1);

if or(all(brows ~=  bcol),all([kA kbarA]~=[kB kbarB]))
    error('Block columns of A and Block rows of A must be the same');
end

% create blockdims of X
X = BlockMatrix.zeros(BlockDimensions({blockDimensions(A,1), blockDimensions(B,2)}));

for iBlock = 1:blockSize(A, 1)
    for jBlock = 1:blockSize(A, 2)
        % extract blocks of the two input block matrices
        BlockA = getBlock(A, iBlock, jBlock);
        BlockB = getBlock(B, iBlock, jBlock);
        % compute 'u'-product of blocks
        XBlock = BlockA * BlockB;
        % assign result
        setBlock(X, iBlock, jBlock,XBlock);
    end
end
