require_relative "helper"

class TestFunctionDefinition < MiniTest::Test
  # include the magic (setup and parse -> test method translation), see there
  include ParserHelper
  
  def test_simplest_function
    @string_input    = <<HERE
def foo(x) 
  5
end
HERE
    @parse_output = {:function_definition   => {:name => 'foo'},
                :parmeter_list => [{:parmeter => {:name => 'x'}}],
                :expressions   => [{:integer => '5'}]}
    @transform_output = Parser::FunctionExpression.new('foo', 
                [Parser::NameExpression.new('x')], 
                [Parser::IntegerExpression.new(5)])
  end

  def test_function_assignment
    @string_input    = <<HERE
def foo(x) 
 abba = 5 
end
HERE
    @parse_output = { :function_definition => { :name => "foo" } , 
                  :parmeter_list => [{ :parmeter => { :name => "x" } }], 
                  :expressions => [ { :asignee => { :name => "abba" }, :asigned => { :integer => "5" } } ]
                }
    @transform_output = Parser::FunctionExpression.new( "foo", [Parser::NameExpression.new("x")],
                           [Parser::AssignmentExpression.new( "abba", Parser::IntegerExpression.new(5) ) ])
  end

    
end