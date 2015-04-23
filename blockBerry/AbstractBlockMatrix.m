classdef AbstractBlockMatrix < handle
%ABSTRACTBLOCKMATRIX  Utility class parent of BlockMatrix and BlockDiagonal 
%
%   Class AbstractBlockMatrix
%
%   Example
%   AbstractBlockMatrix
%
%   See also
%   BlockMatrix, BlockDiagonal

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2015-04-22,    using Matlab 8.4.0.150421 (R2014b)
% Copyright 2015 INRA - BIA-BIBS.


% no properties are defined, nor constructor

%% Interface Methods
% Methods in this bloc are declared for implementation in sub-classes

methods (Abstract)
    block = getBlock(this, row, col)
    % Returns the block content at a given position
    
    block = setBlock(this, row, col, blockContent)
    % Updates the block content at a given position

    dims = getBlockDimensions(this, dim)
    % Return the dimensions of the block in the specified dimension
    
    dim = dimensionality(this)
    % Return the number of dimensions of this block matrix (usually 2)
    
    getSize(this, varargin)
    % Return the size in each direction of this block matrix object
    
    n = getBlockNumber(this, varargin)
    % Return the total number of blocks in this block matrix, or the
    % number of blocks in a given dimension
    
    n = getBlockNumbers(this)
    % Return the number of blocks in each dimension
    
end % end abstract methods


%% Computation Methods
% Some methods are performed, that only relies on abstract methods.

methods
    function res = mtimes(this, that)
        % multiplies two instances of BlockMatrix
        % 
        % usage:
        %   X = A * B
        
        % get block dimensions of each matrix
        dimsA = this.dims;
        dimsB = that.dims;
        
        % check dimensionality
        if dimensionality(dimsB) ~= 2
            error('Requires another BlockTensor of dimensionality 2');
        end
        
        % total number of elements should match
        if getSize(dimsA, 2) ~= getSize(dimsB, 1)
            error('number of columns of first matrix (%d) should match number of rows of second matrix (%d)', ...
                getSize(dimsA, 2), getSize(dimsB, 1));
        end
        if getBlockNumber(dimsA, 2) ~= getBlockNumber(dimsB, 1)
            error('number of block columns of first matrix (%d) should match number of block rows of second matrix (%d)', ...
                getBlockNumber(dimsA, 2), getBlockNumber(dimsB, 1));
        end

        % compute size and block dimension of the resulting block-matrix
        dimsC = BlockDimensions([dimsA.parts(1) dimsB.parts(2)]);
        nC = getSize(dimsC, 1);
        mC = getSize(dimsC, 2);
        res = BlockMatrix(zeros([nC mC]), dimsC);

        % number of blocks to iterate
        nBlocks = getBlockNumber(dimsA, 2);

        for iRow = 1:getBlockNumber(dimsA, 1)
            for iCol = 1:getBlockNumber(dimsB, 2)
                % Compute block (iRow, iCol), by iterating over i-th row of
                % first matrix, and j-th column of second matrix
                
                % allocate memory for current result block
                block = zeros([dimsA.parts{1}(iRow) dimsB.parts{2}(iCol)]);
                
                % iterate over columns of first matrix, and rows of second
                % matrix
                for iBlock = 1:nBlocks
                    blockA = getBlock(this, iRow, iBlock);
                    blockB = getBlock(that, iBlock, iCol);
                    block = block + blockA * blockB;
                end
                
                % store current block in result block matrix
                setBlock(res, iRow, iCol, block);
            end
        end
    end

end % end methods

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

        if nCols < 20 && nRows < 50
            if isLoose
                fprintf('\n');
            end
            displayData(this);
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
    
    function displayData(this)
        % display data using different style for aternating blocks
        
        % get Block dimensions in each dimensions,
        % for the moment as a row vector of positive integers,
        % later as an instance of IntegerPartition
        dims1 = getBlockDimensions(this, 1);
        dims2 = getBlockDimensions(this, 2);
        
        % get BlockMatrix total size
        nRowBlocks = length(dims1);
        nColBlocks = length(dims2);
        
        % define printing styles for alterating blocs
        styleList = {[.7 0 0], '*blue'};
        
        % the style of first block, and of 'odd' blocks
        iStyle = 1;
        
        % iterate over block-rows
        for iBlock = 1:nRowBlocks
            
            % iterate over the rows of current row of blocks
            for iRow = 1:dims1(iBlock)
                
                % style of first block
                iBlockStyle = iStyle;
                
                % iterate over blocks of current block row
                for jBlock = 1:nColBlocks
                    % extract data of current row within current block
                    blockData = getBlock(this, iBlock, jBlock);
                    rowData = blockData(iRow, :);
                    
                    % the string to display
                    stringArray = formatArray(rowData);
                    string = [strjoin(stringArray, '   ') '   '];
                    
                    % choose appropriate style
                    style = styleList{iBlockStyle};
                    
                    % display in color
                    cprintf(style, string);
                    % alternate the style of next block(-column)
                    iBlockStyle = 3 - iBlockStyle;
                end
                
                fprintf('\n');
                
            end % end iteration of rows within block-row
            
            % alternate the style for next block-row
            iStyle = 3 - iStyle;
            
        end  % end block-row iteration
        
        function stringArray = formatArray(array)
            % convert a numerical array to a formatted cell array of strings
            stringArray = cell(size(array));
            
            for i = 1:numel(array)
                num = array(i);
                
                % choose formatting style
                if num < 1000
                    fmt = '%.4f';
                else
                    fmt = '%4.2e';
                end
                
                % ensure 9 digits are used, and align to the right
                stringArray{i} = sprintf('%9s', num2str(num, fmt));
            end
        end
    end % end displayData method
    
end % end display methods

end % end classdef

