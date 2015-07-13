function X = blockProduct_kh(A, B)
% compute 'kh'-type product for block matrices.
%
% It corresponds to kronecker product along the blocks, and Hadamard
% product within the blocks. It correponds to multiplying a block matrix A
% by a oneBlock Matrix B.
% Transposition rule: blockProduct_kh(A, B)=(blockProduct_sh(B', A'))'
%
% Block-dimension of A must be uniform with the size of each block equals
% size(B).
%
% Example
%    A = BlockMatrix(reshape(1:36, [9 4]), {[3 3 3], [2 2]});
%    disp(A);
%    B = oneBlock(2*ones(3,2));
%    X = blockProduct_kh(A,B)
%

% ------
% Author: Mohamed Hanafi
% e-mail: mohamed.hanafi@oniris-nantes.fr
% Created: 2015-06-00,  using Matlab(R2015a)

AA = B';
BB = A';

% check conditions on dimensions
kBB = blockSize(BB,1);
kbarBB = blockSize(BB,2);
p1 = IntegerPartition(size(getMatrix(AA),1)*ones(1,kBB));
p2 = IntegerPartition(size(getMatrix(AA),2)*ones(1,kbarBB));
Bdimtest = BlockDimensions({p1, p2});
if all(Bdimtest ~= blockDimensions(BB))
    error('Block-dimension of A must be uniform with the size of each block equals size(B)');
end

X = blockProduct_sh(AA, BB);
X = X';