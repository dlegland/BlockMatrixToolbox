classdef BlockDimensionsTest < matlab.unittest.TestCase
%BLOCKDIMENSIONSTEST Test Suite for BlockDimensions class
%
%   Class BlockDimensionsTest
%
%   Example
%   BlockDimensionsTest
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2015-04-30,    using Matlab 8.4.0.150421 (R2014b)
% Copyright 2015 INRA - BIA-BIBS.


%% Methods
methods (Test)
    function test_ConstructorInit(testCase)
        dims = BlockDimensions({[2 2], [2 3 2]});
        
        dims1 = getBlockDimensions(dims, 1);
        testCase.verifyEqual(2, length(dims1));
        testCase.verifyEqual(2, dims1(1));
        testCase.verifyEqual(2, dims1(2));
    end
    
    function test_subsref(testCase)
        dims = BlockDimensions({[1 2 1], [3 4]});
        dims1 = dims{1};
        exp = getBlockDimensions(dims, 1);
        testCase.verifyEqual(exp, dims1);
    end

end % end methods

end % end classdef

