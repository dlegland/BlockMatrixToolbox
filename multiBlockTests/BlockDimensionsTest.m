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


%% Test Functions for testing nature of block partitions
methods (Test)
    function test_isOneBlock_true(testCase)
        BD = BlockDimensions({4, 7});
        testCase.verifyTrue(isOneBlock(BD));
    end

    function test_isOneBlock_false(testCase)
        BD = BlockDimensions({ones(1, 4), ones(1, 7)});
        testCase.verifyFalse(isOneBlock(BD));
    end

    function test_isScalarBlock_true(testCase)
        BD = BlockDimensions({[1 1], [1 1 1 1]});
        testCase.verifyTrue(isScalarBlock(BD));
    end

    function test_isScalarBlock_false(testCase)
        BD = BlockDimensions({[2 2], [2 3 2]});
        testCase.verifyFalse(isScalarBlock(BD));
    end

    function test_isUniformBlock_true(testCase)
        BD = BlockDimensions({[2 2], [3 3]});
        testCase.verifyTrue(isUniformBlock(BD));
    end

    function test_isUniformBlock_false(testCase)
        BD = BlockDimensions({[2 2], [4 2]});
        testCase.verifyFalse(isUniformBlock(BD));
    end

    function test_isVectorBlock_true(testCase)
        BD = BlockDimensions({1, [2 2 2]});
        testCase.verifyTrue(isVectorBlock(BD));
    end

    function test_isVectorBlock_false(testCase)
        BD = BlockDimensions({[2 2], [4 2]});
        testCase.verifyFalse(isVectorBlock(BD));
    end

end

end % end classdef

