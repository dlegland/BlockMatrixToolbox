classdef BlockDimensions < handle
%BlockDimensions  Store the block dimensions of a BlockMatrix data structure
%
%   Class BlockDimensions
%
%   Example
%   BD = BlockDimensions({[2 2], [2, 3, 2]});
%
%   Example
%   p1 = IntegerPartition([2, 2]);
%   p2 = IntegerPartition([2, 3, 2]);
%   BD = BlockDimensions({p1, p2});
%
%   See also
%     BlockMatrix

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2015-02-20,    using Matlab 8.4.0.150421 (R2014b)
% Copyright 2015 INRA - BIA-BIBS.


%% Properties
properties
    % contains the dimensions of blocs in each dimension, as a cell array
    % containing row vectors of integers
    parts;
    
end % end properties


%% Constructor
methods
    function this = BlockDimensions(varargin)
        % Constructor for BlockDimensions class
        %
        %   BD = BlockDimensions(PARTS);
        %   PARTS is a cell array, containing for each dimension the sizes
        %   of the blocks in this dimension.
        % 
        %   Example
        %   BD = BlockDimensions({[2 2], [2 3 2]});
        %   Creates a BlockDimensions object for a BlockMatrix, that will be
        %   divided into two blocks in dimension 1 and into three blocks in
        %   dimension 2.
        %
        
        if iscell(varargin{1})
            % initialisation constructor
            % 
            % can be initialised from:
            % * a cell array of IntegerPartition
            % * a cell array of integer arrays
            % * another BlockDimensions object
            %
            
            var1 = varargin{1};
            this.parts = cell(1, length(var1));
            for i = 1:length(var1)
                if isa(var1{i}, 'IntegerPartition')
                    this.parts{i} = var1{i};
                else
                    % convert integer array to IntegerPartition object
                    this.parts{i} = IntegerPartition(var1{i});
                end
            end
            
        elseif isa(varargin{1}, 'BlockDimensions')
            % copy constuctor
            bd = varargin{1};
            this.parts = bd.parts;
        else
            error('input argument must be a cell array');
        end
    end

end % end constructors


%% Methods

methods
    function dims = getBlockDimensions(this, dim)
        % Return the dimensions of the block in the specified dimension
        %
        % DIMS = getBlockDimensions(BD, IND)
        % DIMS is an IntegerPartition
        dims = this.parts{dim};
    end
    
    function dim = dimensionality(this)
        % Return the number of dimensions
        dim = length(this.parts);
    end
    
    function siz = getSize(this, varargin)
        % Return the size (number of matrix elements) in each direction
        %
        % SIZ = getSize(BD)
        % Returns the size as a 1-by-ND row vector, where ND is the
        % dimensionality of this BlockDimensions.
        %
        % SIZ = getSize(BD,DIM)
        % Returns the size in the specified dimension. DIM should be an
        % integer between 1 and ND
        %
        
        if isempty(varargin)
            % return dimension vector
            siz = zeros(1, length(this.parts));
            for i = 1:length(this.parts)
%                 siz(i) = sum(this.parts{i});
                siz(i) = integer(this.parts{i});
            end
        else
            dim = varargin{1};
            siz = zeros(1, length(dim));
            nd = dimensionality(this);
            for i = 1:length(dim)
                if dim(i) > nd
                    error(sprintf(...
                        'dimension %d is too high, should be less than', dim(i), nd)); %#ok<SPERR>
                end
%                 siz(i) = sum(this.parts{dim(i)});
                siz(i) = integer(this.parts{dim(i)});
            end
        end
    end
    
    function n = getBlockNumber(this, varargin)
        % Return the total number of blocks
        %
        % N = getBlockNumber(BD);
        %
        
        if isempty(varargin)
            % compute total number of blocks
            n = 1;
            for i = 1:length(this.parts)
                n = n * length(this.parts{i});
            end
        else
            % returns the number of blocks only in the specified
            % dimension(s)
            dim = varargin{1};
            n = zeros(1, length(dim));
            for i = 1:length(dim)
                n(i) = length(this.parts{dim(i)});
            end
        end
    end
    
    function n = getBlockNumbers(this)
        % Return the number of blocks in each dimension
        %
        % N = getBlockNumbers(BD);
        % N is a 1-by-ND row vector
        %
        
        nd = length(this.parts);
        n = zeros(1, nd);
        for i = 1:nd
            n(i) = length(this.parts{i});
        end
    end
end


%% overload some native methods

methods
    function res = transpose(this)
        % transpose the block dimensions
        res = ctranspose(this);
    end
    
    function res = ctranspose(this)
        % overload the transpose operator for BlockDimensions objects
        nd = length(this.parts);
        if nd ~= 2
            error('transpose is defined only for 2D BlockDimensions objects');
        end
        
        parts2 = cell(1, nd);
        parts2{1} = this.parts{2};
        parts2{2} = this.parts{1};
        res = BlockDimensions(parts2);
    end
    
    function res = cat(dim, varargin)
        % overload concatenation method for arbitrary dimension (between 1 and 2...) 
        switch dim
            case 1
                res = vertcat(varargin{:});
            case 2
                res = horzcat(varargin{:});
            otherwise
                error('unsupported dimension: %d', dim);
        end
    end
    
    function res = horzcat(this, varargin)
        % Overload the horizontal concatenation operator
        
        nd = length(this.parts);
        partsH = this.parts{2};
        
        for i = 1:length(varargin)
            var = varargin{i};
            % additional BlockDimensions should have same dimensionality
            % and same block size in other dimensions
            if length(var.parts) ~= nd
                error('Other BlockDimensions should have same dimensionality');
            end
            for iDim = [1 3:nd]
                if length(this.parts{iDim}) ~= length(var.parts{iDim})
                    error('BlockDimensions should have same block number in dimension %d', iDim); 
                end
%                 if any(this.parts{iDim} ~= var.parts{iDim}) 
                if this.parts{iDim} ~= var.parts{iDim}
                    error('BlockDimensions should have same block sizes in dimension %d', iDim); 
                end
            end
            
            partsH = [partsH var.parts{2}]; %#ok<AGROW>
        end
        
        newParts = [this.parts(1) {partsH} this.parts(3:end)];
        res = BlockDimensions(newParts);
    end

    function res = vertcat(this, varargin)
        % Overload the vertical concatenation operator
        
        nd = length(this.parts);
        partsV = this.parts{1};
        
        for i = 1:length(varargin)
            var = varargin{i};
            % additional BlockDimensions should have same dimensionality
            % and same block size in other dimensions
            if length(var.parts) ~= nd
                error('Other BlockDimensions should have same dimensionality');
            end
            for iDim = 2:nd
                if length(this.parts{iDim}) ~= length(var.parts{iDim})
                    error('BlockDimensions should have same block number in dimension %d', iDim); 
                end
                % if any(this.parts{iDim} ~= var.parts{iDim})
                if this.parts{iDim} ~= var.parts{iDim}
                    error('BlockDimensions should have same block sizes in dimension %d', iDim); 
                end
            end
            
            partsV = [partsV var.parts{1}]; %#ok<AGROW>
        end
        
        newParts = [{partsV} this.parts(2:end)];
        res = BlockDimensions(newParts);
    end
    
end

%% Display methods

methods
    function disp(this)
        % display the content of this BlockMatrix object
        
        % loose format: display more empty lines
        isLoose = strcmp(get(0, 'FormatSpacing'), 'loose');
        
        % get dimensionality
        nd = dimensionality(this);
        
        % Display information on block sizes in each dimension
        disp(sprintf('BlockDimensions object with %d dimensions', nd)); %#ok<DSPS>
        for i = 1:nd
            parts_i = this.parts{i};
            string = formatParts(parts_i);
            disp(sprintf('  parts dims %d: %s', i, string)); %#ok<DSPS>
        end
        
        if isLoose
            fprintf('\n');
        end
        
        function string = formatParts(parts)
            % display parts as a list of ints, or as empty
            if isempty(parts)
                string = '(empty)';
            else
                pattern = strtrim(repmat(' %d', 1, length(parts)));
                string = sprintf(pattern, parts.terms);
            end
        end
    end

end % end methods

end % end classdef

