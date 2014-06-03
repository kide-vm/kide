require_relative "helper"

# some cases that fail, and fail badly.

# These make the parse "hang", ie there is some looping going on in the parser, but not straight down, as theey don't
#    throw even StackError

# Annoyingly, the user error is quite small, a missing bracket or things

class TestFails < MiniTest::Test
  # include the magic (setup and parse -> test method translation), see there
  include ParserHelper
  
  def test_fail_function
    @string_input    = <<HERE
class Foo
  def bar
    4
  end
end
HERE
    @parse_output = nil
    @transform_output = nil
    @parser = @parser.root
  end
end
