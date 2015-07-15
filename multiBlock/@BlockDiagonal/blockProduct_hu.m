function X = blockProduct_hu(A, B)
% compute 'hu'-type for block diagonal matrices.
%
% It corresponds to hadamard product along blocks, and usual product within
% blocks. 
%
% block columns of A must be the same than block rows of B
%
% Example
%   A = BlockDiagonal(rand(3,2), rand(2,2));
%   B = BlockDiagonal(rand(2,2), rand(2,1));
%   X = blockProduct_hu(A,B)
%
% References : R.A. Horn, R. Mathias, Y. Nakamura. Linear and Multilinear
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

if or(all(brows ~= bcol), all([kA kbarA] ~= [kB kbarB]))
    error('Block columns of A and Block rows of A must be the same');
    
end
% create  X
XBlock = cell(1,blockSize(A, 1));
for iBlock = 1:blockSize(A, 1)
    % extract diagonal blocks of the two input block matrices
    BlockA = getBlock(A, iBlock, iBlock);
    BlockB = getBlock(B, iBlock, iBlock);
    
    % compute 'u'-product of blocks
    XBlock{iBlock} = BlockA * BlockB;
end

% assign result
X = BlockDiagonal(XBlock);
