classdef IntegerCompositionTest < matlab.unittest.TestCase
%INTEGERCOMPOSITIONTEST  One-line description here, please.
%
%   Class IntegerCompositionTest
%
%   Example
%   IntegerCompositionTest
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
    function testConstructor(testCase)
         
        % create the IntegerComposition object
        terms = [2 3 2];
        comp = IntegerComposition(terms);
        
        testCase.verifyEqual(terms, comp.terms);
    end

    function testCopyConstructor(testCase)
         
        % create the IntegerComposition object
        terms = [2 3 2];
        comp = IntegerComposition(terms);
        copy = IntegerComposition(comp);
        
        testCase.verifyEqual(comp, copy);
    end
    
    function testLength(testCase)
        
        % create the IntegerComposition object
        terms = [2 3 2];
        comp = IntegerComposition(terms);
        
        testCase.verifyEqual(3, length(comp));
    end
    
    function testEquals(testCase)
        
        % create the IntegerComposition object
        terms = [2 3 2];
        comp1 = IntegerComposition(terms);
        terms = [2 3 2];
        comp2 = IntegerComposition(terms);
        terms = [2 3 1];
        comp3 = IntegerComposition(terms);
        
        testCase.verifyTrue(comp1 == comp2);
        testCase.verifyTrue(comp2 == comp1);
        testCase.verifyFalse(comp1 == comp3);
    end

end % end methods

end % end classdef

