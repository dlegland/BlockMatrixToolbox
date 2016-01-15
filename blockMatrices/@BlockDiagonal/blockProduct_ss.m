function X = blockProduct_ss(lambda, A)
% compute 'ss'-type for block diagonal matrices.
%
% It corresponds to scalar product along blocks, and scalar product within
% blocks. 
%
% lambda must be both one Block with a scalar Block
%
% Example
%   A = BlockDiagonal(magic(2), magic(3), magic(4));;
%   disp(A);
%   lambda = oneBlock(2);
%   AA = blockProduct_ss(lambda,A)
%

% ------
% Author: Mohamed Hanafi
% e-mail: mohamed.hanafi@oniris-nantes.fr
% Created: 2015-06-00,  using Matlab(R2015a)

% check conditions on dimensions
[nL, pL] = size(getMatrix(lambda));
kL = blockSize(lambda,1);
kbarL = blockSize(lambda,2);

if or(all([nL,pL]~=[1 1]),all([kL,kbarL]~=[1 1]))
    error(' lambda must be a scalar as one block-Matrix');
end

% create X
Blocklambda = getMatrix(lambda);
XBlock = cell(1, blockSize(A, 1));
for iBlock = 1:blockSize(A, 1)
    % extract diagonal blocks of the two input block matrices
    BlockA = getBlock(A, iBlock, iBlock);
    
    % compute 's'-product of blocks
    XBlock{iBlock} = Blocklambda * BlockA;
end

% assign result
X = BlockDiagonal(XBlock);
