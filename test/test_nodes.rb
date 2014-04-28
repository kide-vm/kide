require_relative "helper"


# testing that parsing strings that we know to be correct returns the nodes we expect
# in a way the combination of test_parser and test_transform

require_relative 'helper'

class TestNodes < MiniTest::Test

  def setup
    @parser    = Parser::Composed.new
    @transform = Parser::Transform.new
  end

  def check
    syntax    = @parser.parse(@input)
    tree      = @transform.apply(syntax)
    # puts tree.inspect
    assert_equal @expected , tree
  end
  
  def test_number
    @input    = '42 '
    @expected = Parser::IntegerExpression.new(42)
    @parser = @parser.integer
    check
  end

  def test_name
    @input    = 'foo '
    @expected = Parser::NameExpression.new('foo')
    @parser = @parser.name
    check
  end

  def test_one_argument
    @input    = '(42)'
    @expected = { :argument_list => Parser::IntegerExpression.new(42) }
    @parser = @parser.argument_list
    check
  end

  def test_argument_list
    @input    = '(42, foo)'
    @expected = [Parser::IntegerExpression.new(42),
                Parser::NameExpression.new('foo')]
    @parser = @parser.argument_list
    check
  end

  def test_function_call
    @input = 'baz(42, foo)'
    @expected = Parser::FuncallExpression.new 'baz', [Parser::IntegerExpression.new(42),
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
    @expected = {:expressions=>[ Parser::IntegerExpression.new(4), Parser::IntegerExpression.new(5)]}
    
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
    @expected = {:expressions=> [Parser::IntegerExpression.new(5), Parser::NameExpression.new("name"),
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
    @expected = Parser::ConditionalExpression.new(  Parser::IntegerExpression.new(0),
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
    @expected = Parser::FunctionExpression.new('foo', 
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
    @expected = Parser::FunctionExpression.new( "foo", [Parser::NameExpression.new("x")],
                       [Parser::AssignmentExpression.new( "abba", Parser::IntegerExpression.new(5) ) ])
    check
  end
end