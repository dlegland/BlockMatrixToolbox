classdef BlockPowerAlgoState < handle
%BLOCKPOWERALGOSTATE Abstract class for iterating block power algorithms
%
%   Abstract class for iterating block power algorithms. This template is
%   intended to be derived and implemented by concrete classes.
%
%   See also
%     JacobiBlockPower, GaussBlockPower 

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2016-01-15,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2016 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function this = BlockPowerAlgoState(varargin)
    % Constructor for BlockPowerAlgo class

    end

end % end constructors


%% Methods
methods (Abstract)
    newState = next(this)
end % end methods

end % end classdef

