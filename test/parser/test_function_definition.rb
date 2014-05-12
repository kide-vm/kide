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
    @parse_output = {:function_definition=>{:name=>"foo"}, 
    :parmeter_list=>[{:parmeter=>{:name=>"x"}}], :expressions=>[{:integer=>"5"}], :end=>"end"}
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
    @parse_output = {:function_definition=>{:name=>"foo"}, 
    :parmeter_list=>[{:parmeter=>{:name=>"x"}}], 
    :expressions=>[{:l=>{:name=>"abba"}, :o=>"= ", :r=>{:integer=>"5"}}], :end=>"end"}
    @transform_output = Ast::FunctionExpression.new(:foo, [Ast::NameExpression.new("x")] , [Ast::OperatorExpression.new("=", Ast::NameExpression.new("abba"),Ast::IntegerExpression.new(5))] )
    @parser = @parser.function_definition
  end

  def test_function_if
    @string_input    = <<HERE
def ofthen(n)
  if(0) 
    42
  else
    667
  end
end
HERE
    @parse_output = {:function_definition=>{:name=>"ofthen"}, 
                  :parmeter_list=>[{:parmeter=>{:name=>"n"}}], 
                  :expressions=>[
                    {:if=>"if", :conditional=>{:integer=>"0"}, 
                    :if_true=>{:expressions=>[{:integer=>"42"}], 
                    :else=>"else"}, 
                    :if_false=>{:expressions=>[{:integer=>"667"}], :end=>"end"}}], :end=>"end"}
    @transform_output = Ast::FunctionExpression.new(:ofthen, 
          [Ast::NameExpression.new("n")] , 
          [Ast::ConditionalExpression.new(Ast::IntegerExpression.new(0), 
            [Ast::IntegerExpression.new(42)],[Ast::IntegerExpression.new(667)] )] )
    @parser = @parser.function_definition
  end

  def test_function_while
    @string_input    = <<HERE
def fibonaccit(n)
  a = 0
  while n do
    1
  end
HERE
    @parse_output = nil
    @transform_output = nil
    @parser = @parser.function_definition
  end    
end