classdef BlockMatrix < AbstractBlockMatrix
%BLOCKMATRIX Matrix that can be divided into several blocks
%
%   BlockMatrix objects can be constructed in several ways:
%   data = reshape(1:28, [4 7]);
%   % construction from a cell array of integer partitions
%   BM = BlockMatrix(data, {[2 2], [2 3 2]});
%   % construction from integer partitions in each direction
%   BM = BlockMatrix(data, [2 2], [2 3 2]);
%   % construction from a BlockDimension object
%   DIMS = BlockDimensions({[2 2], [2 3 2]});
%   BM = BlockMatrix(data, DIMS);
%
%   Example
%     data = reshape(1:28, [7 4])';
%     dims = BlockDimensions({[2 2], [2 3 2]});
%     BM = BlockMatrix(data, dims);
%     disp(BM);
%
%   See also
%     BlockDiagonal, BlockDimensions
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2015-02-19,    using Matlab 8.4.0.150421 (R2014b)
% Copyright 2015 INRA - BIA-BIBS.


%% Properties
properties
    % contains the dimensions of blocs in each dimension, as a
    % BlockDimensions object
    dims;
    
    % contains the data, as a vector or an array. 
    % Idea is to access only via linear indexing
    data;
    
end % end properties

%% Static methods
methods (Static)
    function res = zeros(blockDims)
        % Creates an empty BlockMatrix with specified block-dimensions
        
        if ~isa(blockDims, 'BlockDimensions')
            error('Requires an instance of BlockDimensions as input');
        end
        
        % create empty array with appropriate size
        array = zeros(size(blockDims));
        
        % encapsulate into BlockMatrix object
        res = BlockMatrix(array, blockDims);
    end
end

%% Constructor
methods
    function this = BlockMatrix(varargin)
        % Constructor for BlockMatrix class
        %
        %   data = reshape(1:28, [4 7]);
        %   % construction from a cell array of integer partitions
        %   BM = BlockMatrix(data, {[2 2], [2 3 2]});
        %   % construction from integer partitions in each direction
        %   BM = BlockMatrix(data, [2 2], [2 3 2]);
        %   % construction from a BlockDimension object
        %   DIMS = BlockDimensions({[2 2], [2 3 2]});
        %   BM = BlockMatrix(data, DIMS);
        %
        %
        
        if nargin == 2
            if isnumeric(varargin{1})
                % initialisation constructor
                this.data = varargin{1};
                
            elseif isa(varargin{1}, 'BlockMatrix')
                % copy constructor
                bm = varargin{1};
                this.data = bm.data;
            else
                error('first argument must be a matrix or a block matrix');
            end
            
            % second argument represents block dimension. This can be
            % either a BlockDimension object, or a cell array containing
            % the block sizes in each dimension.
            var2 = varargin{2};
            if isa(var2, 'BlockDimensions')
                this.dims = var2;
            elseif iscell(var2)
                this.dims = BlockDimensions(var2);
            else
                error('second argument must be a cell array or a BlockDimensions object');
            end
            
        elseif nargin == 3
            % get data array and check validity
            if ~isnumeric(varargin{1}) || ndims(varargin{1})~=2 %#ok<ISMAT>
                error('First argument must be a 2D numeric array');
            end
            this.data = varargin{1};
            
            % create block-dimensions from the two last arguments
            rowdims = IntegerPartition(varargin{2});
            coldims = IntegerPartition(varargin{3});
            this.dims = BlockDimensions({rowdims, coldims});
            
        elseif nargin == 1
            % copy constructor, from another BlockMatrix object
            if isa(varargin{1}, 'BlockMatrix')
                bm = varargin{1};
                this.data = bm.data;
                this.dims = bm.dims;
            else
                error('copy constructor requires a block matrix object');
            end
            
        elseif isempty(varargin)
            % empty constructor: populate with default data
            this.data = 1:28;
            this.dims = BlockDimensions({[2 2], [2 3 2]});
            
        else
            error('Requires two or three input arguments');
        end

    end

end % end constructors


%% Methods specific to BlockMatrix object
% sorted approximately from high-level to low-level

methods
    function matrix = getMatrix(this)
        % Returns the content of this block-matrix as a matlab array
        %
        % For a BlockMatrix object BM, this is equivalent to 
        % matrix = BM.data;
        %
        matrix = this.data;
    end
    
    function block = getBlock(this, row, col)
        % return the (i-th, j-th) block 
        %
        %   BLK = getBlock(BM, ROW, COL)
        %
        
        % determine row indices of block rows
        parts1 = getBlockDimensions(this.dims, 1);
        rowInds = blockIndices(parts1, row)';

        % determine column indices of block columns
        parts2 = getBlockDimensions(this.dims, 2);
        colInds = blockIndices(parts2, col);
        
        % compute full size of block matrix
        dim = [sum(parts1) sum(parts2)];
        
        % compute indices of block elements in data
        colInds2 = repmat(colInds, length(rowInds), 1);
        rowInds2 = repmat(rowInds, 1, length(colInds));
        inds = sub2ind(dim, rowInds2, colInds2);
        
        % extract data element corresponding to block. 
        block = this.data(inds);
    end
    
    function setBlock(this, row, col, blockData)
        % set the data for the (i-th, j-th) block 
        %
        %   setBlock(BM, ROW, COL, DATA)
        %
        
        % determine row indices of block rows
        parts1 = getBlockDimensions(this.dims, 1);
        rowInds = blockIndices(parts1, row)';

        % check number of rows of input data
        if ~isscalar(blockData) && length(rowInds) ~= size(blockData, 1)
            error('block data should have %d rows, not %d', ...
                length(rowInds), size(blockData, 1));
        end

        % determine column indices of block columns
        parts2 = getBlockDimensions(this.dims, 2);
        colInds = blockIndices(parts2, col);
        
        % check number of columns of input data
        if ~isscalar(blockData) && length(colInds) ~= size(blockData, 2)
            error('block data should have %d columns, not %d', ...
                length(colInds), size(blockData, 2));
        end

        % compute full size of block matrix
        dim = [sum(parts1) sum(parts2)];
        
        % compute indices of block elements in data
        colInds2 = repmat(colInds, length(rowInds), 1);
        rowInds2 = repmat(rowInds, 1, length(colInds));
        inds = sub2ind(dim, rowInds2, colInds2);
        
        % extract data element corresponding to block. 
        this.data(inds) = blockData;
    end
end

%% Methods that depends uniquely on BlockDimensions object

methods
    function dims = blockDimensions(this, varargin)
        % Return the block-dimensions of this block-matrix
        %
        %   DIMS = blockDimensions(BM)
        %   Returns the block-dimension of this block matrix, as a
        %   BlockDimension object.
        %   
        %   DIMS = blockDimensions(BM, IND)
        %   Returns the BlockDimension object for the specified dimension,
        %   as a list of integers (subject to changes in future)
        %
        
        if nargin == 1
            dims = this.dims;
        else
            dim = varargin{1};
            dims = getBlockDimensions(this.dims, dim);
        end
    end

    function dims = getBlockDimensions(this, varargin)
        % deprecated: use size instead
        warning('BlockMatrixToolbox:deprecated', ...
            'method ''getBlockDimensions'' is obsolete, use ''blockDimensions'' instead');
        dims = blockDimensions(this, varargin{:});
    end
    
    function dim = dimensionality(this)
        % Return the number of dimensions of this block matrix (usually 2)
        dim = dimensionality(this.dims);
    end
    
    function siz = getSize(this, varargin)
        % Return the size in each direction of this block matrix object
        % deprecated: use size instead
        warning('BlockMatrixToolbox:deprecated', ...
            'method ''getSize'' is obsolete, use ''size'' instead');
        siz = size(this.dims, varargin{:});
    end
    
    function varargout = blockSize(this, varargin)
        % Return the number of blocks in each direction
        %
        % N = blockSize(BM);
        % N = blockSize(BM, DIM);
        % [N1, N2] = blockSize(BM);
        %
        
        if nargout <= 1
            varargout = {blockSize(this.dims, varargin{:})};
        else
            varargout = {blockSize(this.dims, 1), blockSize(this.dims, 2)};
        end
    end

    function n = blockNumber(this)
        % Return the total number of blocks of this BlockMatrix
        n = prod(blockSize(this));
    end
    
    function n = getBlockNumber(this, varargin)
        % Return the total number of blocks in this block matrix, or the
        % number of blocks in a given dimension
        %
        % deprecated: use blockSize instead
        
        warning('BlockMatrixToolbox:deprecated', ...
            'method ''getBlockNumber'' is obsolete, use ''blockSize'' instead');
        n = getBlockNumber(this.dims, varargin{:});
    end
    
    function n = getBlockNumbers(this)
        % Return the number of blocks in each dimension
        % deprecated: use blockSize instead
        
        warning('BlockMatrixToolbox:deprecated', ...
            'method ''getBlockNumbers'' is obsolete, use ''blockSize'' instead');
        n = getBlockNumbers(this.dims);
    end
end


%% Apply functions on inner data
methods
    function res = fapply(fun, this, varargin)
        % Apply any function to the inner block matrix data
        
        newData = fun(this.data, varargin{:});
        res = BlockMatrix(newData, this.dims);
    end
end

%% Overload some native methods

methods   
    
    function varargout = size(this, varargin)
        % Return the size in each direction of this block matrix object
        % 
        % SIZ = size(BM);
        % SIZI = size(BM, DIR);
        % [S1, S2] = size(BM);
        
        if nargout <= 1
            varargout = {size(this.dims, varargin{:})};
        else
            varargout = {size(this.dims, 1), size(this.dims, 2)};
        end
    end

    function res = transpose(this)
        % transpose this BlockMatrix
        res = ctranspose(this);
    end
    
    function res = ctranspose(this)
        % overload the transpose operator for BlockMatrix object
        
        % ensure the new matrix is a rectangular array, with the new size
        siz = size(this);
        data2 = reshape(this.data, siz)';
        
        % transpose the BlockDimensions object, and create new BlockMatrix
        dims2 = transpose(this.dims);
        res = BlockMatrix(data2, dims2);
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
        
        % initialize block dimension and data to that of first BlockMatrix
        data2 = reshape(this.data, size(this));
        dims2 = this.dims;
        
        for i = 1:length(varargin)
            var = varargin{i};
            
            dataToAdd = reshape(var.data, size(var));
            if size(dataToAdd, 1) ~= size(data2, 1)
                error('BlockMatrices should have same number of rows');
            end
            
            data2 = [data2 dataToAdd]; %#ok<AGROW>
            dims2 = [dims2 var.dims]; %#ok<AGROW>
        end
        
        res = BlockMatrix(data2, dims2);
    end
    
    function res = vertcat(this, varargin)
        % Override the vertical concatenation operator
        
        % initialize block dimension and data to that of first BlockMatrix
        data2 = reshape(this.data, size(this));
        dims2 = this.dims;
        
        for i = 1:length(varargin)
            var = varargin{i};
            
            dataToAdd = reshape(var.data, size(var));
            if size(dataToAdd, 2) ~= size(data2, 2)
                error('BlockMatrices should have same number of columns');
            end
            
            data2 = [data2 ; dataToAdd]; %#ok<AGROW>
            dims2 = [dims2 ; var.dims]; %#ok<AGROW>
        end
        
        res = BlockMatrix(data2, dims2);
    end
    
    
    function varargout = subsasgn(this, subs, value)
        % Override subsasgn function for BlockMatrix objects
        
        % extract current indexing info
        s1 = subs(1);
        type = s1.type;
        
        if strcmp(type, '.')
            % in case of dot reference, use builtin
            
            % if some output arguments are asked, use specific processing
            if nargout > 0
                varargout = cell(1);
                varargout{1} = builtin('subsasgn', this, subs, value);
            else
                builtin('subsasgn', this, subs, value);
            end
            
        elseif strcmp(type, '()')
            % In case of parens reference, index the inner data
            
            % different processing if 1 or 2 indices are used
            ns = length(s1.subs);
            if ns == 1
                % one index: use linearised indices
                
                % check that indices are within image bound
                this.data(s1.subs{:});
                
                this.data(s1.subs{1}) = value;
                
            elseif ns == 2
                % two indices: parse row and column indices
                
                % check that indices are within image bound
                this.data(s1.subs{:});
                
                % extract corresponding data
                this.data(s1.subs{:}) = value;
           
            else
                error('BlockMatrix:subsasgn', 'Too many indices');
            end
            
        elseif strcmp(type, '{}')
            % In case of braces indexing, use blocks
            
            ns = length(s1.subs);
            if ns == 2
                % returns integer partition of corresponding dimension
                blockRow = s1.subs{1};
                blockCol = s1.subs{2};
                
                setBlock(this, blockRow, blockCol, value);
            else
                error('Requires two indices for identifying blocks');
            end

            
        else
            error('BlockMatrix:subsasgn', 'Can not manage such reference');
        end
        
        if nargout > 0
            varargout{1} = this;
        end

    end
end

end % end classdef

