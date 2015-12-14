function [q, nIter, resid] = maxbet_procedure3(data, tt, tol)
%MAXBET_PROCEDURE3 MAXBET procedure for multi-block matrices, using algos.
%
%   Q = maxbet_procedure3(DATA, TT, TOL)
%   Computes the solution of the original maxbet problem, that consists in
%   maximizing: (Q' * XX' * XX * Q), under block-normalized vector 
%   (norm(qk) = 1).
%
%   [Q, ITER] = maxbet_procedure3(DATA, TT, TOL)
%   Also returns the number of iterations.
%
%   Inputs:
%   DATA:   input BlockMatrix instance corresponding to user problem
%   TT:     input initialisation BlockVector, with as many block-rows as
%           the number of columns of the input block-matrix.
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
%     [q, iter] = maxbet_procedure3(data, tt, 1e-3);
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

% compute the block-matrix corresponding to maxbet algorithm
AA = blockProduct_uu(data', data);

% create the algorithm iterator
iterator = MaxBetIterator(AA, qq);

% init residual
resid = 1;

% iterate until residual is acceptable
nIter = 0;
while resid > tol
    % increment iteration
    nIter = nIter + 1;
    
    % performs one iteration, and get residual
    [q, resid] = iterator.iterate();
end
