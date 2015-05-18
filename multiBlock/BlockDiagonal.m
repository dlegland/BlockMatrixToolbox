classdef BlockDiagonal < AbstractBlockMatrix
%BLOCKDIAGONAL Block Matrix with zeros blocks except on diagonal blocks
%
%   BlockDiagonal objects are constructed from the list of blocks located
%   on the diagonal. The Block-Dimensions of the block-diagonal is computed
%   automatically.
%
%   Example
%   % create a block diagonal matrix
%   BD = BlockDiagonal({rand(2, 3), rand(2, 2), rand(1, 2)});
%   % transpose and multiplies two blockdiagonals
%   BD' * BD
%
%   See also
%     BlockMatrix, BlockDimensions
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2015-03-02,    using Matlab 8.4.0.150421 (R2014b)
% Copyright 2015 INRA - BIA-BIBS.


%% Properties
properties
    % the set of diagonal blocks, as a cell array containing matrices
    diags;
    
    % the block dimensions of this diagonal matrix, as a cell array of
    % integer partitions.
    dims;
    
end % end properties


%% Constructor
methods
    function this = BlockDiagonal(varargin)
        % Constructor for BlockDiagonal class
        %
        %   diagos = {rand(2,3), rand(2,2), rand(3, 2)};
        %   BD = BlockDiagonal(diagos);
        %
        
        if nargin == 0
            error('Require at least one input argument');
        end
        
        if iscell(varargin{1})
            % blocks are given as a cell array of matrices
            this.diags = varargin{1};
            
        elseif all(cellfun(@isnumeric, varargin))
            % blocks are given as varargin
            this.diags = varargin;
            
        elseif isa(varargin{1}, 'BlockDiagonal')
            % copy constructor
            var1 = varargin{1};
            this.diags = var1.diags;
            this.dims = var1.dims;
            
        else
            error('input argument must be a cell array of matrices');
        end
        
        % compute block dimensions
        nDiags = length(this.diags);
        dims1 = zeros(1, nDiags);
        dims2 = zeros(1, nDiags);
        for i = 1:nDiags
            siz = size(this.diags{i});
            dims1(i) = siz(1);
            dims2(i) = siz(2);
        end
        this.dims = BlockDimensions({dims1, dims2});
    end

end % end constructors


%% Methods specific to BlockMatrix object
% sorted approximately from high-level to low-level

methods
    function matrix = getMatrix(this)
        % Returns the content of this block-matrix as a matlab array
        %
 
        % allocate size for result matrix
        siz = size(this);
        matrix = zeros(siz);
         
        % determine block dimensions along each dimension
        dims1 = getBlockDimensions(this.dims, 1);
        dims2 = getBlockDimensions(this.dims, 2);
        
        % iterate over diagonal blocks
        for iBlock = 1:min(length(dims1), length(dims2))
            block = getBlock(this, iBlock, iBlock);
            rowInds = blockIndices(dims1, iBlock);
            colInds = blockIndices(dims2, iBlock);
            matrix(rowInds, colInds) = block;
        end
    end
 
    function block = getBlock(this, row, col)
        % return the (i-th, j-th) block 
        %
        %   BLK = getBlock(BM, ROW, COL)
        %
        
        if row == col
            % extract data element corresponding to block.
            block = this.diags{row};
            
        else
            % determine row indices of block rows
            parts1 = getBlockDimensions(this.dims, 1);
            parts2 = getBlockDimensions(this.dims, 2);
            
            % returns a zeros matrix of the appropriate size
            block = zeros(parts1(row), parts2(col));
        end
    end
    
    function setBlock(this, row, col, blockData)
        % set the data for the (i-th, j-th) block 
        %
        %   setBlock(BM, ROW, COL, DATA)
        %   ROW and COL indices should be equal
        %
        
        % check ROW and COL equality
        if row ~= col
            error('row and column indices should be the same');
        end
        
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

        % extract data element corresponding to block. 
        this.diags{row} = blockData;
    end
end


%% Methods that depends uniquely on BlockDimensions object
methods
    function dims = getBlockDimensions(this, dim)
        % Return the dimensions of the block in the specified dimension
        %
        % DIMS = getBlockDimensions(BM, IND)
        %
        dims = getBlockDimensions(this.dims, dim);
    end
    
    function dim = dimensionality(this)
        % Return the number of dimensions of this block matrix (usually 2)
        dim = dimensionality(this.dims);
    end
    
    function siz = getSize(this, varargin)
        % Return the size in each direction of this block matrix object
        %
        % deprecated: use size instead
        warning('BlockMatrixToolbox:deprecated', ...
            'method ''getSize'' is obsolete, use ''size'' instead');
        siz = getSize(this.dims, varargin{:});
    end
    
    function siz = blockSize(this, varargin)
        % Return the number of blocks of this BlockMatrix
        %
        % N = blockSize(BM);
        % N = blockSize(BM, DIM);
        %
        siz = blockSize(this.dims, varargin{:});
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
        n = getBlockNumbers(this.dims);
    end
end

%% Overload some native methods
methods
    function siz = size(this, varargin)
        % Return the size in each direction of this block matrix object
        siz = size(this.dims, varargin{:});
    end
    
    function res = transpose(this)
        % transpose this BlockDiagonal Matrix
        res = ctranspose(this);
    end
    
    function res = ctranspose(this)
        % overload the transpose operator for BlockDiagonal object
        
        % Transpose each block
        nDiags = length(this.diags);
        diags2 = cell(nDiags, 1);
        for i = 1:nDiags
            diags2{i} = this.diags{i}';
        end
        
        % Creates the new BlockDiagonal object (Block dimensions are
        % computed automatically in constructor)
        res = BlockDiagonal(diags2);
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
            error('BlockDiagonal:subsasgn', 'Can not manage parens reference');
            
        elseif strcmp(type, '{}')
            % In case of braces indexing, use blocks
            
            ns = length(s1.subs);
            if ns == 1
                % linear indexing of block
                blockRow = s1.subs{1};
                setBlock(this, blockRow, blockRow, value);
                
            elseif ns == 2
                % two indices: row and col indices of blocks should be the same
                blockRow = s1.subs{1};
                blockCol = s1.subs{2};
                if any(blockRow ~= blockCol)
                    error('row indices should match column indices');
                end
                setBlock(this, blockRow, blockRow, value);
                
            else
                error('too many indices for identifying diagonal block');
            end

            
        else
            error('BlockDiagonal:subsasgn', 'Can not manage such reference');
        end
        
        if nargout > 0
            varargout{1} = this;
        end

    end

end

end % end classdef

