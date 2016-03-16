%TESTJACOBIBLOCKPOWER  One-line description here, please.
%
%   output = testJacobiPowerBlock(input)
%
%   Example
%   testJacobiPowerBlock
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2016-03-02,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2016 INRA - Cepia Software Platform.

% initialise le generateur de nombres aleatoires
rng(100);

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


%% Compute problem data

% compute the block-matrix corresponding to maxbet algorithm
AA = blockProduct_uu(data', data);

% create new BlockMatrix representing the normalized input vectors
qq = blockProduct_hs(1./blockNorm(tt), tt);

% create the block power iteration algorithm
algo = JacobiBlockPower(AA, qq);

% init residual
resid = 1;
nIters = 10;
residArray = zeros(10, 1);
resArray = cell(nIters, 1);
structArray = [];

tol = 1e-18;

% iterate until residual is acceptable
for iIter = 1:nIters
    % performs one iteration, and get residual
    [q, resid, state] = algo.iterate();
%     residArray = [residArray resid];
    
    resArray{iIter} = q;
    residArray(iIter) = resid;
    structArray = [structArray state];
end


%% Solve problem using "solve" method

solution = solve(algo);
disp('Transposed solution:');
disp(solution');
