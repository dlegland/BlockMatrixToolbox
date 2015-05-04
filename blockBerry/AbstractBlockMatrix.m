classdef AbstractBlockMatrix < handle
%ABSTRACTBLOCKMATRIX  Utility class parent of BlockMatrix and BlockDiagonal 
%
%   Class AbstractBlockMatrix
%
%   Example
%     data = reshape(1:28, [7 4])';
%     BM = BlockMatrix(data, [1 2 1], [2 3 2]);
%
%   See also
%     BlockMatrix, BlockDiagonal
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2015-04-22,    using Matlab 8.4.0.150421 (R2014b)
% Copyright 2015 INRA - BIA-BIBS.


% no properties are defined, nor constructor

%% Interface Methods
% Methods in this bloc are declared for implementation in sub-classes

methods (Abstract)
    matrix = getMatrix(this)
    % Returns the content of this block-matrix as a matlab array
    
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
    
    block = getBlock(this, row, col)
    % Returns the block content at a given position
    
    block = setBlock(this, row, col, blockContent)
    % Updates the block content at a given position

end % end abstract methods


%% Computation Methods
% Some methods are performed, that only relies on abstract methods.

methods
    function res = blockProduct(this, that, type)
        % compute newly defined block-matrix product of two block-matrices
        %
        % RES = blockProduct(BM1, BM1, TYPE)
        % BM1 and BM2 are two block matrices, and TYPE is a string
        % representing the type of blck product, for eaxmple 'uu', 'hh',
        % 'ks'...
        %
        % Some conditions exist on the block-dimensions of input block
        % matrices, depending on the type of block-product applied.
        %
        % Example
        %   BM = BlockMatrix(reshape(1:28, [4 7]), [1 2 1], [2 3 2]);
        %   res = blockProduct(BM, BM', 'uu');
        %   disp(res)
        %   BlockMatrix object with 4 rows and 4 columns
        %     row dims: 2 2
        %     col dims: 2 2
        % 
        %    140.0000    336.0000    532.0000    728.0000   
        %    336.0000    875.0000    1.41e+03    1.95e+03   
        %    532.0000    1.41e+03    2.30e+03    3.18e+03   
        %    728.0000    1.95e+03    3.18e+03    4.40e+03   

        
        % check validity of TYPE argument
        if ~ischar(type)
            error('the TYPE argument must be a char array');
        end
        validTypes = {...
            'uu', 'uh', 'uk', 'us', ...
            'hu', 'hh', 'hk', 'hs', ...
            'ku', 'kh', 'kk', 'ks', ...
            'su', 'sh', 'sk', 'ss'};
        if ~ismember(type, validTypes)
            error('the TYPE argument is not a valid string');
        end
        
        switch lower(type(1))
            case 'u'
                % usual product along blocks
                % we need: blockdims1(2) == blockdims2(1)
                
                switch lower(type(2))
                    case 'u'
                        res = blockProduct_uu(this, that);
                    case 'h'
                        error('Block Product type "uh" not yet implemented');
                    case 'k'
                        error('Block Product type "uk" not yet implemented');
                    case 's'
                        error('Block Product type "us" not yet implemented');
                end
                
            case 'h'
                % hadamard product along blocks
                % we need: same number of blocks in each direction
                
                switch lower(type(2))
                    case 'u'
                        error('Block Product type "hu" not yet implemented');
                    case 'h'
                        res = blockProduct_hh(this, that);
                    case 'k'
                        error('Block Product type "hk" not yet implemented');
                    case 's'
                        error('Block Product type "hs" not yet implemented');
                end
                
            case 'k'
                % kroenecker product along blocks
                % we need: (what ?)
                
                switch lower(type(2))
                    case 'u'
                        error('Block Product type "ku" not yet implemented');
                    case 'h'
                        error('Block Product type "kh" not yet implemented');
                    case 'k'
                        error('Block Product type "kk" not yet implemented');
                    case 's'
                        error('Block Product type "ks" not yet implemented');
                end
                
            case 's'
                % scalar product along blocks
                % we need one scalar
                
                switch lower(type(2))
                    case 'u'
                        error('Block Product type "su" not yet implemented');
                    case 'h'
                        error('Block Product type "sh" not yet implemented');
                    case 'k'
                        error('Block Product type "sk" not yet implemented');
                    case 's'
                        error('Block Product type "ss" not yet implemented');
                end
        end
        
    end
    
    function res = blockProduct_uu(this, that)
        % compute 'uu'-type block matrix product
        % It corresponds to classical matrix product
        res = mtimes(this, that);
    end
    
    function res = blockProduct_hh(this, that)
        % compute 'hh'-type block matrix product
        % It corresponds to hadamard product along blocks, and hadamard
        % product within blocks
        
        % check conditions on dimensions
        dimsA = getBlockDimensions(this);
        dimsB = getBlockDimensions(that);
        if dimsA ~= dimsB
            error('Block dimensions of block matrices must be the same');
        end
        
        % create empty result with same dims
        res = BlockMatrix.zeros(dimsA);
        
        % iterate over blocks
        for iBlock = 1:getBlockNumber(dimsA, 1)
            for jBlock = 1:getBlockNumber(dimsA, 2)
                % extract blocks of the two input block matrices
                blockA = getBlock(this, iBlock, jBlock);
                blockB = getBlock(that, iBlock, jBlock);
                
                % compute 'h'-product of blocks
                resBlock = blockA .* blockB;
                
                % assign result
                setBlock(res, iBlock, jBlock, resBlock);
            end
        end
    end
    
end


%% Overload some arithmetic methods

methods
    function res = mtimes(this, that)
        % Multiplies two instances of BlockMatrix
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

        % compute block dimension of the resulting block-matrix
        dimsC = BlockDimensions([dimsA.parts(1) dimsB.parts(2)]);
        
        % allocate memory for result
        res = BlockMatrix.zeros(dimsC);

        % number of blocks to iterate
        nBlocks = getBlockNumber(dimsA, 2);

        for iRow = 1:getBlockNumber(dimsA, 1)
            for iCol = 1:getBlockNumber(dimsB, 2)
                % Compute block (iRow, iCol), by iterating over i-th row of
                % first matrix, and j-th column of second matrix
                
                % allocate memory for current result block
                block = zeros([dimsA{1}(iRow) dimsB{2}(iCol)]);
                
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

%% Overload indexing methods
methods
    function varargout = subsref(this, subs)
        % Override subsref for Block Matrices objects
        %
        % BM = BlockMatrix(reshape(1:28, [7 4])', [2 2], [2 3 2])
        % BM(2, 3)
        % ans =
        %     10
        % BM{2, 3}
        % ans = 
        %    20   21
        %    27   28
        %
        
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
            
        elseif strcmp(type, '()')
            % Process parens indexing -> return elements of data matrix
            matrix = getMatrix(this);
            varargout{1} = subsref(matrix, subs);
            
        elseif strcmp(type, '{}')
            % Process braces indexing -> return block at specified position
            ns = length(s1.subs);
            if ns == 2
                % returns integer partition of corresponding dimension
                blockRow = s1.subs{1};
                blockCol = s1.subs{2};
                varargout{1} = getBlock(this, blockRow, blockCol);
            else
                error('Requires two indices for identifying blocks');
            end
        end
    end
end

%% Display methods

methods
    function disp(this)
        % Display the content of this BlockMatrix object
        
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
        % Display inner blocks of block matrix object
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
        % Display data using different style for aternating blocks
        
        % get Block dimensions in each dimensions,
        % for the moment as a row vector of positive integers,
        % later as an instance of IntegerPartition
        dims1 = getBlockDimensions(this, 1);
        dims2 = getBlockDimensions(this, 2);
        
        % get BlockMatrix total size
        nRowBlocks = length(dims1);
        nColBlocks = length(dims2);
        
        % define printing styles for alterating blocs
        styleList = {'*blue', [.7 0 0]};
        
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
            % Convert a numerical array to a formatted cell array of strings
            stringArray = cell(size(array));
            
            for i = 1:numel(array)
                num = array(i);
                
                % choose formatting style
                if num == 0 || round(num) == num
                    fmt = '%g';
                elseif abs(num) < 1e4 && abs(num) > 1e-2
                    fmt = '%.3f';
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

