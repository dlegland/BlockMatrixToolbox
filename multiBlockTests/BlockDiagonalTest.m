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
    function testConstructor(testCase)
        % test for constructor

        % create the BlockMatrix object
        BD = BlockDiagonal({rand(2, 3), rand(2, 2), rand(1, 2)});
        
        siz = [5 7];
        testCase.verifyEqual(siz, size(BD));
    end
    
    function testCopyConstructor(testCase)
        % test for constructor

        % create the BlockMatrix object
        BD0 = BlockDiagonal({rand(2, 3), rand(2, 2), rand(1, 2)});
        BD = BlockDiagonal(BD0);
        
        siz = [5 7];
        testCase.verifyEqual(siz, size(BD));
    end
    
end % end methods

end % end classdef

