classdef PartitionCountDictionary < handle
%PARTITIONCOUNTDICTIONARY Singleton class for counting integer partition
%
%   output = PartitionCountDictionary(input)
%
%   Example
%   PartitionCountDictionary
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2015-07-17,    using Matlab 8.5.0.197613 (R2015a)
% Copyright 2015 INRA - Cepia Software Platform.

%% Properties
properties
    % the dictionary
    dict;
end % end properties

methods (Access = private)
    function this = PartitionCountDictionary(varargin)
        % private constructor to avoid initialisation
        disp('create dictionary');
        this.dict = containers.Map();
    end
end

methods (Static)
    function inst = getInstance()
        % Return the instance of dictionary storing partition counts
        persistent singleton
        if isempty(singleton)
            singleton = PartitionCountDictionary();
        end
        inst = singleton;
    end
end

methods
    function dict = getDictionary(this)
        dict = this.dict;
    end
end
end