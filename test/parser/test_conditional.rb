require_relative "helper"

class TestConditional < MiniTest::Test
  # include the magic (setup and parse -> test method translation), see there
  include ParserHelper
  
  def test_conditional_brackets
    check("(0)")
  end
  def test_conditional_no_brackets
    check("0")
  end
    
  def check cond
    input = <<HERE

  42
else
  667
end
HERE
    @string_input = "if #{cond} " + input.chop!
    @parse_output = {:if=>"if", :conditional=>{:integer=>"0"}, 
    :if_true=>{:expressions=>[{:integer=>"42"}], :else=>"else"}, 
    :if_false=>{:expressions=>[{:integer=>"667"}], :end=>"end"}}
    @transform_output = Ast::IfExpression.new(  Ast::IntegerExpression.new(0),
                  [Ast::IntegerExpression.new(42)], [Ast::IntegerExpression.new(667)])

    @parser = @parser.conditional
  end
end