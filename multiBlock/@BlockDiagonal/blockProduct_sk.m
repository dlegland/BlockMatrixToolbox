function X = blockProduct_sk(A, B)
% compute 'sk'-type  for block diagonal matrices.
%
% It corresponds to scalar product along blocks, and kronecker product
% within blocks. 
%
% A must be oneBlock Block-Matrix.
%
% Example
%   B = BlockDiagonal(magic(2), magic(3), magic(4));
%   disp(B);
%   A = oneBlock(reshape(1:4, [2,2]))
%   X = blockProduct_sk(A,B);
%
% References: R. H. Koning, H. Neudecker†, T.  Wansbeek. Linear Algebra and
% its Appl. 149, pp 165–184,(1991) 
%

% ------
% Author: Mohamed Hanafi
% e-mail: mohamed.hanafi@oniris-nantes.fr
% Created: 2015-06-00,  using Matlab(R2015a)
% check conditions on dimensions

if all(blockSize(A) ~= [1,1])
    error('A must be one Block-Matrix');
end

% create X
BlockA = getMatrix(A);
XBlock = cell(1,blockSize(B, 1));
for iBlock = 1:blockSize(B, 1)
    % extract diagonal blocks of the two input block matrices
    BlockB = getBlock(B, iBlock, iBlock);
    
    % compute 'h'-product of blocks
    XBlock{1,iBlock} = kron(BlockA, BlockB);
end

% assign result
X = BlockDiagonal(XBlock);
