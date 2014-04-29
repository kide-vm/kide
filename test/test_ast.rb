require_relative "helper"

# Please read note in test_parser

require_relative 'helper'

class TestAst < MiniTest::Test

  def setup
    @parser    = Parser::Composed.new
    @transform = Parser::Transform.new
  end

  def check
    syntax    = @parser.parse(@string_input)
    tree      = @transform.apply(syntax)
    # puts tree.inspect
    assert_equal @transform_output , tree
  end
    
  def test_function_definition
    @string_input    = <<HERE
def foo(x) 
  5
end
HERE
    @transform_output = Parser::FunctionExpression.new('foo', 
                  [Parser::NameExpression.new('x')], 
                  [Parser::IntegerExpression.new(5)])
    @parser = @parser.function_definition
    check
  end
  def test_function_assignment
    @string_input    = <<HERE
def foo(x) 
 abba = 5 
end
HERE
    @transform_output = Parser::FunctionExpression.new( "foo", [Parser::NameExpression.new("x")],
                       [Parser::AssignmentExpression.new( "abba", Parser::IntegerExpression.new(5) ) ])
    check
  end
end