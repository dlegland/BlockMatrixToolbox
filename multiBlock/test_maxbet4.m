%TEST_MAXBET4 Check the class "MaxBetAlgorithm"
%
%   Usage: test_maxbet4
%
%   Example
%   test_maxbet4
%
%   See also
%   test_maxbet1, test_maxbet2, test_maxbet3
 
%% Cree une bloc-matrice pour les donnees
% On part sur une bloc-matrice de 3 blocs concatenes en ligne, 
% avec des tailles de bloc de 2, 3 et 2 colonnes, 
% et 4 lignes pour chaque bloc.
% La matrice equivalente a une taille de 4-par-7.

% create block dimensions
mdims = BlockDimensions({4, [2 3 2]});

% create block matrix instance
data = BlockMatrix(rand(4, 7), mdims);

% display the BlockMatrix
disp('Block matrix:');
disp(data);


%% Cree une bloc-matrice pour les vecteurs
% On utilise une bloc-matrice de 3 blocs, chaque bloc contenant un vecteur.
% La longueur des vecteurs est de (2,3,2).

% create block dimensions
vdims = BlockDimensions({[2 3 2], 1});

% create block matrix instance
tt = BlockMatrix(rand(7, 1), vdims);

% display the block-vector (transposed)
disp('Transpose of input vector t:');
disp(tt');


%% Run the maxbet procedure

% create the factorization algorithm
algo = MaxBetAlgorithm('tolerance', .01);

% sample line to run the procedure
q = algo.factorize(data, tt);

% display the result (transposed)
disp('Transpose of result q:');
disp(q');
