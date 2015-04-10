classdef IntegerComposition < handle
%INTEGERCOMPOSITION Store an ordered partition of an integer
%
%   Class IntegerComposition
%
%   Example
%   IntegerComposition
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2015-04-10,    using Matlab 8.4.0.150421 (R2014b)
% Copyright 2015 INRA - BIA-BIBS.


%% Properties
properties
    % the partition of the integer
    terms;
    
end % end properties


%% Constructor
methods
    function this = IntegerComposition(varargin)
    % Constructor for IntegerComposition class
        if nargin == 1 && isnumeric(varargin{1})
            % initialisation constructor
            this.terms = varargin{1};
            
        elseif nargin == 1 && isa(varargin{1}, 'IntegerComposition')
            % copy constructor
            var1 = varargin{1};
            this.terms = var1.terms;
            
        else
            error('Requires an initialisation array');
        end

    end

end % end constructors


%% Methods
methods
    function n = length(this)
        n = length(this.terms);
    end
    
    function p = term(this, index)
        % returns the size of the i-th partition
        p = this.terms(index);
    end
    
    function n = integer(this)
        % returns the value of the partitioned integer
        n = sum(this.terms);
    end
    
    function b = eq(this, that)
        % compare two integer compositions
        
        if ~isa(this, 'IntegerComposition') || ~isa(that, 'IntegerComposition')
            b = false;
            return;
        end
        
        if length(this.terms) ~= length(that.terms)
            b = false;
            return;
        end
        
        b = all(this.terms == that.terms);
    end
    
    function b = ne(this, that)
        % tests whether two compositions are the same or not
        b = ~eq(this, that);
    end
    
    function b = isWeak(this)
        % returns true if at least one of the terms is zeros
        b = any(this.terms == 0);
    end
end % end methods

end % end classdef

