require_relative "helper"

class TestConditional < MiniTest::Test
  # include the magic (setup and parse -> test method translation), see there
  include ParserHelper
    
  def test_conditional
    @string_input = <<HERE
if(0) 
  42
else
  667
end
HERE
    @parse_output = {:if=>"if", :conditional=>{:integer=>"0"}, 
    :if_true=>{:expressions=>[{:integer=>"42"}], :else=>"else"}, 
    :if_false=>{:expressions=>[{:integer=>"667"}], :end=>"end"}}
    @transform_output = Ast::ConditionalExpression.new(  Ast::IntegerExpression.new(0),
                  [Ast::IntegerExpression.new(42)], [Ast::IntegerExpression.new(667)])

    @parser = @parser.conditional
  end
end