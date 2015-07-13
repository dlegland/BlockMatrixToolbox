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
    
    function test_BlockMatrix(testCase)
        % test for constructor

        % create the BlockMatrix object
        data = reshape(1:28, [4 7]);
        parts = {[2 2], [2 3 2]};
        BM = BlockMatrix(data, parts);

        testCase.verifyEqual(isempty(BM), false);
    end
    
    function test_transpose(testCase)
        % test the transpose method
        
        data = reshape(1:28, [4 7]);
        parts = {[2 2], [2 3 2]};
        BM = BlockMatrix(data, parts);

        BM2 = BM';
        
        dim1 = size(BM2, 1);
        dim2 = size(BM2, 2);
        testCase.verifyEqual(dim1, 7);
        testCase.verifyEqual(dim2, 4);
    end
    
    function test_size(testCase)
        data = reshape(1:28, [4 7]);
        parts = {[2 2], [2 3 2]};
        BM = BlockMatrix(data, parts);
        
        siz = size(BM);
        testCase.verifyEqual(siz(1), 4);
        testCase.verifyEqual(siz(2), 7);
    end
    
    function test_size_two_outputs(testCase)
        data = reshape(1:28, [4 7]);
        parts = {[2 2], [2 3 2]};
        BM = BlockMatrix(data, parts);
        
        [siz1, siz2] = size(BM);
        testCase.verifyEqual(siz1, 4);
        testCase.verifyEqual(siz2, 7);
    end
    
    function test_cat_dir1(testCase)
        data = reshape(1:28, [4 7]);
        parts = {[2 2], [2 3 2]};
        BM = BlockMatrix(data, parts);

        BM2 = cat(1, BM, BM);

        dim1 = size(BM2, 1);
        dim2 = size(BM2, 2);
        testCase.verifyEqual(dim1, 8);
        testCase.verifyEqual(dim2, 7);
    end
    
    function test_cat_dir2(testCase)
        data = reshape(1:28, [4 7]);
        parts = {[2 2], [2 3 2]};
        BM = BlockMatrix(data, parts);

        BM2 = cat(2, BM, BM);

        dim1 = size(BM2, 1);
        dim2 = size(BM2, 2);
        testCase.verifyEqual(dim1, 4);
        testCase.verifyEqual(dim2, 14);
    end
    
    function test_horzcat(testCase)
        data = reshape(1:28, [4 7]);
        parts = {[2 2], [2 3 2]};
        BM = BlockMatrix(data, parts);

        BM2 = [BM BM];

        dim1 = size(BM2, 1);
        dim2 = size(BM2, 2);
        testCase.verifyEqual(dim1, 4);
        testCase.verifyEqual(dim2, 14);
    end
    
    function test_vertcat(testCase)
        data = reshape(1:28, [4 7]);
        parts = {[2 2], [2 3 2]};
        BM = BlockMatrix(data, parts);

        BM2 = [BM ; BM];

        dim1 = size(BM2, 1);
        dim2 = size(BM2, 2);
        testCase.verifyEqual(dim1, 8);
        testCase.verifyEqual(dim2, 7);
    end
    
    function test_times(testCase)
        data1 = reshape(1:28, [4 7]);
        parts1 = {[2 2], [2 3 2]};
        BM1 = BlockMatrix(data1, parts1);
        
        data2 = reshape(1:35, [7 5]);
        parts2 = {[2 3 2], [2 1 2]};
        BM2 = BlockMatrix(data2, parts2);
        
        data3 = data1 * data2;
        BM3 = BM1 * BM2;
        testCase.verifyEqual(data3, BM3.data, 'AbsTol', .1);
    end

    
    function test_subsref_parens(testCase)
        BM = BlockMatrix(reshape(1:28, [7 4])', [2 2], [2 3 2]);
        res = BM(2, 3);
        testCase.verifyEqual(10, res, 'AbsTol', .1);
    end
    
    function test_subsref_braces(testCase)
        BM = BlockMatrix(reshape(1:28, [7 4])', [2 2], [2 3 2]);
        res = BM{2, 3};
        testCase.verifyEqual([20 21; 27 28], res, 'AbsTol', .1);
    end

    function test_subsasgn_parens(testCase)
        BM = BlockMatrix(reshape(1:28, [7 4])', [2 2], [2 3 2]);
        BM(2, 3) = 4;
        testCase.verifyEqual(4, BM(2, 3));
    end
    
    function test_subsasgn_braces(testCase)
        BM = BlockMatrix(reshape(1:28, [7 4])', [2 2], [2 2 3]);
        BM{2, 3} = [1 2 3;4 5 6];
        testCase.verifyEqual(4, BM(4, 5));
    end

end

end % end classdef

