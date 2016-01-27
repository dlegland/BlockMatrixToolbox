classdef PowerIterationValueDisplayListener < AlgoListener
%POWERITERATIONVALUEDISPLAYLISTENER Display current value of Power Iteration algo
%
%   Class PowerIterationValueDisplayListener
%
%   Example
%   PowerIterationValueDisplayListener
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
    % an handle to the axis to use for display
    axisHandle;
    
    % the set of values since algorithm started
    valueArray;
    
    % the title of the axis
    axisTitle = '';

end % end properties


%% Constructor
methods
    function this = PowerIterationValueDisplayListener(varargin)
    % Constructor for PowerIterationValueDisplayListener class
    
        % Initialize axis handle
        if ~isempty(varargin)
            var = varargin{1};
            if ~ishandle(var)
                error('First argument must be an axes handle');
            end
            
            if strcmp(get(var, 'Type'), 'axes')
                this.axisHandle = var;
            else
                this.axisHandle = gca;
            end
        else
            this.axisHandle = gcf;
        end
        
        if nargin > 1
            this.axisTitle = varargin{2};
        end

    end

end % end constructors


%% Methods
methods
    
    function algoIterated(this, src, event) %#ok<INUSD>
        
        % compute current eigen value
        value = norm(src.A * src.vector);
        
        % append current value to the value array
        this.valueArray = [this.valueArray; value];
        
        % display current list of values
        ax = this.axisHandle;
        nv = length(this.valueArray);
        plot(ax, 1:nv, this.valueArray, 'color', 'b', 'linewidth', 1);
        set(this.axisHandle, 'xlim', [0 nv]);
        
        % decorate
        if ~isempty(this.axisTitle)
            title(this.axisHandle, this.axisTitle);
        end
        
        % refresh display
        drawnow expose;
    end
    
end % end methods

end % end classdef

