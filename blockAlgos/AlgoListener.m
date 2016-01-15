classdef AlgoListener < handle
%ALGOLISTENER Base class for listening to Algorithms events
%
%   Class AlgoListener
%
%   Example
%   AlgoListener
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
    function this = AlgoListener(varargin)
    % Constructor for AlgoListener class

    end

end % end constructors


%% General methods
methods
    function algoIterated(this, src, event)         %#ok<INUSD>
        % Overload this function to handle the 'AlgoIterated' event
    end
end % general methods

end % end classdef

