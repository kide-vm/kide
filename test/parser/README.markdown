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

Test are grouped by functionality into cases and define methods parse_*
Test cases must include ParserHelper, which includes the magic to write the 3 test methods for each 
parse method. See test_basic ofr easy example.
