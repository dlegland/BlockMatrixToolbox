function q = maxbet_procedure1(data, tt, tol)
%MAXBET_PROCEDURE1  MAXBET procedure for multi-block matrices.
%
%   Q = maxbet_procedure1(DATA, TT, TOL)
%   Computes the solution of the original maxbet problem, that consists in
%   maximizing: (Q' * XX' * XX * Q), under block-normalized vector 
%   (norm(qk) = 1).
%
%   Inputs:
%   DATA:   multiblocks input matrix as horizontal list of blocks
%   TT:     block vector as horizontal list of block vectors (not
%           necessarily normalized by blocks)
%   TOL:    convergence tolerance
%
%   Outputs:
%   Q:      solution, as a list of horizontal block vectors
%
%   Example
%   maxbet_procedure1
%
%   See also
%
%   References
%   Van De Geer (1984), Ten Berge (1988), Hanafi and Kiers (2006)
%
 
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2015-04-13,    using Matlab 8.4.0.150421 (R2014b)
% Copyright 2015 INRA - Cepia Software Platform.


% total number of blocks
% % maxblo = length(data);
maxblo = getBlockNumber(data); % assume block matrix is 'row-block' matrix


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
% t = cell(A, maxblo);

% iterate over blocks to concatenate the blocks
for blo = 1:maxblo
    % concatenate the global matrix
    X = cat(2, X, getBlock(data, 1, blo));
%     X = cat(2, X, data{blo});
    
    % normalisation du vecteur par bloc.
    % (a voir si cela peut devenir un methode "norm" qui fait partie de la
    % classe BlockMatrix).
    v = getBlock(tt, blo, 1);
    v = v / norm(v);
    setBlock(t, blo, 1, v);
%     t{blo} = tt{blo} / norm(tt{blo});
end

%% Computation of X'*X by block rows

% allocation memoire pour le resultat
AAdims = BlockDimensions({vdims.parts{1}, sum(vdims.parts{1})});
AA = BlockMatrix.zeros(AAdims);
%AA = cell(1, maxblo);

% iteration sur les blocs
for blo = 1:maxblo
    % On pourrait eviter de creer X en iterant deux fois sur les blocs :
    % * une premiere fois pour considerer le bloc courant
    % * une deuxieme fois pour calculer le produit avec l'ensemble des
    %   autres blocs
    setBlock(AA, blo, 1, getBlock(data, 1, blo)' * X);
    %AA{blo} = data{blo}' * X;
end


%% Iterations

% creation de la Block-Matrix pour le vecteur resultat
q = BlockMatrix.zeros(vdims);
% q = cell(1, maxblo);

% initialise la condition de sortie
residu = 1;

% on compte les iterations
iter = 0;

while residu > tol
    iter = iter + 1;
    
    % re-initialise le vecteur uu
    uu = BlockMatrix.zeros(vdims);
    for blo = 1:maxblo
        setBlock(uu, blo, 1, getBlock(t, blo, 1));
        % uu{1, blo} = t{1, blo};
    end
%     % concatene les objets
%     uu = [];
%     for blo = 1:maxblo
%         uu = cat(1, uu, t{blo});
%     end
    
    s = 0;
    for blo = 1:maxblo
        % multiplication locale
        ak = getBlock(AA, blo, 1) * uu.data;
        % ak = AA{blo} * uu;
        
        % sotcke le vecteur normalise
        setBlock(q, blo, 1, ak / norm(ak));
        % q{blo} = ak / norm(ak);
        
        % incremente le residu
        s = s + norm(getBlock(q, blo, 1) - getBlock(t, blo, 1));
        % s = s + norm(q{blo} - t{blo});
    end
    
    residu = s;
    
    % update block vectors of loadings
    t = q;
end

