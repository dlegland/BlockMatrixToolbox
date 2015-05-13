function [q, iter, resid] = maxbet_procedure1(data, tt, tol)
%MAXBET_PROCEDURE1  MAXBET procedure for multi-block matrices.
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
 
% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2015-04-13,    using Matlab 8.4.0.150421 (R2014b)
% Copyright 2015 INRA - Cepia Software Platform.


% total number of blocks
% (assume block matrix is 'row-block' matrix)
maxblo = blockSize(data, 2); 


%% Normalisation of loadings
% The block-vectors representing the loadigs are normalised, and the whole
% matrix is computed.
 
% variable representing the whole matrix
X = [];
% (a priori, pas necessaire de passer par la construction de la matrice
% globale, car deja accessible via la classe BlockMatrix)

% create new BlockMatrix representing the normalized input vectors
vdims = getBlockDimensions(tt);
t = BlockMatrix.zeros(vdims);

% iterate over blocks to concatenate the blocks
for blo = 1:maxblo
    % concatenate the global matrix
    X = cat(2, X, data{1, blo});
    
    % normalization by blocks of the vector
    % (a voir si cela peut devenir un methode "norm" qui fait partie de la
    % classe BlockMatrix).
    v = tt{blo, 1};
    % long syntax:    % v = getBlock(tt, blo, 1);
    
    v = v / norm(v);
    
    t{blo, 1} = v;
    % long syntax:  % setBlock(t, blo, 1, v);
end

%% Computation of X'*X by block rows

% allocate memory for temporary computations
AAdims = BlockDimensions({vdims{1}, sum(vdims{1})});
AA = BlockMatrix.zeros(AAdims);

% iteration sur les blocs
for blo = 1:maxblo
    % On pourrait eviter de creer X en iterant deux fois sur les blocs :
    % * une premiere fois pour considerer le bloc courant
    % * une deuxieme fois pour calculer le produit avec l'ensemble des
    %   autres blocs
    AA{blo, 1} = data{1, blo}' * X;
    % long syntax:
    % setBlock(AA, blo, 1, getBlock(data, 1, blo)' * X);
end


%% Iterations

% creation of the Block-matrix for storing result
q = BlockMatrix.zeros(vdims);

% initialize the condition for breaking loop
resid = 1;

% count the number of iterations
iter = 0;

while resid > tol
    iter = iter + 1;
    
    % re-initialize the vector uu
    uu = BlockMatrix.zeros(vdims);
    for blo = 1:maxblo
        % short syntax (using braces-indexing)
        uu{blo, 1} = t{blo, 1};
        % long syntax (using setBlock/getBlock methods)
        % setBlock(uu, blo, 1, getBlock(t, blo, 1));
    end
    
    s = 0;
    for blo = 1:maxblo
        % local multiplication
        ak = AA{blo, 1} * uu.data;
        % ak = getBlock(AA, blo, 1) * uu.data;
        
        % store the normalized vector
        q{blo, 1} = ak / norm(ak);
        % setBlock(q, blo, 1, ak / norm(ak));
        
        % increment residual
        s = s + norm(q{blo, 1} - t{blo, 1});
        % s = s + norm(getBlock(q, blo, 1) - getBlock(t, blo, 1));
    end
    
    resid = s;
    
    % update block vectors of loadings
    t = q;
end
