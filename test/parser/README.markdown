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

Magic
-----

Test are grouped by functionality into cases (classes) and define methods test_*
Test cases must include ParserHelper, which includes the magic to write the 3 test methods for each 
test method. See test_basic for easy example.

Example:

  def test_number
    @string_input    = '42 '
    @test_output = {:integer => '42'}
    @transform_output = Parser::IntegerExpression.new(42)
    @parser = @parser.integer
  end

The first three lines define the data as described above.
The last line tells the parser what to parse. This is off couse only needed when a non-root rule is tested
and should be left out if possible.

As can be seen, there are no asserts. All asserting is done by the created methods, which call 
the check_* methods in helper.