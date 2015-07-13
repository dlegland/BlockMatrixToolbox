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
    % given as a n-by-1 row vector of partitions
    terms;
    
end % end properties


%% Static methods
methods (Static)
    function res = ones(n)
        % Returns a new partition formed only by ones
        %
        % Example
        % I4 = IntegerPartition.ones(4)
        % I4 =
        % IntegerPartition object with 4 terms
        %     (1, 1, 1, 1)
        res = IntegerPartition(ones(1, n));
    end
end


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
    function p = term(this, index)
        % Returns the size of the i-th partition
        p = this.terms(index);
    end
    
    function n = integer(this)
        % Returns the value of the partitioned integer
        % deprecated: use sum instead
        warning('deprecated: use sum instead');
        n = sum(this.terms);
    end
    
    function inds = blockIndices(this, index)
        % Returns the linear indices of the elements in the i-th block
        inds = (1:this.terms(index)) + sum(this.terms(1:index-1));
    end

end % end methods

%% boolean methods to identify the type of partition
methods
    function tf = isUniform(this)
        % Returns true if all terms are equal
        tf = all(this.terms == this.terms(1));
    end
    
    function tf = isScalar(this)
        % Returns true if the length of the partition equals one
        tf = length(this.terms) == 1;
    end
    
    function tf = isOnes(this)
        % Returns true if all terms equal one
        % (the method isUniform will return true as well). 
        tf = all(this.terms == 1);
    end
end % end methods

%% Overload some native methods

methods
    function n = length(this)
        % Returns the number of terms of this partition
        n = length(this.terms);
    end
    
    function n = sum(this)
        % Returns the sum of the terms
        % (returns the same result as the "integer" function)
        n = sum(this.terms);
    end

    function res = mtimes(this, that)
        % Multiplies a partition by a scalar integer
        %
        % P2 = mtimes(P1, S)
        % P2 = mtimes(S, P1)
        %
        % Example
        % P = IntegerPartition([1 2 3]);
        % P2 = P * 3
        % P2 = 
        % IntegerPartition object with 3 terms
        %   ( 3, 6, 9)
        
        
        % one of the two arguments is an integer
        % -> identify arguments
        if isa(this, 'IntegerPartition')
            part = this;
            arg = that;
        else
            part = that;
            arg = this;
        end
        
        % check validity (scalar and integer)
        if ~isscalar(arg) || mod(arg, 1) ~= 0
            error('second argument must be a scalar integer');
        end
        
        % create result
        newTerms = part.terms * arg;
        res = IntegerPartition(newTerms);
    end
    
    function res = times(this, that)
        % Multiplies two partitions element-wise
        %
        % P3 = times(P1, P2)
        % P3 = P1 .* P2
        
        if ~isa(this, 'IntegerPartition') || ~isa(that, 'IntegerPartition')
            error('Both arguments must be IntegerPartition');
        end
        
        % Both arguments are instances of integer partition
        % -> use element-wise multiplication
        
        % check length
        if length(this) ~= length(that)
            error('The two partitions must have the same length');
        end
        
        newTerms = this.terms .* that.terms;
        res = IntegerPartition(newTerms);
    end
    
    function res = plus(this, that)
        % Adds two partitions element-wise
        %
        % P3 = plus(P1, P2)
        % P3 = P1 + P2
        
        if isa(this, 'IntegerPartition') && isa(that, 'IntegerPartition')
            % Both arguments are instances of integer partition
            % -> use element-wise addition

            % check length
            if length(this) ~= length(that)
                error('The two partitions must have the same length');
            end

            newTerms = this.terms + that.terms;
            res = IntegerPartition(newTerms);
        else
            
            % one of the two arguments is numeric
            % -> identify arguments
            if isa(this, 'IntegerPartition')
                part = this;
                arg = that;
            else
                part = that;
                arg = this;
            end
            
            newTerms = part.terms + arg;
            res = IntegerPartition(newTerms);
        end
    end
    
    function res = mrdivide(this, arg)
        % Divides partiton terms by an integer
        
        if ~isscalar(arg) || mod(arg, 1) ~= 0
            error('second argument must be an integer');
        end
        if any(mod(this.terms, arg) ~= 0)
            error('at least one term is not divisible by %d', arg);
        end
        
        newTerms = this.terms / arg;
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
        % Returns the term of this partition at the given index
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
        % Tests whether two compositions are the same or not
        
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

