function X = blockProduct_kh(A, B)
% compute 'kh'-type for block diagonal matrices
%
% It corresponds to kronecker product along blocks, and Hadamard product
% within blocks. 
% It corresponds to multiplying a block matrix A by a oneBlock Matrix B.
%
% Block-dimension of A must be uniform with the size of each block equals
% size(B).
%
% Transposition rule:
%   blockDiagProduct_kh(A, B)=(blockDiagProduct_sh(B', A'))'
%
%   Example :
%     A = BlockDiagonal(magic(3), 2*magic(3),3*magic(3))
%     B = oneBlock(eye(3))
%     X = blockProduct_ks(A,B)
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