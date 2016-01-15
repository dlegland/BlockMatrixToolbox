classdef PowerIterationAlgo < handle
%POWERITERATIONALGO Demo of Algorithm class for solving power iteration
%
%   Class PowerIterationAlgo
%
%   Example
%     % create an algorithm and iterate it   
%     MAT = rand(5,5);
%     ALGO = PowerIterationAlgo(MAT);
%     for i = 1:10, iterate(ALGO); end
%     lambda = norm(ALGO.u);
%
%     % uses listener to monitor algorithm progression
%     mat = rand(5,5);
%     algo = PowerIterationAlgo(mat);
%     figure;
%     listener = PowerIterationValueDisplayListener(gca);
%     addAlgoListener(algo, listener);
%     for i = 1:50, iterate(algo); end
%     lambda = norm(algo.vector);
%
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2016-01-15,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2016 INRA - BIA-BIBS.


%% Properties
properties
    % the working matrix
    A;
    
    % the current vector. 
    % Can be initialised, and will be updated at each  iteration.
    vector;
    
end % end properties

%% Events
% these events are used to manage algorithm progression
events
    % notified when the an iteration is run
    AlgoIterated
end

%% Constructor
methods
    function this = PowerIterationAlgo(A, varargin)
        % Constructor for PowerIterationAlgo class
        %
        % Usage:
        %   ALGO = PowerIterationAlgo(MAT);
        %   ALGO = PowerIterationAlgo(MAT, U0);
        %
        
        this.A = A;
        if nargin > 1
            % use second input argument for initial vector
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
    function [lambda, ui] = iterate(this, varargin)
        % performs a single iteration, update state, and returns current state
        
        % update vector
        ui = this.A * this.vector;
        
        % compute norm (eigen value) and normalize eigen vector
        lambda = norm(ui);
        ui = ui / lambda;
        
        % update current state
        this.vector = ui;
        
        % notify iteration
        this.notify('AlgoIterated');
    end
    
end % end methods

%% Listeners management
methods
    function addAlgoListener(this, listener)
        %Adds an AlgoListener to this optimizer
        %
        % usage: 
        %   addOptimizationListener(OPTIM, LISTENER);
        %   OPTIM is an instance of Optimizer
        %   LISTENER is an instance of OptimizationListener
        %   The listener will listen the events of type:
        %    OptimizationStarted, 
        %    OptimizationIterated,
        %    OptimizationTerminated 
        
        % Check class of input
        if ~isa(listener, 'AlgoListener')
            error('Input argument should be an instance of AlgoListener');
        end
        
        % link function handles to events
        this.addlistener('AlgoIterated', @listener.algoIterated);
    end
end

end % end classdef

