require_relative "virtual_helper"

class TestBasic < MiniTest::Test
  # include the magic (setup and parse -> test method translation), see there
  include VirtualHelper
    
  def test_number
    @string_input    = '42 '
    @output = Ast::IntegerExpression.new(42)
    check
  end

  def test_name
    @string_input    = 'foo '
    @output = Ast::NameExpression.new('foo')
    @parser = @parser.name
  end

  def test_name_underscode_start
    @string_input    = '_bar '
    @output = Ast::NameExpression.new('_bar')
    @parser = @parser.name
  end

  def test_name_underscode_middle
    @string_input    = 'foo_bar '
    @parse_output = {:name => 'foo_bar'}
    @output = Ast::NameExpression.new('foo_bar')
    @parser = @parser.name
  end

  def test_instance_variable
    @string_input    = '@foo_bar '
    @parse_output = {:instance_variable=>{:name=>"foo_bar"}}
    @output = Ast::VariableExpression.new(:foo_bar)
    @parser = @parser.instance_variable
  end

  def test_module_name
    @string_input    = 'FooBar '
    @parse_output = {:module_name=>"FooBar"}
    @output = Ast::ModuleName.new("FooBar")
    @parser = @parser.module_name
  end

  def test_comment
    out = "# i am a comment \n"
    @string_input    =  out.dup #NEEDS the return, which is what delimits the comment
    @parse_output = out
    @output = @parse_output #dont transform
    @parser = @parser.comment
  end

  def test_string
    @string_input    = "\"hello\""
    @parse_output =  {:string=>[{:char=>"h"}, {:char=>"e"}, {:char=>"l"}, {:char=>"l"}, {:char=>"o"}]}
    @output =  Ast::StringExpression.new('hello')
    @parser = @parser.string
  end

  def test_string_escapes
    out = 'hello  \nyou'
    @string_input    = '"' + out + '"'
    @parse_output =  {:string=>[{:char=>"h"}, {:char=>"e"}, {:char=>"l"}, {:char=>"l"}, {:char=>"o"}, 
      {:char=>" "}, {:char=>" "}, {:esc=>"n"}, {:char=>"y"}, {:char=>"o"}, {:char=>"u"}]}
    @output =  Ast::StringExpression.new(out)
    @parser = @parser.string
  end

end