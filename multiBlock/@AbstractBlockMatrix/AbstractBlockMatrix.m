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
% Methods in this cell are declared for implementation in sub-classes

methods (Abstract)
    % Returns the content of this block-matrix as a matlab array
    matrix = getMatrix(this)
    
    % Return the dimensions of the block in the specified dimension
    dims = blockDimensions(this, dim)
    
    % Return the number of dimensions of this block matrix (usually 2)
    dim = dimensionality(this)
       
    % Return the total number of blocks in this block matrix
    n = blockNumber(this, varargin)
    
    % Return the number of blocks in each dimension
    n = getBlockNumbers(this)
    
    % Return the number of blocks in each dimension
    n = blockSize(this, varargin)
    
    % Returns the block content at a given position
    block = getBlock(this, row, col)
    
    % Updates the block content at a given position
    block = setBlock(this, row, col, blockContent)

end % end abstract methods


%% Computation Methods
% Some methods are performed, that only relies on abstract methods.

methods
    function res = blockProduct(this, that, type)
        % Compute newly defined block-matrix product of two block-matrices
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

            case 's'
                % scalar product along blocks
                % we need one scalar
                switch lower(type(2))
                    case 's'
                        res = blockProduct_ss(this, that);
                    case 'h'
                        res = blockProduct_sh(this, that);
                    case 'u'
                        res = blockProduct_su(this, that);
                    case 'k'
                        res = blockProduct_sk(this, that);
                end
                
            case 'h'
                % hadamard product along blocks
                % we need: same number of blocks in each direction
                switch lower(type(2))
                    case 's'
                        res = blockProduct_hs(this, that);
                    case 'h'
                        res = blockProduct_hh(this, that);
                    case 'u'
                        res = blockProduct_hu(this, that);
                    case 'k'
                        res = blockProduct_hk(this, that);
                end
                
            case 'u'
                % usual product along blocks
                % we need: blockdims1(2) == blockdims2(1)
                switch lower(type(2))
                    case 's'
                        res = blockProduct_us(this, that);
                    case 'h'
                        res = blockProduct_uh(this, that);
                    case 'u'
                        res = blockProduct_uu(this, that);
                    case 'k'
                        res = blockProduct_uk(this, that);
                end
                
            case 'k'
                % kroenecker product along blocks
                % we need: (what ?)
                switch lower(type(2))
                    case 's'
                        res = blockProduct_sk(this, that);
                    case 'h'
                        res = blockProduct_hk(this, that);
                    case 'u'
                        res = blockProduct_uk(this, that);
                    case 'k'
                        error('The ''kk''-type product is not implemented');
                end
                
        end
    end
    
    function nr = blockRows(this)
        % return the number of block rows
        %
        % Example:
        % BM = BlockMatrix(reshape(1:28, [7 4])', [2 2], [2 3 2]);
        % blockRows(BM)
        % ans = 
        %     2
        %
        % See also
        %    blockSize, blockCols
        
        nr = blockSize(this, 1);
    end
    
    function nc = blockCols(this)
        % return the number of block columns
        %
        % Example:
        % BM = BlockMatrix(reshape(1:28, [7 4])', [2 2], [2 3 2]);
        % blockCols(BM)
        % ans = 
        %     3
        %
        % See also
        %    blockSize, blockRows
        
        nc = blockSize(this, 2);
    end
end


%% Test block partition types

methods
    function tf = isOneBlock(this)
        % Check if a BlockMatrix is divided in one block in each direction
        tf = all(blockSize(this) == [1 1]);
    end
    
    function tf = isScalarBlock(this)
        % Check if a BlockMatrix is divided in 1-1 blocks in each direction
        tf = all(blockSize(this) == size(this));
    end
    
    function tf = isUniformBlock(this)
        % Check if a BlockMatrix is divided in blocks with all the same size
        unif1 = isUniform(blockDimensions(this, 1));
        unif2 = isUniform(blockDimensions(this, 2));
        tf = unif1 && unif2;
    end
    
    function tf = isVectorBlock(this)
        % Check if a BlockMatrix is divided in 1 block in at least one direction
        tf = any(blockSize(this) == 1);
    end
end


%% Overload some arithmetic methods

methods
    function res = norm(this, varargin)
        % Computes the norm of this BlockMatrix
        %
        % NORM = norm(BM)
        % returns the norm as a scalar
        % 
        res = norm(getMatrix(this), varargin{:});
    end

    function res = plus(this, that)
        % addition of two block-matrices
        % 
        % usage:
        %   X = A + B
        
        sizA = size(this);
        sizB = size(that);
        if any(sizA ~= sizB) && ~(prod(sizA)==1 || prod(sizB)==1)
            error('Both inputs must have same size, or one must be scalar');
        end
        
        dataA = this;
        dataB = that;
        parent = [];
        
        if isa(this, 'AbstractBlockMatrix')
            dataA = this.data;
            parent = this;
        end
        
        if isa(that, 'AbstractBlockMatrix')
            dataB = that.data;
            parent = that;
        end
       
        % compute data of resulting matrix
        dataX = dataA + dataB;
        
        % create resulting object
        dimsX = blockDimensions(parent);
        res = BlockMatrix(dataX, dimsX);
    end
    
    function res = minus(this, that)
        % subtraction of two block-matrices
        % 
        % usage:
        %   X = A - B
        
        sizA = size(this);
        sizB = size(that);
        if any(sizA ~= sizB) && ~(prod(sizA)==1 || prod(sizB)==1)
            error('Both inputs must have same size, or one must be scalar');
        end
        
        dataA = this;
        dataB = that;
        parent = [];
        
        if isa(this, 'AbstractBlockMatrix')
            dataA = this.data;
            parent = this;
        end
        
        if isa(that, 'AbstractBlockMatrix')
            dataB = that.data;
            parent = that;
        end
       
        % compute data of resulting matrix
        dataX = dataA - dataB;
        
        % create resulting object
        dimsX = blockDimensions(parent);
        res = BlockMatrix(dataX, dimsX);
    end
    
    function res = times(this, that)
        % subtraction of two block-matrices
        % 
        % usage:
        %   X = A .* B
        sizA = size(this);
        sizB = size(that);
        if any(sizA ~= sizB) && ~(prod(sizA)==1 || prod(sizB)==1)
            error('Both inputs must have same size, or one must be scalar');
        end
        
        dataA = this;
        dataB = that;
        parent = [];
        
        if isa(this, 'AbstractBlockMatrix')
            dataA = this.data;
            parent = this;
        end
        
        if isa(that, 'AbstractBlockMatrix')
            dataB = that.data;
            parent = that;
        end
       
        % compute data of resulting matrix
        dataX = dataA .* dataB;
        
        % create resulting object
        dimsX = blockDimensions(parent);
        res = BlockMatrix(dataX, dimsX);
    end
    
    function res = rdivide(this, that)
        % division of two block-matrices
        % 
        % usage:
        %   X = A ./ B
        
        sizA = size(this);
        sizB = size(that);
        if any(sizA ~= sizB) && ~(prod(sizA)==1 || prod(sizB)==1)
            error('Both inputs must have same size, or one must be scalar');
        end
        
        dataA = this;
        dataB = that;
        parent = [];
        
        if isa(this, 'AbstractBlockMatrix')
            dataA = this.data;
            parent = this;
        end
        
        if isa(that, 'AbstractBlockMatrix')
            dataB = that.data;
            parent = that;
        end
       
        % compute data of resulting matrix
        dataX = dataA ./ dataB;
        
        % create resulting object
        dimsX = blockDimensions(parent);
        res = BlockMatrix(dataX, dimsX);
    end
    
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
        if size(dimsA, 2) ~= size(dimsB, 1)
            error('number of columns of first matrix (%d) should match number of rows of second matrix (%d)', ...
                size(dimsA, 2), size(dimsB, 1));
        end
        if blockSize(dimsA, 2) ~= blockSize(dimsB, 1)
            error('number of block columns of first matrix (%d) should match number of block rows of second matrix (%d)', ...
                blockSize(dimsA, 2), blockSize(dimsB, 1));
        end

        % compute block dimension of the resulting block-matrix
        dimsC = BlockDimensions([dimsA.parts(1) dimsB.parts(2)]);
        
        % allocate memory for result
        res = BlockMatrix.zeros(dimsC);

        % number of blocks to iterate
        nBlocks = blockSize(dimsA, 2);

        for iRow = 1:blockSize(dimsA, 1)
            for iCol = 1:blockSize(dimsB, 2)
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
    function reveal(this)
        % Reveal the structure of the block-Matrix in a condensed way
        
        % extract block partitions in each direction
        parts1 = blockDimensions(this, 1);
        parts2 = blockDimensions(this, 2);
        
        pattern = ['   ' repmat('%3d', 1, length(parts2)) '\n'];
        fprintf(pattern, parts2.terms);
        
        pattern = ['%3d' repmat('  +', 1, length(parts2)) '\n'];
        for iRow = 1:length(parts1)
            fprintf(pattern, parts1(iRow));
        end
    end
    
    function disp(this)
        % Display the content of this BlockMatrix object
        
        % loose format: display more empty lines
        isLoose = strcmp(get(0, 'FormatSpacing'), 'loose');
        
        % get BlockMatrix total size
        dim = size(this);
        nRows = dim(1);
        nCols = dim(2);
        
        % Display information on block sizes
        className = class(this);
        disp(sprintf('%s object with %d rows and %d columns', className, nRows, nCols)); %#ok<DSPS>
        parts1 = blockPartition(this.dims, 1);
        disp(sprintf('  row dims: %s', formatParts(parts1))); %#ok<DSPS>
        parts2 = blockPartition(this.dims, 2);
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
        nRowBlocks = blockSize(this.dims, 1);
        nColBlocks = blockSize(this.dims, 2);
        
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
        dims1 = blockDimensions(this, 1);
        dims2 = blockDimensions(this, 2);
        
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

