Parsing
-------

Some sanity is emerging in the testing of parsers 
    (Parsers are fiddly in respect to space and order, small changes may and do have unexpected effects)

Parsing is a two step process with parslet:
  - parse takes an input and outputs hashes/arrays with basic types
  - tramsform takes the output of parse and generates an ast (as specified by the transformation)

A test tests both phases seperately and again together.
Each test must thus specify (as instance variables):
- the string input
- the parse output
- the transform output


For any functionality that we want to work (ie test), there are actually three tests, with the _same_ name
One in each of the parser/transform/ast classes
Parser test that the parser parses and thet the output is correct. Rules are named and and boil down to 
       hashes and arrays with lots of symbols for the names the rules (actually the reults) were given
Transform test really just test the tranformation. They basically take the output of the parse
        and check that correct Ast classes are produced
Ast   tests both steps in one. Ie string input to ast classes output

All threee classes are layed out quite similarly in that they use a check method and 
each test assigns @input and @expected which the check methods then checks
The check methods have a pust in it (to be left) which is very handy for checking
also the output of parser.check can actually be used as the input of transform

Repeat: For every test in parser, there should be one in transform and ast
                                 The test in transform should use the output of parser as input
                                 The test in ast should expect the same result as transform
