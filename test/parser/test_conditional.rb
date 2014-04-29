require_relative "helper"

class TestConditional < MiniTest::Test
  # include the magic (setup and parse -> test method translation), see there
  include ParserHelper
    
  def test_conditional
    @string_input = <<HERE
if (0) 
  42
else
  667
end
HERE
    @parse_output = { :conditional => { :integer => "0"}, 
                  :if_true => {  :expressions => [ { :integer => "42" } ] } , 
                  :if_false => { :expressions => [ { :integer => "667" } ] } }
    @transform_output = Parser::ConditionalExpression.new(  Parser::IntegerExpression.new(0),
                  [Parser::IntegerExpression.new(42)], [Parser::IntegerExpression.new(667)])

    @parser = @parser.conditional
  end
  
end