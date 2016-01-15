function varargout = powerIteration(A, varargin)
%POWERITERATION simple function to test "power iteration" algorithm
%
%   LAMBDA = powerIteration(A)
%   [LAMBDA, U] = powerIteration(A)
%   ... = powerIteration(A, u0)
%   ... = powerIteration(A, u0, nIter)
%
%   Example
%     A = rand(5, 5);
%     [V, D] = eig(A);
%     [lambda, U] = powerIteration(A);
%     abs(lambda - D(1,1))
%     norm(U / norm(U) - V(:,1))
%
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2016-01-15,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2016 INRA - Cepia Software Platform.

n = size(A, 1);
u0 = rand(n, 1);
nIter = 100;

ui = u0;

for i = 1:nIter
    tmp = A * ui;
    lambda = norm(tmp);
    ui = tmp / lambda;
end

if nargout <= 1
    varargout = {lambda};
else
    varargout = {lambda, tmp};
end