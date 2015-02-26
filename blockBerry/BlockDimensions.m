classdef BlockDimensions < handle
%BlockDimensions  Store the block dimensions of a BlockMatrix data structure
%
%   Class BlockDimensions
%
%   Example
%   BD = BlockDimensions({[2 2], [2, 3, 2]});
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
        
        if ~iscell(varargin{1})
            error('input argument must be a cell array');
        end
        this.parts = varargin{1};
    end

end % end constructors


%% Methods
methods
    function dims = getBlockDimensions(this, dim)
        % Return the dimensions of the block in the specified dimension
        %
        % DIMS = getBlockDimensions(BD, IND)
        %
        dims = this.parts{dim};
    end
    
    function dim = getDimensionality(this)
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
                siz(i) = sum(this.parts{i});            
            end
        else
            dim = varargin{1};
            siz = zeros(1, length(dim));
            for i = 1:length(dim)
                siz(i) = sum(this.parts{dim(i)});
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
            n(i) = length(this.parts{1});
        end
    end
    
    function disp(this)
        % display the content of this BlockMatrix object
        
        % loose format: display more empty lines
        isLoose = strcmp(get(0, 'FormatSpacing'), 'loose');
        
        % get BlockMatrix total size
        dim = getSize(this);
        
        % Display information on block sizes in each dimension
        disp(sprintf('BlockDimensions object with %d dimensions', dim)); %#ok<DSPS>
        for i = 1:dim
            parts_i = this.parts{i};
            pattern = ['  parts dims %2d:' repmat(' %d', 1, length(part_i))];
            disp(sprintf(pattern, i, parts_i)); %#ok<DSPS>
        end
        
        if isLoose
            fprintf('\n');
        end
    end

end % end methods

end % end classdef

