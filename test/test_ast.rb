require_relative "helper"

# Please read note in test_parser

require_relative 'helper'

class TestAst < MiniTest::Test

  def setup
    @parser    = Parser::Composed.new
    @transform = Parser::Transform.new
  end

  def check
    syntax    = @parser.parse(@input)
    tree      = @transform.apply(syntax)
    # puts tree.inspect
    assert_equal @transform_output , tree
  end
  
  def test_one_argument
    @input    = '(42)'
    @transform_output = { :argument_list => Parser::IntegerExpression.new(42) }
    @parser = @parser.argument_list
    check
  end

  def test_argument_list
    @input    = '(42, foo)'
    @transform_output = [Parser::IntegerExpression.new(42),
                Parser::NameExpression.new('foo')]
    @parser = @parser.argument_list
    check
  end

  def test_function_call
    @input = 'baz(42, foo)'
    @transform_output = Parser::FuncallExpression.new 'baz', [Parser::IntegerExpression.new(42),
                                          Parser::NameExpression.new('foo')]

    @parser = @parser.function_call
    check
  end

  def test_expression_else
    @input    = <<HERE
4
5
else
HERE
    @transform_output = {:expressions=>[ Parser::IntegerExpression.new(4), Parser::IntegerExpression.new(5)]}
    
    @parser = @parser.expressions_else
    check
  end

  def test_expression_end
    @input    = <<HERE
5
name
call(4,6)
end
HERE
    @transform_output = {:expressions=> [Parser::IntegerExpression.new(5), Parser::NameExpression.new("name"),
      Parser::FuncallExpression.new("call", [Parser::IntegerExpression.new(4), Parser::IntegerExpression.new(6) ]) ] }
    @parser = @parser.expressions_end
    check
  end

  def test_conditional
    @input = <<HERE
if (0) 
  42
else
  667
end
HERE
    @transform_output = Parser::ConditionalExpression.new(  Parser::IntegerExpression.new(0),
                                            [Parser::IntegerExpression.new(42)],
                                            [Parser::IntegerExpression.new(667)])
    @parser = @parser.conditional
    check
  end
  
  def test_function_definition
    @input    = <<HERE
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
    @input    = <<HERE
def foo(x) 
 abba = 5 
end
HERE
    @transform_output = Parser::FunctionExpression.new( "foo", [Parser::NameExpression.new("x")],
                       [Parser::AssignmentExpression.new( "abba", Parser::IntegerExpression.new(5) ) ])
    check
  end
end