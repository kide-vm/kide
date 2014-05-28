require_relative "helper"

class TestCallSite < MiniTest::Test
  # include the magic (setup and parse -> test method translation), see there
  include ParserHelper
    
  def test_single_argument
    @string_input = 'foo(42)'
    @parse_output = {:call_site => {:name => 'foo'},
             :argument_list    => [{:argument => {:integer => '42'} }] }
    @transform_output = Ast::CallSiteExpression.new 'foo', [Ast::IntegerExpression.new(42)]
    @parser = @parser.call_site
  end

  def test_call_site_multi
    @string_input = 'baz(42, foo)'
    @parse_output = {:call_site => {:name => 'baz' },
                     :argument_list    => [{:argument => {:integer => '42'}},
                                           {:argument => {:name => 'foo'}}]}
    @transform_output = Ast::CallSiteExpression.new 'baz', 
                           [Ast::IntegerExpression.new(42), Ast::NameExpression.new("foo") ]
    @parser = @parser.call_site
  end

  def test_call_site_string
    @string_input    = 'puts( "hello")'
    @parse_output = {:call_site => {:name => 'puts' },
                      :argument_list    => [{:argument => 
                        {:string=>[{:char=>"h"}, {:char=>"e"}, {:char=>"l"}, {:char=>"l"}, {:char=>"o"}]}}]}
    @transform_output = Ast::CallSiteExpression.new "puts", [Ast::StringExpression.new("hello")]
    @parser = @parser.call_site
  end

  def test_call_operator
    @string_input    = 'puts( 3 + 5)'
    @parse_output = {:call_site=>{:name=>"puts"}, :argument_list=>[{:argument=>{:l=>{:integer=>"3"}, :o=>"+ ", :r=>{:integer=>"5"}}}]}
    @transform_output = Ast::CallSiteExpression.new(:puts, [Ast::OperatorExpression.new("+", Ast::IntegerExpression.new(3),Ast::IntegerExpression.new(5))] )
    @parser = @parser.call_site
  end

  def test_call_two_operators
    @string_input    = 'puts(3 + 5 , a - 3)'
    @parse_output = {:call_site=>{:name=>"puts"}, :argument_list=>[{:argument=>{:l=>{:integer=>"3"}, :o=>"+ ", :r=>{:integer=>"5"}}}, {:argument=>{:l=>{:name=>"a"}, :o=>"- ", :r=>{:integer=>"3"}}}]}
    @transform_output = Ast::CallSiteExpression.new(:puts, [Ast::OperatorExpression.new("+", Ast::IntegerExpression.new(3),Ast::IntegerExpression.new(5)),Ast::OperatorExpression.new("-", Ast::NameExpression.new("a"),Ast::IntegerExpression.new(3))] )
    @parser = @parser.call_site
  end

  def test_call_chaining
    @string_input    = 'puts(putint(3 + 5 ), a - 3)'
    @parse_output = {:call_site=>{:name=>"puts"}, :argument_list=>[{:argument=>{:call_site=>{:name=>"putint"}, :argument_list=>[{:argument=>{:l=>{:integer=>"3"}, :o=>"+ ", :r=>{:integer=>"5"}}}]}}, {:argument=>{:l=>{:name=>"a"}, :o=>"- ", :r=>{:integer=>"3"}}}]}
    @transform_output = Ast::CallSiteExpression.new(:puts, [Ast::CallSiteExpression.new(:putint, [Ast::OperatorExpression.new("+", Ast::IntegerExpression.new(3),Ast::IntegerExpression.new(5))] ),Ast::OperatorExpression.new("-", Ast::NameExpression.new("a"),Ast::IntegerExpression.new(3))] )
    @parser = @parser.call_site
  end

end