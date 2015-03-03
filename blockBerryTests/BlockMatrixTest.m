classdef BlockMatrixTest < matlab.unittest.TestCase
%BLOCKMATRIXTEST Test Suite for BlockMatrix class
%
%   Class BlockMatrixTest
%
%   Example
%   run(BlockMatrixTest);
%
%   See also
%   BlockMatrix

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2015-02-27,    using Matlab 8.4.0.150421 (R2014b)
% Copyright 2015 INRA - BIA-BIBS.

%% Test Functions
methods (Test)
    
    function testBlockMatrix(testCase)
        % test for constructor

        % create the BlockMatrix object
        data = reshape(1:28, [4 7]);
        parts = {[2 2], [2 3 2]};
        BM = BlockMatrix(data, parts);

        testCase.verifyEqual(isempty(BM), false);
    end
    
    function testTranspose(testCase)
        % test the transpose method
        
        data = reshape(1:28, [4 7]);
        parts = {[2 2], [2 3 2]};
        BM = BlockMatrix(data, parts);

        BM2 = BM';
        
        dim1 = getSize(BM2, 1);
        dim2 = getSize(BM2, 2);
        testCase.verifyEqual(dim1, 7);
        testCase.verifyEqual(dim2, 4);
    end
    
    function testCatDir1(testCase)
        data = reshape(1:28, [4 7]);
        parts = {[2 2], [2 3 2]};
        BM = BlockMatrix(data, parts);

        BM2 = cat(1, BM, BM);

        dim1 = getSize(BM2, 1);
        dim2 = getSize(BM2, 2);
        testCase.verifyEqual(dim1, 8);
        testCase.verifyEqual(dim2, 7);
    end
    
    function testCatDir2(testCase)
        data = reshape(1:28, [4 7]);
        parts = {[2 2], [2 3 2]};
        BM = BlockMatrix(data, parts);

        BM2 = cat(2, BM, BM);

        dim1 = getSize(BM2, 1);
        dim2 = getSize(BM2, 2);
        testCase.verifyEqual(dim1, 4);
        testCase.verifyEqual(dim2, 14);
    end
    
    function testHorzcat(testCase)
        data = reshape(1:28, [4 7]);
        parts = {[2 2], [2 3 2]};
        BM = BlockMatrix(data, parts);

        BM2 = [BM BM];

        dim1 = getSize(BM2, 1);
        dim2 = getSize(BM2, 2);
        testCase.verifyEqual(dim1, 4);
        testCase.verifyEqual(dim2, 14);
    end
    
    function testVertcat(testCase)
        data = reshape(1:28, [4 7]);
        parts = {[2 2], [2 3 2]};
        BM = BlockMatrix(data, parts);

        BM2 = [BM ; BM];

        dim1 = getSize(BM2, 1);
        dim2 = getSize(BM2, 2);
        testCase.verifyEqual(dim1, 8);
        testCase.verifyEqual(dim2, 7);
    end
end

end % end classdef

