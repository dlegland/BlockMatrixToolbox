classdef IntegerPartitionTest < matlab.unittest.TestCase
%INTEGERPARTITIONTEST  One-line description here, please.
%
%   Class IntegerPartitionTest
%
%   Example
%   IntegerPartitionTest
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2015-04-10,    using Matlab 8.4.0.150421 (R2014b)
% Copyright 2015 INRA - BIA-BIBS.


%% Properties
properties
end % end properties

%% Methods
methods (Test)
    function test_IntegerPartition_init(testCase)
         
        % create the IntegerPartition object
        terms = [2 3 2];
        part = IntegerPartition(terms);
        
        testCase.verifyEqual(terms, part.terms);
    end

    function test_IntegerPartition_copy(testCase)
         
        % create the IntegerPartition object
        terms = [2 3 2];
        part = IntegerPartition(terms);
        copy = IntegerPartition(part);
        
        testCase.verifyEqual(part, copy);
    end
    
    function test_length(testCase)
        
        % create the IntegerPartition object
        terms = [2 3 2];
        comp = IntegerPartition(terms);
        
        testCase.verifyEqual(3, length(comp));
    end
    
    function test_isUniform_true(testCase)
        
        % create the IntegerPartition object
        terms = [2 2 2];
        part = IntegerPartition(terms);
        
        testCase.verifyTrue(isUniform(part));
    end
    
    function test_isUniform_false(testCase)
        
        % create the IntegerPartition object
        terms = [2 3 2];
        part = IntegerPartition(terms);
        
        testCase.verifyFalse(isUniform(part));
    end
    
    function test_equals(testCase)
        
        % create the IntegerPartition object
        terms = [2 3 2];
        part1 = IntegerPartition(terms);
        terms = [2 3 2];
        part2 = IntegerPartition(terms);
        terms = [2 3 1];
        part3 = IntegerPartition(terms);
        
        testCase.verifyTrue(part1 == part2);
        testCase.verifyTrue(part2 == part1);
        testCase.verifyFalse(part1 == part3);
    end

end % end methods

end % end classdef

