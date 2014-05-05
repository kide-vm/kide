require_relative "helper"

class TestArguments < MiniTest::Test
  # include the magic (setup and parse -> test method translation), see there
  include ParserHelper
    
  def test_one_argument
    @string_input    = '(42)'
    @parse_output = {:argument_list => [{:argument => {:integer => '42'}}] }
    @transform_output =  [Ast::IntegerExpression.new(42) ]
    @parser = @parser.argument_list
  end

  def test_argument_list
    @string_input    = '(42, foo)'
    @parse_output = {:argument_list => [{:argument => {:integer => '42'}},
                                      {:argument => {:name   => 'foo'}}]}
    @transform_output = [Ast::IntegerExpression.new(42), Ast::NameExpression.new('foo')]
    @parser = @parser.argument_list
  end

  def test_parmeter
    @string_input = "(foo)"
    @parse_output = {:parmeter_list => [{:parmeter => { :name => "foo"}} ]}
    @transform_output = [Ast::NameExpression.new('foo')]
    @parser = @parser.parmeter_list
  end

  def test_parmeter_list
    @string_input = "( foo , bar)"
    @parse_output = {:parmeter_list => [{:parmeter => { :name => "foo"}},
                                        {:parmeter => { :name => "bar"}} ]}
    @transform_output = [Ast::NameExpression.new('foo') , Ast::NameExpression.new('bar')]
    @parser = @parser.parmeter_list
  end

end