function [q, iter, resid] = maxbet_procedure2(data, tt, tol)
%MAXBET_PROCEDURE2  MAXBET procedure for multi-block matrices.
%
%   Q = maxbet_procedure1(DATA, TT, TOL)
%   Computes the solution of the original maxbet problem, that consists in
%   maximizing: (Q' * XX' * XX * Q), under block-normalized vector 
%   (norm(qk) = 1).
%
%   [Q, ITER] = maxbet_procedure1(DATA, TT, TOL)
%   Also returns the number of iterations.
%
%   Inputs:
%   DATA:   multiblocks input matrix as horizontal list of blocks
%   TT:     block vector as horizontal list of block vectors (not
%           necessarily normalized by blocks)
%   TOL:    convergence tolerance
%
%   Outputs:
%   Q:      solution, as a list of horizontal block vectors
%   ITER:   the number of iterations needed to reach convergence
%
%
%   Example
%     % Create Block-matrix for the data
%     data = BlockMatrix(rand(4, 7), 4, [2 3 2]);
%     % Create Block-matrix for initialisation vector
%     tt = BlockMatrix(rand(7, 1), [2 3 2], 1);
%     % call the MAXBET procedure
%     [q, iter] = maxbet_procedure1(data, tt, 1e-3);
%     disp(sprintf('converged afeter %d iterations', iter));
%
%
%   See also
%     BlockMatrix
%
%   References
%   Van De Geer (1984), Ten Berge (1988), Hanafi and Kiers (2006)
%

% create new BlockMatrix representing the normalized input vectors
qq = blockProduct_hs(1./blockNorm(tt), tt);

AA = blockProduct_uu(data',data);

resid = 1;

iter = 0;

while resid > tol
    
    iter = iter + 1;
    
    q = blockProduct_uu(AA,qq);
    
    q = blockProduct_hs(1./blockNorm(q), q); % block normalization
    
    resid = norm(blockNorm(q) - blockNorm(qq)); % residual
    
    qq = q;
end


 