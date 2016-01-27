classdef JacobiPowerBlock < PowerBlockAlgo
%JACOBIPOWERBLOCK Jacobi algorithm for solving block power algorithms
%
%   Class JacobiPowerBlock
%
%   Example
%   JacobiPowerBlock
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2016-01-15,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2016 INRA - BIA-BIBS.


%% Properties
properties
    % the blockMatrix representing the problem
    data;
    % the block vector representing the initial solution
    init;
    % the current solution
    solution;
    
end % end properties


%% Constructor
methods
    function this = JacobiPowerBlock(varargin)
    % Constructor for JacobiPowerBlock class

    end

end % end constructors


%% Methods
methods
end % end methods

end % end classdef

