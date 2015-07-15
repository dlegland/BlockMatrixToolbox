function X = blockProduct_ku(A, B)
% compute 'ku'-type  for block diagonal matrices
%
% It corresponds to kronecker product along blocks, and usual product
% within blocks. 
%
% transposition rule:
%   blockDiagProduct_ku(A, B)=(blockDiagProduct_su(B', A'))'
%
% Example
%   A = BlockDiagonal(rand(1,3), rand(2,3),rand(3,3));
%   B = oneBlock(ones(3,1));
%   X = blockProduct_ku(A,B);
%

% ------
% Author: Mohamed Hanafi
% e-mail: mohamed.hanafi@oniris-nantes.fr
% Created: 2015-06-00,  using Matlab(R2015a)

% check conditions on dimensions
AA = B';
BB = A';
kBB = blockSize(BB,1);

browstest = IntegerPartition(size(getMatrix(AA),2)*ones(1,kBB));
browsBB = IntegerPartition(blockDimensions(BB,1));
if  or(all(blockSize(AA) ~= [1, 1]), all(browstest~=browsBB))
    error('column blocks of A must be uniform with each part equals size(B,1)');
end

X = blockProduct_su(AA, BB);
X = X';
