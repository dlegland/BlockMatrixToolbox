%DEMOPOWERITERATIONALGO Demo script for the PowerIteration class
%
%   Syntax:
%       demoPowerIterationAlgo;
%
%   Example
%   demoPowerIterationAlgo
%
%   See also
%     PowerIterationAlgo, PowerIterationValueDisplayListener
%
 
% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2016-01-27,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2016 INRA - Cepia Software Platform.

%% create an algorithm and iterate it

% create initial data
N = 20;
MAT = rand(N, N);
V0 = rand(N, 1);

% init algo
ALGO = PowerIterationAlgo(MAT, V0);

% compute eigen values with Matlab for checking
lambdaRef = abs(eig(MAT));

% iterate for a given number of iterations
for i = 1:50
    lambda = iterate(ALGO); 
end

% compute and display final value
disp(sprintf('lambda_1 = %f (exp: %f)', lambda, lambdaRef(1))); %#ok<DSPS>


%% Manually track evolution

nIter = 20;
lambdaList = zeros(nIter, 1);

% init algo
ALGO = PowerIterationAlgo(MAT, V0);

% iterate for a given number of iterations
for iIter = 1:nIter
    lambdaList(iIter) = iterate(ALGO); 
end

% display result progression
figure; set(gca, 'fontsize', 14); hold on;
plot([1 nIter], [lambdaRef(1) lambdaRef(1)], 'k');
plot(lambdaList, 'color', 'b', 'linewidth', 2);
% ylim([0 1.1*max(lambdaList)]);
xlabel('Iteration Number');
ylabel('Eigen value estimation');


%% Track evolution using a listener

% init algo
ALGO = PowerIterationAlgo(MAT, V0);

% prepare figure for display
figure; set(gca, 'fontsize', 14); hold on;
xlabel('Iteration Number');
ylabel('Eigen value estimation');

% create new listener
listener = PowerIterationValueDisplayListener(gca);

% attach the listener to algorithm instance
addAlgoListener(ALGO, listener);

% iterate for a given number of iterations
for iIter = 1:nIter
    iterate(ALGO); 
end


%% Track a posteriori the difference between two vectors

nIter = 30;
vectorList = zeros(nIter, N);

% init algo
ALGO = PowerIterationAlgo(MAT, V0);

% iterate for a given number of iterations
for iIter = 1:nIter
    iterate(ALGO); 
    vectorList(iIter, :) = ALGO.vector;
end

% compute displacement between successive vectors
diff([V0';vectorList]);
vDiff = diff([V0';vectorList]);

% compute norm of differences
absDiff = zeros(nIter, 1);
for iIter = 1:nIter
    absDiff(iIter) = norm(vDiff(iIter,:));
end

% display differences
figure; set(gca, 'fontsize', 14); hold on;
plot(absDiff, 'linewidth', 2);
xlabel('Iteration number');
ylabel('Sucessive difference');

% use log scale
figure; set(gca, 'fontsize', 14); hold on;
plot(log(absDiff))
xlabel('Iteration number');
ylabel('Log of vector difference');

