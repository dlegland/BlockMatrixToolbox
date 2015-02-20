classdef BlockMatrix < handle
%BLOCKMATRIX  One-line description here, please.
%
%   Class BlockMatrix
%
%   Example
%   BlockMatrix
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2015-02-19,    using Matlab 8.4.0.150421 (R2014b)
% Copyright 2015 INRA - BIA-BIBS.


%% Properties
properties
    % contains the dimensions of blocs in each dimension, as a cell array
    % containing row vectors of integers
    parts;
    
    % contains the data, as a vector or an array. 
    % Idea is to access only via linear indexing
    data;
    
end % end properties


%% Constructor
methods
    function this = BlockMatrix(varargin)
        % Constructor for BlockMatrix class
        %
        %   data = reshape(1:28, [4 7]);
        %   BM = BlockMatrix(data, {[2 2], [2 3 2]});
        %
        
        if isempty(varargin)
            % populate with default data
            this.parts = {[2 2], [2 3 2]};
            this.data = 1:28;
            
        elseif nargin == 2
            if ~isnumeric(varargin{1})
                error('first argument must be numeric');
            end
            this.data = varargin{1};
            
            if ~iscell(varargin{2})
                error('second argument must be a cell array');
            end
            this.parts = varargin{2};
            
        else
            error('Requires two input arguments');
        end

    end

end % end constructors


%% Methods
methods
    function dims = getBlockDimensions(this, dim)
        % return the dimensions of the block in the specified dimension
        %
        % DIMS = getBlockDimensions(BM, IND)
        %
        dims = this.parts{dim};
    end
    
    function dim = getDimensionality(this)
        % returns the number of dimensions of this block matrix (2)
        dim = length(this.parts);
    end
    
    function siz = getSize(this)
        % return the size in each direction of this block matrix object
        siz = zeros(1, length(this.parts));
        for i = 1:length(this.parts)
            siz(i) = sum(this.parts{i});            
        end
    end
    
    function n = getBlockNumber(this)
        % return the total number of blocks in this block matrix
        %
        % N = getBlockNumber(BM);
        %
        n = 1;
        for i = 1:length(this.parts)
            n = n * length(this.parts{i});
        end
    end
    
    function block = getBlock(this, row, col)
        % return the (i-th, j-th) block 
        %
        %   BLK = getBlock(BM, ROW, COL)
        %
        
        % determine row indices of block rows
        parts1 = this.parts{1};
        rowInds = (1:parts1(row))' + sum(parts1(1:row-1));

        % determine column indices of block columns
        parts2 = this.parts{2};
        colInds = (1:parts2(col)) + sum(parts2(1:col-1));
        
        % compute full size of block matrix
        dim = [sum(parts1) sum(parts2)];
        
        % compute indices of block elements in data
        colInds2 = repmat(colInds, length(rowInds), 1);
        rowInds2 = repmat(rowInds, 1, length(colInds));
        inds = sub2ind(dim, rowInds2, colInds2);
        
        % extract data element corresponding to block. 
        block = this.data(inds);
    end
    
    function disp(this)
        % display the content of this BlockMatrix object
        
        % loose format: display more empty lines
        isLoose = strcmp(get(0, 'FormatSpacing'), 'loose');
        
        % get BlockMatrix total size
        dim = getSize(this);
        nRows = dim(1);
        nCols = dim(2);
        
        % Display information on block sizes
        disp(sprintf('BlockMatrix Object with %d rows and %d columns', nRows, nCols)); %#ok<DSPS>
        parts1 = this.parts{1};
        disp(sprintf(['  row dims:' repmat(' %d', 1, length(parts1))], parts1)); %#ok<DSPS>
        parts2 = this.parts{2};
        disp(sprintf(['  col dims:' repmat(' %d', 1, length(parts2))], parts2)); %#ok<DSPS>
        
        if isLoose
            fprintf('\n');
        end
    end
    
    function displayBlocks(this)
        % get BlockMatrix total size
        nRowBlocks = length(this.parts{1});
        nColBlocks = length(this.parts{2});
        
        for row = 1:nRowBlocks
            for col = 1:nColBlocks
                disp(sprintf('Block (%d,%d)', row, col)); %#ok<DSPS>
                disp(getBlock(this, row, col));
            end
        end
        
    end
    
end % end methods

end % end classdef

