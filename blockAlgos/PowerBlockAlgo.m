classdef PowerBlockAlgo < handle
%POWERBLOCKALGO Generic interface for Block factorization algorithms
%
%   Class PowerBlockAlgo
%
%   Example
%   PowerBlockAlgo
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
end % end properties


%% Constructor
methods
    function this = PowerBlockAlgo(varargin)
    % Constructor for PowerBlockAlgo class

    end

end % end constructors


%% Methods
methods (Abstract)
    iterate(this)
end % end methods

end % end classdef

