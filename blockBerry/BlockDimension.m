classdef BlockDimension < handle
%BLOCKDIMENSION  Store the block dimensions of a BlockMatrix data structure
%
%   Class BlockDimension
%
%   Example
%   BD = BlockDimension({[2 2], [2, 3, 2]});
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
    function this = BlockDimension(varargin)
        % Constructor for BlockDimension class
        %
        %   BD = BlockDimension(PARTS);
        %   PARTS is a cell array, containing for each dimension the sizes
        %   of the blocks in this dimension.
        % 
        %   Example
        %   BD = BlockDimension({[2 2], [2 3 2]});
        %   Creates a BlockDimension object for a BlockMatrix, that will be
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
        % return the dimensions of the block in the specified dimension
        %
        % DIMS = getBlockDimensions(BD, IND)
        %
        dims = this.parts{dim};
    end
    
    function dim = getDimensionality(this)
        % Return the number of dimensions of this block matrix
        dim = length(this.parts);
    end
    
    function siz = getSize(this, varargin)
        % Return the size in each direction of this block matrix object
        %
        % SIZ = getSize(BD)
        % Returns the size as a 1-by-ND row vector, where ND is the
        % dimensionality of this BlockDimension.
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
    
    function n = getBlockNumber(this)
        % return the total number of blocks in this block matrix
        %
        % N = getBlockNumber(BD);
        %
        n = 1;
        for i = 1:length(this.parts)
            n = n * length(this.parts{i});
        end
    end
    
    function disp(this)
        % display the content of this BlockMatrix object
        
        % loose format: display more empty lines
        isLoose = strcmp(get(0, 'FormatSpacing'), 'loose');
        
        % get BlockMatrix total size
        dim = getSize(this);
        
        % Display information on block sizes in each dimension
        disp(sprintf('BlockDimension object with %d dimensions', dim)); %#ok<DSPS>
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

