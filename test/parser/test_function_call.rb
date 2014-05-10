require_relative "helper"

class TestFunctionCall < MiniTest::Test
  # include the magic (setup and parse -> test method translation), see there
  include ParserHelper
    
  def test_single_argument
    @string_input = 'foo(42)'
    @parse_output = {:function_call => {:name => 'foo'},
             :argument_list    => [{:argument => {:integer => '42'} }] }
    @transform_output = Ast::FuncallExpression.new 'foo', [Ast::IntegerExpression.new(42)]
    @parser = @parser.function_call
  end

  def test_function_call_multi
    @string_input = 'baz(42, foo)'
    @parse_output = {:function_call => {:name => 'baz' },
                     :argument_list    => [{:argument => {:integer => '42'}},
                                           {:argument => {:name => 'foo'}}]}
    @transform_output = Ast::FuncallExpression.new 'baz', 
                           [Ast::IntegerExpression.new(42), Ast::NameExpression.new("foo") ]
    @parser = @parser.function_call
  end

  def test_function_call_string
    @string_input    = 'puts( "hello")'
    @parse_output = {:function_call => {:name => 'puts' },
                      :argument_list    => [{:argument => 
                        {:string=>[{:char=>"h"}, {:char=>"e"}, {:char=>"l"}, {:char=>"l"}, {:char=>"o"}]}}]}
    @transform_output = Ast::FuncallExpression.new "puts", [Ast::StringExpression.new("hello")]
    @parser = @parser.function_call
  end

end