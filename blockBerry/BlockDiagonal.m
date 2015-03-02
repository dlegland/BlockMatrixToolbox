classdef BlockDiagonal < handle
%BLOCKDIAGONAL Diagonal matrix that can be divided into several 'block vectors' 
%
%   Class BlockDiagonal
%
%   Example
%   BlockDiagonal
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2015-03-02,    using Matlab 8.4.0.150421 (R2014b)
% Copyright 2015 INRA - BIA-BIBS.


%% Properties
properties
    % the set of diagonal vectors, as a cell array containing vectors
    diags;
    
    % the block dimensions of this diagonal matrix
    dims;
    
end % end properties


%% Constructor
methods
    function this = BlockDiagonal(varargin)
        % Constructor for BlockDiagonal class
        %
        %   diagos = {[1 2 3], [4 5], [6 7 8]};
        %   BD = BlockDiagonal(diagos);
        %
        
        if iscell(varargin{1})
            this.diags = varargin{1};
        else
            error('input argument must be a cell array of row vectors');
        end
        
        dd = cellfun(@length, this.diags);
        this.dims = BlockDimensions({dd, dd});
    end

end % end constructors


%% Methods specific to BlockMatrix object
% sorted approximately from high-level to low-level

methods
    
    function block = getBlock(this, row, col)
        % return the (i-th, j-th) block 
        %
        %   BLK = getBlock(BM, ROW, COL)
        %
        
        if row == col
            % extract data element corresponding to block.
            diagData = this.diags{row};
            block = diag(diagData);
        else
            % determine row indices of block rows
            parts1 = getBlockDimensions(this.dims, 1);
            parts2 = getBlockDimensions(this.dims, 2);
            
            % returns a zeros matrix of the appropriate size
            block = zeros(parts1(row), parts2(col));
        end
        
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
    
    function dim = getDimensionality(this)
        % Return the number of dimensions of this block matrix (usually 2)
        dim = getDimensionality(this.dims);
    end
    
    function siz = getSize(this, varargin)
        % Return the size in each direction of this block matrix object
        siz = getSize(this.dims, varargin{:});
    end
    
    function n = getBlockNumber(this, varargin)
        % Return the total number of blocks in this block matrix, or the
        % number of blocks in a given dimension
        %
        % N = getBlockNumber(BM);
        % N = getBlockNumber(BM, DIM);
        %
        n = getBlockNumber(this.dims, varargin{:});
    end
    
    function n = getBlockNumbers(this)
        % Return the number of blocks in each dimension
        n = getBlockNumbers(this.dims);
    end
end

%% Display methods

methods
    
    function disp(this)
        % display the content of this BlockMatrix object
        
        % loose format: display more empty lines
        isLoose = strcmp(get(0, 'FormatSpacing'), 'loose');
        
        % get BlockMatrix total size
        dim = getSize(this);
        nRows = dim(1);
        nCols = dim(2);
        
        % Display information on block sizes
        disp(sprintf('BlockMatrix object with %d rows and %d columns', nRows, nCols)); %#ok<DSPS>
        parts1 = getBlockDimensions(this.dims, 1);
        disp(sprintf('  row dims: %s', formatParts(parts1))); %#ok<DSPS>
        parts2 = getBlockDimensions(this.dims, 2);
        disp(sprintf('  col dims: %s', formatParts(parts2))); %#ok<DSPS>
        
        if isLoose
            fprintf('\n');
        end
        
        function string = formatParts(parts)
            % display parts as a list of ints, or as empty
            if isempty(parts)
                string = '(empty)';
            else
                pattern = strtrim(repmat(' %d', 1, length(parts)));
                string = sprintf(pattern, parts);
            end
        end
    end
    
    
    function displayBlocks(this)
        % get BlockMatrix total size
        nRowBlocks = length(getBlockDimensions(this.dims, 1));
        nColBlocks = length(getBlockDimensions(this.dims, 2));
        
        for row = 1:nRowBlocks
            for col = 1:nColBlocks
                disp(sprintf('Block (%d,%d)', row, col)); %#ok<DSPS>
                disp(getBlock(this, row, col));
            end
        end
        
    end
    
end % end methods

end % end classdef

