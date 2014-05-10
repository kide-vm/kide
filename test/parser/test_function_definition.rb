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
    @transform_output = Ast::FunctionExpression.new('foo', 
                [Ast::NameExpression.new('x')], 
                [Ast::IntegerExpression.new(5)])
    @parser = @parser.function_definition
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
    @transform_output = Ast::FunctionExpression.new(:foo, [Ast::NameExpression.new("x")] , 
        [Ast::AssignmentExpression.new(Ast::NameExpression.new("abba"), Ast::IntegerExpression.new(5))] )
    @parser = @parser.function_definition
  end

  def ttest_function_while
    @string_input    = <<HERE
def fibonaccit(n)
  a = 0 
  b = 1
  while n > 1 do
    tmp = a
    a = b
    b = tmp + b
    puts b
    n = n - 1
  end
end
HERE
    @parse_output = { :function_definition => { :name => "foo" } , 
                  :parmeter_list => [{ :parmeter => { :name => "x" } }], 
                  :expressions => [ { :asignee => { :name => "abba" }, :asigned => { :integer => "5" } } ]
                }
    @transform_output = Ast::FunctionExpression.new( "foo", [Ast::NameExpression.new("x")],
                           [Ast::AssignmentExpression.new( "abba", Ast::IntegerExpression.new(5) ) ])
    @parser = @parser.function_definition
  end    
end