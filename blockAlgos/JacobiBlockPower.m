classdef JacobiBlockPower < BlockPowerAlgo
%JACOBIBLOCKPOWER Jacobi algorithm for solving block power algorithms
%
%   Class JacobiBlockPower
%
%   Example
%   JacobiBlockPower
%
%   See also
%     GaussBlockPower

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2016-01-15,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2016 INRA - BIA-BIBS.


%% Properties
properties
    % the BlockMatrix representing the problem
    data;
    
    % the block vector representing the initial solution
    vector;

    % the type of block product to apply on (block)matrix and (block)vector
    % default is "uu"
    productType = 'uu';
    
    % the type of norm used to normalize vector. Default is L2 norm.
    normType = 2;
    
end % end properties


%% Constructor
methods
    function this = JacobiBlockPower(A, varargin)
        % Constructor for JacobiBlockPower class
        %
        % Usage:
        %   ALGO = JacobiBlockPower(MAT);
        %   ALGO = JacobiBlockPower(MAT, U0);
        %   MAT is a N-by-P BlockMatrix. U0 is an optional N-by-1
        %   BlockVector.
        %
        
        % check type of first argument
        if ~isa(A, 'BlockMatrix')
            error('First argument should be a block-matrix');
        end
        % TODO : check Sylvester condition
        this.data = A;
        
        
        if nargin > 1
            % use second input argument for initial vector
            var1 = varargin{1};
            if ~isa(var1, 'BlockMatrix')
                error('Second argument should be a block-matrix');
            end
            if blockSize(var1, 2) ~= 1
                error('Second argument should be a block-matrix with one block-column');
            end
            this.vector = varargin{1};
        else
            % create initial vector from matrix size
            n = size(A, 1);
            this.vector = rand(n, 1);
        end
    end

end % end constructors


%% Methods
methods
    function [q, resid] = iterate(this)
        % Performs a single iteration of the (Block-)Power Algorithm
        %
        % [Q, RESID] = iterate(ALGO)
        % where ALGO is a correctly initialized JacobiBlockPower algorithm,
        % returns the new value Q of the vector (as a BlockMatrix), and the
        % value of the residual (as a scalar).
        %
        
        % performs block-product on current vector
        qq = this.vector;
        q = blockProduct(this.data, qq, this.productType);
        
        % block normalization
        q = blockProduct_hs(1./blockNorm(q), q); 
        
        % compute residual
        resid = norm(blockNorm(q) - blockNorm(qq), this.normType); 
        
        % keep result for next iteration
        this.vector = q;
    end
    
    function lambda = eigenValue(this)
        % Computes the current eigen value
        q = blockProduct(this.data, this.vector, this.productType);
        lambda = norm(q, this.normType);
    end
end % end methods

end % end classdef

