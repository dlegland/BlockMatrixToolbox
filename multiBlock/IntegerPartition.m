classdef IntegerPartition < handle
%INTEGERPARTITION Store an ordered partition of an integer
%
%   Class IntegerPartition
%   Store an ordered partition of an integer, as a list of integer terms.
%   Terms should be positive integers.
%
%   Example
%     IP = IntegerPartition([2, 3, 2]);
%     length(IP)
%     ans =
%         3
%
%   See also
%     BlockDimensions

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
    function this = IntegerPartition(varargin)
    % Constructor for IntegerPartition class
    % 
    % IP = IntegerPartition(TERMS)
    % where TERMS is a row vector of positive integers, initialize the
    % partition with the given terms.
    %
    % IP = IntegerPartition(IP0)
    % Copy constructor
    
        if nargin == 1 && isnumeric(varargin{1})
            % initialisation constructor
            var1 = varargin{1};
            if any(var1 <= 0) || any(round(var1) ~= var1)
                error('Requires only positive integers');
            end
            this.terms = varargin{1};
            
        elseif nargin == 1 && isa(varargin{1}, 'IntegerPartition')
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
    
    function n = sum(this)
        % returns the sum of the terms
        % (returns the same result as the "integer" function)
        n = sum(this.terms);
    end

    function inds = blockIndices(this, index)
        % returns the linear indices of the elements in the i-th block
        inds = (1:this.terms(index)) + sum(this.terms(1:index-1));
    end

end % end methods

%% Overload some native methods
methods
    function res = times(this, that)
        % multiplies two partitions element-wise
        %
        % P3 = times(P1, P2)
        % P3 = P1 .* P2
        
        if length(this) ~= length(that)
            error('The two partitions must have the same length');
        end
        
        newTerms = this.terms .* that.terms;
        res = IntegerPartition(newTerms);
    end
    
    function res = horzcat(this, varargin)
        % Overload the horizontal concatenation operator
        
        newTerms = this.terms;
        
        for i = 1:length(varargin)
            that = varargin{i};
            if ~isa(that, 'IntegerPartition')
                error(['Additional argument should be an IntegerPartition, not a ' classname(that)]);
            end
            newTerms = [newTerms that.terms]; %#ok<AGROW>
        end
        
        res = IntegerPartition(newTerms);
    end
    
    function varargout = subsref(this, subs)
        % returns the term of this partition at the given index
        %
        % P = IntegerPartition([2 3 2]);
        % P(2)
        % ans =
        %     3
        
        % extract reference type
        s1 = subs(1);
        type = s1.type;
        
        % switch between reference types
        if strcmp(type, '.')
            % in case of dot reference, use builtin subsref
            
            % check if we need to return output or not
            if nargout > 0
                % if some output arguments are asked, pre-allocate result
                varargout = cell(nargout, 1);
                [varargout{:}] = builtin('subsref', this, subs);
                
            else
                % call parent function, and eventually return answer
                builtin('subsref', this, subs);
                if exist('ans', 'var')
                    varargout{1} = ans; %#ok<NOANS>
                end
            end
            
            % stop here
            return;
            
        elseif strcmp(type, '()')
            % Process parens indexing
            
            varargout{1} = 0;
            
            % check number of indices
            ns = length(s1.subs);
            if ns == 1
                % returns the requested terms
                varargout{1} = this.terms(s1.subs{1});
                
            else
                error('Only linear indexing is allowed for IntegerPartition');
            end
            
        else
            error('braces indexing of IntegerPartition is not supported');
        end
            
    end
    
    function b = eq(this, that)
        % tests whether two compositions are the same or not
        
        if ~isa(this, 'IntegerPartition') || ~isa(that, 'IntegerPartition')
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
        % tests whether two compositions are different or not
        b = ~eq(this, that);
    end
    
end


%% Display methods

methods
    function disp(this)
        nd = length(this.terms);
        disp(sprintf('IntegerPartition object with %d terms', nd)); %#ok<DSPS>
        disp(['    ' char(this)]);
    end
    
    function buffer = char(this)
        % convert to string representation
        
        n = length(this.terms);
        pattern = ['(%d' repmat(', %d', 1, n-1) ')'];
        buffer = sprintf(pattern, this.terms);
    end

end

end % end classdef

