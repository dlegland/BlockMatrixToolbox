classdef BlockDiagonalTest < matlab.unittest.TestCase
%BLOCKDIAGONALTEST Test Suite for BlockDiagonal class
%
%   Class BlockDiagonalTest
%
%   Example
%   BlockDiagonalTest
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2015-05-04,    using Matlab 8.4.0.150421 (R2014b)
% Copyright 2015 INRA - BIA-BIBS.



%% Methods
methods (Test)
    function test_BlockDiagonal(testCase)
        % test for constructor

        % create the BlockMatrix object
        BD = BlockDiagonal({rand(2, 3), rand(2, 2), rand(1, 2)});
        
        siz = [5 7];
        testCase.verifyEqual(siz, size(BD));
    end
    
    function test_BlockDiagonal_Copy(testCase)
        % test for constructor

        % create the BlockMatrix object
        BD0 = BlockDiagonal({rand(2, 3), rand(2, 2), rand(1, 2)});
        BD = BlockDiagonal(BD0);
        
        siz = [5 7];
        testCase.verifyEqual(siz, size(BD));
    end
    
    function test_diagonalBlock(testCase)
        block1 = [1 2 3;4 5 6];
        block2 = [7 8 ; 9 10];
        block3 = [11 ; 12];
        BD = BlockDiagonal({block1, block2, block3});
        
        testCase.verifyEqual(block1, diagonalBlock(BD, 1));
        testCase.verifyEqual(block2, diagonalBlock(BD, 2));
        testCase.verifyEqual(block3, diagonalBlock(BD, 3));
    end
        
    function test_diagonalBlocks(testCase)
        block1 = [1 2 3;4 5 6];
        block2 = [7 8 ; 9 10];
        block3 = [11 ; 12];
        BD = BlockDiagonal({block1, block2, block3});
        
        blocks = diagonalBlocks(BD);
        testCase.verifyEqual(block1, blocks{1});
        testCase.verifyEqual(block2, blocks{2});
        testCase.verifyEqual(block3, blocks{3});
    end
    
end % end methods

end % end classdef

